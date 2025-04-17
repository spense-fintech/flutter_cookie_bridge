// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_request_network_service_type.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents the constants that specify how a request uses network resources.
class URLRequestNetworkServiceType {
  final int _value;
  final int _nativeValue;
  const URLRequestNetworkServiceType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLRequestNetworkServiceType._internalMultiPlatform(
          int value, Function nativeValue) =>
      URLRequestNetworkServiceType._internal(value, nativeValue());

  ///A service type for streaming audio/video data.
  static const AV_STREAMING = URLRequestNetworkServiceType._internal(8, 8);

  ///A service type for background traffic.
  ///
  ///You should specify this type if your app is performing a download that was not requested by the user—for example,
  ///prefetching content so that it will be available when the user chooses to view it.
  static const BACKGROUND = URLRequestNetworkServiceType._internal(3, 3);

  ///A service type for call signaling.
  ///
  ///Use this service type with network traffic that establishes, maintains, or tears down a VoIP call.
  static const CALL_SIGNALING = URLRequestNetworkServiceType._internal(11, 11);

  ///A service type for standard network traffic.
  static const DEFAULT = URLRequestNetworkServiceType._internal(0, 0);

  ///A service type for responsive (time-sensitive) audio/video data.
  static const RESPONSIVE_AV = URLRequestNetworkServiceType._internal(9, 9);

  ///A service type for data that the user is actively waiting for.
  ///
  ///Use this service type for interactive situations where the user is anticipating a quick response, like instant messaging or completing a purchase.
  static const RESPONSIVE_DATA = URLRequestNetworkServiceType._internal(6, 6);

  ///A service type for video traffic.
  static const VIDEO = URLRequestNetworkServiceType._internal(2, 2);

  ///A service type for voice traffic.
  static const VOICE = URLRequestNetworkServiceType._internal(4, 4);

  ///Set of all values of [URLRequestNetworkServiceType].
  static final Set<URLRequestNetworkServiceType> values = [
    URLRequestNetworkServiceType.AV_STREAMING,
    URLRequestNetworkServiceType.BACKGROUND,
    URLRequestNetworkServiceType.CALL_SIGNALING,
    URLRequestNetworkServiceType.DEFAULT,
    URLRequestNetworkServiceType.RESPONSIVE_AV,
    URLRequestNetworkServiceType.RESPONSIVE_DATA,
    URLRequestNetworkServiceType.VIDEO,
    URLRequestNetworkServiceType.VOICE,
  ].toSet();

  ///Gets a possible [URLRequestNetworkServiceType] instance from [int] value.
  static URLRequestNetworkServiceType? fromValue(int? value) {
    if (value != null) {
      try {
        return URLRequestNetworkServiceType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [URLRequestNetworkServiceType] instance from a native value.
  static URLRequestNetworkServiceType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return URLRequestNetworkServiceType.values
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
      case 8:
        return 'AV_STREAMING';
      case 3:
        return 'BACKGROUND';
      case 11:
        return 'CALL_SIGNALING';
      case 0:
        return 'DEFAULT';
      case 9:
        return 'RESPONSIVE_AV';
      case 6:
        return 'RESPONSIVE_DATA';
      case 2:
        return 'VIDEO';
      case 4:
        return 'VOICE';
    }
    return _value.toString();
  }
}

///An iOS-specific Class that represents the constants that specify how a request uses network resources.
///Use [URLRequestNetworkServiceType] instead.
@Deprecated('Use URLRequestNetworkServiceType instead')
class IOSURLRequestNetworkServiceType {
  final int _value;
  final int _nativeValue;
  const IOSURLRequestNetworkServiceType._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSURLRequestNetworkServiceType._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSURLRequestNetworkServiceType._internal(value, nativeValue());

  ///A service type for streaming audio/video data.
  static const AV_STREAMING = IOSURLRequestNetworkServiceType._internal(8, 8);

  ///A service type for background traffic.
  ///
  ///You should specify this type if your app is performing a download that was not requested by the user—for example,
  ///prefetching content so that it will be available when the user chooses to view it.
  static const BACKGROUND = IOSURLRequestNetworkServiceType._internal(3, 3);

  ///A service type for call signaling.
  ///
  ///Use this service type with network traffic that establishes, maintains, or tears down a VoIP call.
  static const CALL_SIGNALING =
      IOSURLRequestNetworkServiceType._internal(11, 11);

  ///A service type for standard network traffic.
  static const DEFAULT = IOSURLRequestNetworkServiceType._internal(0, 0);

  ///A service type for responsive (time-sensitive) audio/video data.
  static const RESPONSIVE_AV = IOSURLRequestNetworkServiceType._internal(9, 9);

  ///A service type for data that the user is actively waiting for.
  ///
  ///Use this service type for interactive situations where the user is anticipating a quick response, like instant messaging or completing a purchase.
  static const RESPONSIVE_DATA =
      IOSURLRequestNetworkServiceType._internal(6, 6);

  ///A service type for video traffic.
  static const VIDEO = IOSURLRequestNetworkServiceType._internal(2, 2);

  ///A service type for voice traffic.
  static const VOICE = IOSURLRequestNetworkServiceType._internal(4, 4);

  ///Set of all values of [IOSURLRequestNetworkServiceType].
  static final Set<IOSURLRequestNetworkServiceType> values = [
    IOSURLRequestNetworkServiceType.AV_STREAMING,
    IOSURLRequestNetworkServiceType.BACKGROUND,
    IOSURLRequestNetworkServiceType.CALL_SIGNALING,
    IOSURLRequestNetworkServiceType.DEFAULT,
    IOSURLRequestNetworkServiceType.RESPONSIVE_AV,
    IOSURLRequestNetworkServiceType.RESPONSIVE_DATA,
    IOSURLRequestNetworkServiceType.VIDEO,
    IOSURLRequestNetworkServiceType.VOICE,
  ].toSet();

  ///Gets a possible [IOSURLRequestNetworkServiceType] instance from [int] value.
  static IOSURLRequestNetworkServiceType? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestNetworkServiceType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [IOSURLRequestNetworkServiceType] instance from a native value.
  static IOSURLRequestNetworkServiceType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestNetworkServiceType.values
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
      case 8:
        return 'AV_STREAMING';
      case 3:
        return 'BACKGROUND';
      case 11:
        return 'CALL_SIGNALING';
      case 0:
        return 'DEFAULT';
      case 9:
        return 'RESPONSIVE_AV';
      case 6:
        return 'RESPONSIVE_DATA';
      case 2:
        return 'VIDEO';
      case 4:
        return 'VOICE';
    }
    return _value.toString();
  }
}
