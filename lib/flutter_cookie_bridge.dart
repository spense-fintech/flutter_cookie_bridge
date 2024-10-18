import 'package:flutter_cookie_bridge/WebViewCallback.dart';
import 'package:flutter_cookie_bridge/web_view.dart';

import 'network_manager.dart';
import 'session_manager.dart';
export 'WebViewCallBack.dart';
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

  void clearSession() {
    _sessionManager.clearSession();
  }

 Future<WebView> getWebView(
      {required String url, Map<String, dynamic>? options, 
             WebViewCallbackFunction? callback,

}) async {
    List<String> cookies = await _sessionManager.getSessionCookies();
    String cookie = "";
    if (cookies.isNotEmpty) {
      cookie = cookies.join('; ');
    }
    _webView = WebView(url: url, cookie: cookie, options: options,onCallback: callback);
    return _webView;
  }

  Future<String?> getPlatformVersion() {
    return FlutterCookieBridgePlatform.instance.getPlatformVersion();
  }
}
