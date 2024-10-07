import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_cookie_bridge_platform_interface.dart';

/// An implementation of [FlutterCookieBridgePlatform] that uses method channels.
class MethodChannelFlutterCookieBridge extends FlutterCookieBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_cookie_bridge');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
