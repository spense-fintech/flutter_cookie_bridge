// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safe_browsing_threat.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents the reason the resource was caught by Safe Browsing.
class SafeBrowsingThreat {
  final int _value;
  final int _nativeValue;
  const SafeBrowsingThreat._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory SafeBrowsingThreat._internalMultiPlatform(
          int value, Function nativeValue) =>
      SafeBrowsingThreat._internal(value, nativeValue());

  ///The resource was blocked because it may trick the user into a billing agreement.
  ///
  ///This constant is only used when `targetSdkVersion` is at least Android 29.
  ///Otherwise, [SAFE_BROWSING_THREAT_UNKNOWN] is used instead.
  static const SAFE_BROWSING_THREAT_BILLING =
      SafeBrowsingThreat._internal(4, 4);

  ///The resource was blocked because it contains malware.
  static const SAFE_BROWSING_THREAT_MALWARE =
      SafeBrowsingThreat._internal(1, 1);

  ///The resource was blocked because it contains deceptive content.
  static const SAFE_BROWSING_THREAT_PHISHING =
      SafeBrowsingThreat._internal(2, 2);

  ///The resource was blocked for an unknown reason.
  static const SAFE_BROWSING_THREAT_UNKNOWN =
      SafeBrowsingThreat._internal(0, 0);

  ///The resource was blocked because it contains unwanted software.
  static const SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE =
      SafeBrowsingThreat._internal(3, 3);

  ///Set of all values of [SafeBrowsingThreat].
  static final Set<SafeBrowsingThreat> values = [
    SafeBrowsingThreat.SAFE_BROWSING_THREAT_BILLING,
    SafeBrowsingThreat.SAFE_BROWSING_THREAT_MALWARE,
    SafeBrowsingThreat.SAFE_BROWSING_THREAT_PHISHING,
    SafeBrowsingThreat.SAFE_BROWSING_THREAT_UNKNOWN,
    SafeBrowsingThreat.SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE,
  ].toSet();

  ///Gets a possible [SafeBrowsingThreat] instance from [int] value.
  static SafeBrowsingThreat? fromValue(int? value) {
    if (value != null) {
      try {
        return SafeBrowsingThreat.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [SafeBrowsingThreat] instance from a native value.
  static SafeBrowsingThreat? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return SafeBrowsingThreat.values
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
      case 4:
        return 'SAFE_BROWSING_THREAT_BILLING';
      case 1:
        return 'SAFE_BROWSING_THREAT_MALWARE';
      case 2:
        return 'SAFE_BROWSING_THREAT_PHISHING';
      case 0:
        return 'SAFE_BROWSING_THREAT_UNKNOWN';
      case 3:
        return 'SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE';
    }
    return _value.toString();
  }
}
