import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';
import 'web_message_port.dart';

///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageChannel}
class WebMessageChannel {
  ///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageChannel}
  WebMessageChannel(
      {required String id,
      required WebMessagePort port1,
      required WebMessagePort port2})
      : this.fromPlatformCreationParams(
            params: PlatformWebMessageChannelCreationParams(
                id: id, port1: port1.platform, port2: port2.platform));

  /// Constructs a [WebMessageChannel].
  ///
  /// See [WebMessageChannel.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  WebMessageChannel.fromPlatformCreationParams({
    required PlatformWebMessageChannelCreationParams params,
  }) : this.fromPlatform(platform: PlatformWebMessageChannel(params));

  /// Constructs a [WebMessageChannel] from a specific platform implementation.
  WebMessageChannel.fromPlatform({required this.platform});

  /// Implementation of [PlatformWebMessageChannel] for the current platform.
  final PlatformWebMessageChannel platform;

  static WebMessageChannel? fromMap(Map<String, dynamic>? map) {
    PlatformWebMessageChannel? platform =
        PlatformWebMessageChannel.static().fromMap(map);
    if (platform == null) {
      return null;
    }
    return WebMessageChannel.fromPlatform(platform: platform);
  }

  ///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageChannel.id}
  String get id => platform.id;

  ///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageChannel.port1}
  WebMessagePort get port1 =>
      WebMessagePort.fromPlatform(platform: platform.port1);

  ///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageChannel.port2}
  WebMessagePort get port2 =>
      WebMessagePort.fromPlatform(platform: platform.port2);

  ///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageChannel.dispose}
  void dispose() => platform.dispose();

  @override
  String toString() => platform.toString();
}
