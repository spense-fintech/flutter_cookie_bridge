// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screenshot_configuration.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the configuration data to use when generating an image from a web view’s contents using [PlatformInAppWebViewController.takeScreenshot].
class ScreenshotConfiguration {
  ///A Boolean value that indicates whether to take the snapshot after incorporating any pending screen updates.
  ///The default value of this property is `true`, which causes the web view to incorporate any recent changes to the view’s content and then generate the snapshot.
  ///If you change the value to `false`, the `WebView` takes the snapshot immediately, and before incorporating any new changes.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS 13.0+
  ///- MacOS 10.15+
  bool afterScreenUpdates;

  ///The compression format of the captured image.
  ///The default value is [CompressFormat.PNG].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Windows
  CompressFormat compressFormat;

  ///Use [afterScreenUpdates] instead.
  @Deprecated('Use afterScreenUpdates instead')
  bool? iosAfterScreenUpdates;

  ///Hint to the compressor, `0-100`. The value is interpreted differently depending on the [CompressFormat].
  ///[CompressFormat.PNG] is lossless, so this value is ignored.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Windows
  int quality;

  ///The portion of your web view to capture, specified as a rectangle in the view’s coordinate system.
  ///The default value of this property is `null`, which captures everything in the view’s bounds rectangle.
  ///If you specify a custom rectangle, it must lie within the bounds rectangle of the `WebView` object.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Windows
  InAppWebViewRect? rect;

  ///The width of the captured image, in points.
  ///Use this property to scale the generated image to the specified width.
  ///The web view maintains the aspect ratio of the captured content, but scales it to match the width you specify.
  ///
  ///The default value of this property is `null`, which returns an image whose size matches the original size of the captured rectangle.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  double? snapshotWidth;
  ScreenshotConfiguration(
      {this.rect,
      this.snapshotWidth,
      this.compressFormat = CompressFormat.PNG,
      this.quality = 100,
      @Deprecated("Use afterScreenUpdates instead") this.iosAfterScreenUpdates,
      this.afterScreenUpdates = true}) {
    assert(this.quality >= 0);
    this.afterScreenUpdates = this.iosAfterScreenUpdates != null
        ? this.iosAfterScreenUpdates!
        : this.afterScreenUpdates;
  }

  ///Gets a possible [ScreenshotConfiguration] instance from a [Map] value.
  static ScreenshotConfiguration? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ScreenshotConfiguration(
      iosAfterScreenUpdates: map['afterScreenUpdates'],
      rect: InAppWebViewRect.fromMap(map['rect']?.cast<String, dynamic>()),
      snapshotWidth: map['snapshotWidth'],
    );
    instance.afterScreenUpdates = map['afterScreenUpdates'];
    instance.compressFormat =
        CompressFormat.fromNativeValue(map['compressFormat'])!;
    instance.quality = map['quality'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "afterScreenUpdates": afterScreenUpdates,
      "compressFormat": compressFormat.toNativeValue(),
      "quality": quality,
      "rect": rect?.toMap(),
      "snapshotWidth": snapshotWidth,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ScreenshotConfiguration{afterScreenUpdates: $afterScreenUpdates, compressFormat: $compressFormat, quality: $quality, rect: $rect, snapshotWidth: $snapshotWidth}';
  }
}
