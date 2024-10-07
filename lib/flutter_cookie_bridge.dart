
import 'flutter_cookie_bridge_platform_interface.dart';

class FlutterCookieBridge {
  Future<String?> getPlatformVersion() {
    return FlutterCookieBridgePlatform.instance.getPlatformVersion();
  }
}
