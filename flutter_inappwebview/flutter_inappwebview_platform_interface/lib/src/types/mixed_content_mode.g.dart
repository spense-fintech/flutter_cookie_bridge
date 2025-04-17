// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixed_content_mode.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class used to configure the WebView's behavior when a secure origin attempts to load a resource from an insecure origin.
class MixedContentMode {
  final int _value;
  final int _nativeValue;
  const MixedContentMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory MixedContentMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      MixedContentMode._internal(value, nativeValue());

  ///In this mode, the WebView will allow a secure origin to load content from any other origin, even if that origin is insecure.
  ///This is the least secure mode of operation for the WebView, and where possible apps should not set this mode.
  static const MIXED_CONTENT_ALWAYS_ALLOW = MixedContentMode._internal(0, 0);

  ///In this mode, the WebView will attempt to be compatible with the approach of a modern web browser with regard to mixed content.
  ///Some insecure content may be allowed to be loaded by a secure origin and other types of content will be blocked.
  ///The types of content are allowed or blocked may change release to release and are not explicitly defined.
  ///This mode is intended to be used by apps that are not in control of the content that they render but desire to operate in a reasonably secure environment.
  ///For highest security, apps are recommended to use [MixedContentMode.MIXED_CONTENT_NEVER_ALLOW].
  static const MIXED_CONTENT_COMPATIBILITY_MODE =
      MixedContentMode._internal(2, 2);

  ///In this mode, the WebView will not allow a secure origin to load content from an insecure origin.
  ///This is the preferred and most secure mode of operation for the WebView and apps are strongly advised to use this mode.
  static const MIXED_CONTENT_NEVER_ALLOW = MixedContentMode._internal(1, 1);

  ///Set of all values of [MixedContentMode].
  static final Set<MixedContentMode> values = [
    MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
  ].toSet();

  ///Gets a possible [MixedContentMode] instance from [int] value.
  static MixedContentMode? fromValue(int? value) {
    if (value != null) {
      try {
        return MixedContentMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [MixedContentMode] instance from a native value.
  static MixedContentMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return MixedContentMode.values
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
        return 'MIXED_CONTENT_ALWAYS_ALLOW';
      case 2:
        return 'MIXED_CONTENT_COMPATIBILITY_MODE';
      case 1:
        return 'MIXED_CONTENT_NEVER_ALLOW';
    }
    return _value.toString();
  }
}

///An Android-specific class used to configure the WebView's behavior when a secure origin attempts to load a resource from an insecure origin.
///
///**NOTE**: available on Android 21+.
///
///Use [MixedContentMode] instead.
@Deprecated('Use MixedContentMode instead')
class AndroidMixedContentMode {
  final int _value;
  final int _nativeValue;
  const AndroidMixedContentMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidMixedContentMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidMixedContentMode._internal(value, nativeValue());

  ///In this mode, the WebView will allow a secure origin to load content from any other origin, even if that origin is insecure.
  ///This is the least secure mode of operation for the WebView, and where possible apps should not set this mode.
  static const MIXED_CONTENT_ALWAYS_ALLOW =
      AndroidMixedContentMode._internal(0, 0);

  ///In this mode, the WebView will attempt to be compatible with the approach of a modern web browser with regard to mixed content.
  ///Some insecure content may be allowed to be loaded by a secure origin and other types of content will be blocked.
  ///The types of content are allowed or blocked may change release to release and are not explicitly defined.
  ///This mode is intended to be used by apps that are not in control of the content that they render but desire to operate in a reasonably secure environment.
  ///For highest security, apps are recommended to use [AndroidMixedContentMode.MIXED_CONTENT_NEVER_ALLOW].
  static const MIXED_CONTENT_COMPATIBILITY_MODE =
      AndroidMixedContentMode._internal(2, 2);

  ///In this mode, the WebView will not allow a secure origin to load content from an insecure origin.
  ///This is the preferred and most secure mode of operation for the WebView and apps are strongly advised to use this mode.
  static const MIXED_CONTENT_NEVER_ALLOW =
      AndroidMixedContentMode._internal(1, 1);

  ///Set of all values of [AndroidMixedContentMode].
  static final Set<AndroidMixedContentMode> values = [
    AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    AndroidMixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    AndroidMixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
  ].toSet();

  ///Gets a possible [AndroidMixedContentMode] instance from [int] value.
  static AndroidMixedContentMode? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidMixedContentMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [AndroidMixedContentMode] instance from a native value.
  static AndroidMixedContentMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidMixedContentMode.values
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
        return 'MIXED_CONTENT_ALWAYS_ALLOW';
      case 2:
        return 'MIXED_CONTENT_COMPATIBILITY_MODE';
      case 1:
        return 'MIXED_CONTENT_NEVER_ALLOW';
    }
    return _value.toString();
  }
}
