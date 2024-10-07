import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'SessionManager.dart';

class WebViewManager extends StatefulWidget {
  final String url;
  final String cookie;
  final Map<String, dynamic>? options;

  WebViewManager({
    required this.url,
    required this.cookie,
    this.options, 
  });

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<WebViewManager> {
  late InAppWebViewController webViewController;
  String? _currentUrl;
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
  }

  @override
  void dispose() {
    super.dispose();
    webViewController.dispose();
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

    headers['Cookie'] = widget.cookie;

    return headers;
  }

  InAppWebViewSettings _buildWebViewSettings() {
    return InAppWebViewSettings(
      cacheEnabled: widget.options?['cacheEnabled'] ?? true,
      javaScriptEnabled: widget.options?['javaScriptEnabled'] ?? true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url),
          headers: _buildHeaders(), 
        ),
        initialSettings: _buildWebViewSettings(), 
        onWebViewCreated: (controller) async {
          webViewController = controller;
          await _syncCookiesToWebView();
        },
        onLoadStop: (controller, url) async {
          _currentUrl = url?.toString();
          await _syncCookiesToWebView();
        },
      ),
    );
  }
}
