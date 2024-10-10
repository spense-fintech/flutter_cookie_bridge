import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge_platform_interface.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCookieBridgePlatform
    with MockPlatformInterfaceMixin
    implements FlutterCookieBridgePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterCookieBridgePlatform initialPlatform =
      FlutterCookieBridgePlatform.instance;

  test('$MethodChannelFlutterCookieBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterCookieBridge>());
  });

  test('getPlatformVersion', () async {
    FlutterCookieBridge flutterCookieBridgePlugin = FlutterCookieBridge();
    MockFlutterCookieBridgePlatform fakePlatform =
        MockFlutterCookieBridgePlatform();
    FlutterCookieBridgePlatform.instance = fakePlatform;

    expect(await flutterCookieBridgePlugin.getPlatformVersion(), '42');
  });
}
