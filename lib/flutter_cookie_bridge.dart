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
  WebView? _preloadedWebView;
  bool _isPreloading = false;

  Future<void> clearSession() async {
    await _sessionManager.clearSession();
  }

  Future<void> preloadWebView({
    required String baseUrl,
    Map<String, dynamic>? options,
  }) async {
    if (_isPreloading) {
      print("WebView is already being preloaded, skipping duplicate request");
      return;
    }

    _isPreloading = true;

    try {
      // Clear any existing cookies first
      await _sessionManager.clearSession();

      List<String> cookies = await _sessionManager.getSessionCookies();
      String cookie = "";
      if (cookies.isNotEmpty) {
        cookie = cookies.join('; ');
      }

      // Creating a preloaded WebView
      _preloadedWebView = await WebView(
          key: GlobalKey<CustomWebViewState>(),
          url: baseUrl,
          cookie: cookie,
          options: options,
          onCallback: null,
          whitelistedUrlsAndroid: null,
          whitelistedUrlsIos: null,
          hostName: baseUrl,
          onPageFinished: null
      );

      print("WebView preloaded successfully with URL: $baseUrl");
    } catch (e) {
      print("Error preloading WebView: $e");
      _preloadedWebView = null;
    } finally {
      _isPreloading = false;
    }
  }


  Future<WebView> getWebView(
      {required String url,
        Map<String, dynamic>? options,
        WebViewCallbackFunction? callback,
        List<String>? whitelistedUrlsAndroid,
        List<String>? whitelistedUrlsIos,
        String? hostName,
        VoidCallback? onPageFinished,
        bool usePreloaded = false
      }) async {
    List<String> cookies = await _sessionManager.getSessionCookies();
    String cookie = "";
    if (cookies.isNotEmpty) {
      cookie = cookies.join('; ');
    }

    if (usePreloaded && _preloadedWebView != null) {
      try {
        await _preloadedWebView!.updateWebView(
            url: url,
            cookie: cookie,
            options: options,
            callback: callback,
            whitelistedUrlsAndroid: whitelistedUrlsAndroid,
            whitelistedUrlsIos: whitelistedUrlsIos,
            hostName: hostName,
            onPageFinished: onPageFinished
        );

        WebView webViewToReturn = _preloadedWebView!;
        _preloadedWebView = null; // Reset preloaded WebView after using it
        return webViewToReturn;
      } catch (e) {
        print("Error updating preloaded WebView: $e, falling back to creating new WebView");
      }
    }
    _webView = await WebView(
        key: GlobalKey<CustomWebViewState>(),
        url: url,
        cookie: cookie,
        options: options,
        onCallback: callback,
        whitelistedUrlsAndroid: whitelistedUrlsAndroid,
        whitelistedUrlsIos: whitelistedUrlsIos,
        hostName: hostName,
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