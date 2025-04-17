// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_response_action.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that is used by [PlatformWebViewCreationParams.onNavigationResponse] event.
///It represents the policy to pass back to the decision handler.
class NavigationResponseAction {
  final int _value;
  final int _nativeValue;
  const NavigationResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory NavigationResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      NavigationResponseAction._internal(value, nativeValue());

  ///Allow the navigation to continue.
  static const ALLOW = NavigationResponseAction._internal(1, 1);

  ///Cancel the navigation.
  static const CANCEL = NavigationResponseAction._internal(0, 0);

  ///Turn the navigation into a download.
  ///
  ///**NOTE**: available only on iOS 14.5+. It will fallback to [CANCEL].
  static const DOWNLOAD = NavigationResponseAction._internal(2, 2);

  ///Set of all values of [NavigationResponseAction].
  static final Set<NavigationResponseAction> values = [
    NavigationResponseAction.ALLOW,
    NavigationResponseAction.CANCEL,
    NavigationResponseAction.DOWNLOAD,
  ].toSet();

  ///Gets a possible [NavigationResponseAction] instance from [int] value.
  static NavigationResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return NavigationResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [NavigationResponseAction] instance from a native value.
  static NavigationResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return NavigationResponseAction.values
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
      case 1:
        return 'ALLOW';
      case 0:
        return 'CANCEL';
      case 2:
        return 'DOWNLOAD';
    }
    return _value.toString();
  }
}

///Class that is used by [PlatformWebViewCreationParams.onNavigationResponse] event.
///It represents the policy to pass back to the decision handler.
///Use [NavigationResponseAction] instead.
@Deprecated('Use NavigationResponseAction instead')
class IOSNavigationResponseAction {
  final int _value;
  final int _nativeValue;
  const IOSNavigationResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSNavigationResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSNavigationResponseAction._internal(value, nativeValue());

  ///Allow the navigation to continue.
  static const ALLOW = IOSNavigationResponseAction._internal(1, 1);

  ///Cancel the navigation.
  static const CANCEL = IOSNavigationResponseAction._internal(0, 0);

  ///Set of all values of [IOSNavigationResponseAction].
  static final Set<IOSNavigationResponseAction> values = [
    IOSNavigationResponseAction.ALLOW,
    IOSNavigationResponseAction.CANCEL,
  ].toSet();

  ///Gets a possible [IOSNavigationResponseAction] instance from [int] value.
  static IOSNavigationResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSNavigationResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [IOSNavigationResponseAction] instance from a native value.
  static IOSNavigationResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSNavigationResponseAction.values
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
      case 1:
        return 'ALLOW';
      case 0:
        return 'CANCEL';
    }
    return _value.toString();
  }
}
