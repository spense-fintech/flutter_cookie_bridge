import 'dart:async';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

///{@macro flutter_inappwebview_platform_interface.PlatformProcessGlobalConfig}
class ProcessGlobalConfig {
  ///{@macro flutter_inappwebview_platform_interface.PlatformProcessGlobalConfig}
  ProcessGlobalConfig()
      : this.fromPlatformCreationParams(
          const PlatformProcessGlobalConfigCreationParams(),
        );

  /// Constructs a [ProcessGlobalConfig] from creation params for a specific
  /// platform.
  ProcessGlobalConfig.fromPlatformCreationParams(
    PlatformProcessGlobalConfigCreationParams params,
  ) : this.fromPlatform(PlatformProcessGlobalConfig(params));

  /// Constructs a [ProcessGlobalConfig] from a specific platform
  /// implementation.
  ProcessGlobalConfig.fromPlatform(this.platform);

  /// Implementation of [PlatformProcessGlobalConfig] for the current platform.
  final PlatformProcessGlobalConfig platform;

  static ProcessGlobalConfig? _instance;

  ///Gets the [ProcessGlobalConfig] shared instance.
  static ProcessGlobalConfig instance() {
    if (_instance == null) {
      _instance = ProcessGlobalConfig();
    }
    return _instance!;
  }

  ///{@macro flutter_inappwebview_platform_interface.PlatformProcessGlobalConfig.apply}
  Future<void> apply({required ProcessGlobalConfigSettings settings}) =>
      platform.apply(settings: settings);
}
