import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'session_manager.dart';

class WebView extends StatefulWidget {
  final String url;
  final String cookie;
  final Map<String, dynamic>? options;

  // GlobalKey to access the state of the WebViewManager
  static final GlobalKey<CustomWebViewState> globalKey = GlobalKey<CustomWebViewState>();

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

    var sessionCookies = await _sessionManager.getSessionCookies();
    if (sessionCookies.isNotEmpty) {
      String cookieString = sessionCookies.join('; ');

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

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
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
      },
    );
  }
}
