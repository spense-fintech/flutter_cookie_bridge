// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_rendering_quality.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class representing the rendering quality of a [PlatformPrintJobController].
class PrintJobRenderingQuality {
  final int _value;
  final int _nativeValue;
  const PrintJobRenderingQuality._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobRenderingQuality._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobRenderingQuality._internal(value, nativeValue());

  ///Renders the printing at the best possible quality, regardless of speed.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  static final BEST = PrintJobRenderingQuality._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  ///Sacrifices the least possible amount of rendering quality for speed to maintain a responsive user interface.
  ///This option should be used only after establishing that best quality rendering does indeed make the user interface unresponsive.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  static final RESPONSIVE =
      PrintJobRenderingQuality._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  ///Set of all values of [PrintJobRenderingQuality].
  static final Set<PrintJobRenderingQuality> values = [
    PrintJobRenderingQuality.BEST,
    PrintJobRenderingQuality.RESPONSIVE,
  ].toSet();

  ///Gets a possible [PrintJobRenderingQuality] instance from [int] value.
  static PrintJobRenderingQuality? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobRenderingQuality.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [PrintJobRenderingQuality] instance from a native value.
  static PrintJobRenderingQuality? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobRenderingQuality.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets [int] value.
  int toValue() => _value;

  ///Gets [int] native value.
  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'BEST';
      case 1:
        return 'RESPONSIVE';
    }
    return _value.toString();
  }
}
