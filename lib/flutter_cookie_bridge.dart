import 'package:flutter/cupertino.dart';
import 'package:flutter_cookie_bridge/web_view.dart';
import 'package:flutter_cookie_bridge/web_view_callback.dart';

import 'network_manager.dart';
import 'session_manager.dart';
import 'flutter_cookie_bridge_platform_interface.dart';

class FlutterCookieBridge {
  FlutterCookieBridge._internal() {
    networkManager = NetworkManager(sessionManager: _sessionManager);
  }

  static final FlutterCookieBridge _instance = FlutterCookieBridge._internal();

  factory FlutterCookieBridge() {
    return _instance;
  }

  late final NetworkManager networkManager;
  final _sessionManager = SessionManager();
  late WebView _webView;

  Future<void> clearSession() async {
    await _sessionManager.clearSession();
  }

  Future<WebView> getWebView(
      {required String url,
      Map<String, dynamic>? options,
      WebViewCallbackFunction? callback,
      List<String>? whitelistedUrls,
      String? hostName,
      List<String>? iOSBrowserRedirectDomains,
      VoidCallback? onPageFinished}) async {
    List<String> cookies = await _sessionManager.getSessionCookies();
    String cookie = "";
    if (cookies.isNotEmpty) {
      cookie = cookies.join('; ');
    }
    _webView = await WebView(
        key: GlobalKey<CustomWebViewState>(),
        url: url,
        cookie: cookie,
        options: options,
        onCallback: callback,
        whitelistedUrls: whitelistedUrls,
        hostName: hostName,
        iOSBrowserRedirectDomains: iOSBrowserRedirectDomains,
        onPageFinished: onPageFinished);

    return _webView;
  }

  Future<List<String>> checkSession() {
    return _sessionManager.getSessionCookies();
  }

  Future<String?> getPlatformVersion() {
    return FlutterCookieBridgePlatform.instance.getPlatformVersion();
  }
}
