import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/web_view_callback.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'session_manager.dart';

class WebView extends StatefulWidget {
  final String url;
  final String cookie;
  final Map<String, dynamic>? options;
  late final Function(WebViewCallback)? onCallback;
  final List<String>? whitelistedUrls;
  final String? hostName;

  // GlobalKey to access the state of the WebViewManager
  static final GlobalKey<CustomWebViewState> globalKey =
      GlobalKey<CustomWebViewState>();

  WebView({
    Key? key,
    required this.url,
    required this.cookie,
    this.options,
    this.onCallback,
    this.whitelistedUrls,
    this.hostName,
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
  Map<String, String>? _headers;

  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  Future<void> _syncCookiesToWebView() async {
    Uri? uri = Uri.tryParse(_currentUrl!);
    String? domain = uri?.host;

    String decodedCookie = Uri.decodeComponent(widget.cookie);

    List<String> cookieParts = decodedCookie.split('=');
    if (cookieParts.length == 2) {
      String cookieName = cookieParts[0];
      String cookieValue = cookieParts[1];

      await CookieManager.instance().setCookie(
        url: WebUri(_currentUrl!),
        name: cookieName,
        value: cookieValue,
        domain: domain,
        path: '/',
      );
    }
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
    Uri uri = navigationAction.request.url!;
    String url = uri.toString();

    // Get whitelisted URLs and hostname from widget, with fallback to empty values
    final whitelistedUrls = widget.whitelistedUrls ?? [];
    final hostName = widget.hostName ?? '';

    if (url.contains("session-expired")) {
      widget.onCallback?.call(WebViewCallback.logout());
      await logout(context);
      return NavigationActionPolicy.CANCEL;
    }

    if (url.contains('/redirect?status=')) {
      String? status = uri.queryParameters['status'];
      if (status != null) {
        widget.onCallback?.call(WebViewCallback.redirect(status));
        if (await _webViewController!.canGoBack()) {
          await _webViewController!.goBack();
        } else {
          Navigator.of(context).pop();
        }
        return NavigationActionPolicy.CANCEL;
      }
    }

    for (String whitelistedUrl in whitelistedUrls) {
      if (url.contains(whitelistedUrl) ||
          (hostName.isNotEmpty && url.contains(hostName))) {
        return NavigationActionPolicy.ALLOW;
      }
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }

    return NavigationActionPolicy.CANCEL;
  }

  Future<bool> _onWillPop() async {
    if (_webViewController != null && await _webViewController!.canGoBack()) {
      await _webViewController!.goBack();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(_currentUrl!),
          headers: _headers,
        ),
        initialSettings: _buildWebViewSettings(),
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          await _syncCookiesToWebView();
        },
        onLoadStart: (controller, url) async {
          await _syncCookiesToWebView();
        },
        onLoadStop: (controller, url) async {
          _currentUrl = url?.toString();
          setState(() {});

          // if (_currentUrl!.contains('/logout')) {
          //   await logout(context);
          // } else if (_currentUrl!.contains('/redirect')) {
          //   Uri uri = Uri.parse(_currentUrl!);
          //
          //   String? status = uri.queryParameters['status'];
          //
          //   if (status != null) {
          //     widget.onCallback?.call(WebViewCallback.redirect(status));
          //     if (await _webViewController!.canGoBack()) {
          //       await _webViewController!.goBack();
          //     } else {
          //       Navigator.of(context).pop();
          //     }
          //   }
          // }
        },
        shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
      ),
    );
  }
}
