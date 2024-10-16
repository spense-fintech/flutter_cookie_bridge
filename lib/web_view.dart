import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'session_manager.dart';
import 'LibraryConstants.dart';

class WebView extends StatefulWidget {
  final String url;
  final String cookie;
  final Map<String, dynamic>? options;

  // GlobalKey to access the state of the WebViewManager
  static final GlobalKey<CustomWebViewState> globalKey =
      GlobalKey<CustomWebViewState>();

  WebView({
    Key? key,
    required this.url,
    required this.cookie,
    this.options,
  }) : super(key: globalKey);

  Future<void> loadUrl(String url) async {
    final state = globalKey.currentState;
    if (state != null) {
      await state.loadUrl(url);
    }
  }

  Future<void> logout(BuildContext context) async {
    final state = globalKey.currentState;
    if (state != null) {
      await state.logout(context);
    }
  }

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<WebView> {
  InAppWebViewController? _webViewController;
  String? _currentUrl;
  String? _currentCookie;
  bool _canGoBack = false;

  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _currentCookie = widget.cookie;
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  Future<void> _syncCookiesToWebView() async {
    Uri? uri = Uri.tryParse(_currentUrl!);
    String? domain = uri?.host;
    print("domain is $domain");

    var sessionCookies = await _sessionManager.getSessionCookies();
    if (sessionCookies.isNotEmpty) {
      String cookieString = sessionCookies.join('; ');
      print("cookie String is $cookieString");
      await CookieManager.instance().setCookie(
        url: WebUri(_currentUrl!),
        name: 'cookie',
        value: cookieString,
        domain: domain,
        path: '/',
      );
    }
  }

  Map<String, String> _buildHeaders() {
    Map<String, String> headers = {};
    if (widget.options != null && widget.options!['headers'] != null) {
      headers.addAll(Map<String, String>.from(widget.options!['headers']));
    }

    headers['Cookie'] = _currentCookie ?? widget.cookie;
    return headers;
  }

  InAppWebViewSettings _buildWebViewSettings() {
    return InAppWebViewSettings(
      cacheEnabled: widget.options?['cacheEnabled'] ?? true,
      javaScriptEnabled: widget.options?['javaScriptEnabled'] ?? true,
      domStorageEnabled: true,
      allowFileAccess: true,
      geolocationEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      userAgent:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 _Partner_Flutter",
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );
  }

  Future<void> loadUrl(String url) async {
    if (_webViewController != null) {
      await _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(url)),
      );
      setState(() {
        _currentUrl = url;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    await _sessionManager.clearSession();
    await CookieManager.instance().deleteAllCookies();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    //url checking from library constants temporarily
    print("checking URL whiteListing");
    Uri uri = navigationAction.request.url!;
    String url = uri.toString();

    for (String whitelistedUrl in LibraryConstants.whitelistedUrls) {
      print("checking whitelisted url : $whitelistedUrl");
      if (url.contains(whitelistedUrl) ||
          url.contains(LibraryConstants.hostName)) {
        return NavigationActionPolicy.ALLOW;
      }
    }

    if (url.contains("session-expired")) {
      await logout(context);
      //Navigator.of(context).pop();
      print("session expired part is executed");
      return NavigationActionPolicy.CANCEL;
    }

    return NavigationActionPolicy.ALLOW;
  }

  // void _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch $url');
  //   }
  // }

  Future<bool> _onWillPop() async {
    if (_webViewController != null && await _webViewController!.canGoBack()) {
      await _webViewController!.goBack();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(_currentUrl!),
          headers: _buildHeaders(),
        ),
        initialSettings: _buildWebViewSettings(),
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          await _syncCookiesToWebView();
        },
        onLoadStop: (controller, url) async {
          _currentUrl = url?.toString();

          await _syncCookiesToWebView();

          bool canGoBack = await _webViewController?.canGoBack() ?? false;

          setState(() {
            _canGoBack = canGoBack;
          });
        },
        shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
      ),
    );
  }
}
