import 'NetworkManager.dart';
import 'SessionManager.dart';
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

  Future<List<String>> getSessionCookies() async {
    return await _sessionManager.getSessionCookies();
  }

    clearSession() {
      _sessionManager.clearSession();
    }

  Future<String?> getPlatformVersion() {
    return FlutterCookieBridgePlatform.instance.getPlatformVersion();
  }
}
