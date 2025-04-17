// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_process_gone_detail.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that provides more specific information about why the render process exited.
///It is used by the [PlatformWebViewCreationParams.onRenderProcessGone] event.
class RenderProcessGoneDetail {
  ///Indicates whether the render process was observed to crash, or whether it was killed by the system.
  ///
  ///If the render process was killed, this is most likely caused by the system being low on memory.
  bool didCrash;

  /// Returns the renderer priority that was set at the time that the renderer exited. This may be greater than the priority that
  /// any individual `WebView` requested using [].
  RendererPriority? rendererPriorityAtExit;
  RenderProcessGoneDetail(
      {required this.didCrash, this.rendererPriorityAtExit});

  ///Gets a possible [RenderProcessGoneDetail] instance from a [Map] value.
  static RenderProcessGoneDetail? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = RenderProcessGoneDetail(
      didCrash: map['didCrash'],
      rendererPriorityAtExit:
          RendererPriority.fromNativeValue(map['rendererPriorityAtExit']),
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "didCrash": didCrash,
      "rendererPriorityAtExit": rendererPriorityAtExit?.toNativeValue(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'RenderProcessGoneDetail{didCrash: $didCrash, rendererPriorityAtExit: $rendererPriorityAtExit}';
  }
}
