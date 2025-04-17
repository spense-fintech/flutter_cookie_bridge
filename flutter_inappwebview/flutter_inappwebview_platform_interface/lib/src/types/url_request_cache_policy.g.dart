// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_request_cache_policy.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents the constants used to specify interaction with the cached responses.
class URLRequestCachePolicy {
  final int _value;
  final int _nativeValue;
  const URLRequestCachePolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLRequestCachePolicy._internalMultiPlatform(
          int value, Function nativeValue) =>
      URLRequestCachePolicy._internal(value, nativeValue());

  ///Ignore local cache data, and instruct proxies and other intermediates to disregard their caches so far as the protocol allows.
  ///
  ///**NOTE**: Versions earlier than macOS 15, iOS 13, watchOS 6, and tvOS 13 don’t implement this constant.
  static const RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA =
      URLRequestCachePolicy._internal(4, 4);

  ///The URL load should be loaded only from the originating source.
  ///This policy specifies that no existing cache data should be used to satisfy a URL load request.
  ///
  ///**NOTE**: Always use this policy if you are making HTTP or HTTPS byte-range requests.
  static const RELOAD_IGNORING_LOCAL_CACHE_DATA =
      URLRequestCachePolicy._internal(1, 1);

  ///Use cache data if the origin source can validate it; otherwise, load from the origin.
  ///
  ///**NOTE**: Versions earlier than macOS 15, iOS 13, watchOS 6, and tvOS 13 don’t implement this constant.
  static const RELOAD_REVALIDATING_CACHE_DATA =
      URLRequestCachePolicy._internal(5, 5);

  ///Use existing cache data, regardless or age or expiration date, and fail if no cached data is available.
  ///
  ///If there is no existing data in the cache corresponding to a URL load request,
  ///no attempt is made to load the data from the originating source, and the load is considered to have failed.
  ///This constant specifies a behavior that is similar to an “offline” mode.
  static const RETURN_CACHE_DATA_DONT_LOAD =
      URLRequestCachePolicy._internal(3, 3);

  ///Use existing cache data, regardless or age or expiration date, loading from originating source only if there is no cached data.
  static const RETURN_CACHE_DATA_ELSE_LOAD =
      URLRequestCachePolicy._internal(2, 2);

  ///Use the caching logic defined in the protocol implementation, if any, for a particular URL load request.
  ///This is the default policy for URL load requests.
  static const USE_PROTOCOL_CACHE_POLICY =
      URLRequestCachePolicy._internal(0, 0);

  ///Set of all values of [URLRequestCachePolicy].
  static final Set<URLRequestCachePolicy> values = [
    URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
    URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA,
    URLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA,
    URLRequestCachePolicy.RETURN_CACHE_DATA_DONT_LOAD,
    URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD,
    URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
  ].toSet();

  ///Gets a possible [URLRequestCachePolicy] instance from [int] value.
  static URLRequestCachePolicy? fromValue(int? value) {
    if (value != null) {
      try {
        return URLRequestCachePolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [URLRequestCachePolicy] instance from a native value.
  static URLRequestCachePolicy? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return URLRequestCachePolicy.values
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
        return 'RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA';
      case 1:
        return 'RELOAD_IGNORING_LOCAL_CACHE_DATA';
      case 5:
        return 'RELOAD_REVALIDATING_CACHE_DATA';
      case 3:
        return 'RETURN_CACHE_DATA_DONT_LOAD';
      case 2:
        return 'RETURN_CACHE_DATA_ELSE_LOAD';
      case 0:
        return 'USE_PROTOCOL_CACHE_POLICY';
    }
    return _value.toString();
  }
}

///An iOS-specific Class that represents the constants used to specify interaction with the cached responses.
///Use [URLRequestCachePolicy] instead.
@Deprecated('Use URLRequestCachePolicy instead')
class IOSURLRequestCachePolicy {
  final int _value;
  final int _nativeValue;
  const IOSURLRequestCachePolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSURLRequestCachePolicy._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSURLRequestCachePolicy._internal(value, nativeValue());

  ///Ignore local cache data, and instruct proxies and other intermediates to disregard their caches so far as the protocol allows.
  ///
  ///**NOTE**: Versions earlier than macOS 15, iOS 13, watchOS 6, and tvOS 13 don’t implement this constant.
  static const RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA =
      IOSURLRequestCachePolicy._internal(4, 4);

  ///The URL load should be loaded only from the originating source.
  ///This policy specifies that no existing cache data should be used to satisfy a URL load request.
  ///
  ///**NOTE**: Always use this policy if you are making HTTP or HTTPS byte-range requests.
  static const RELOAD_IGNORING_LOCAL_CACHE_DATA =
      IOSURLRequestCachePolicy._internal(1, 1);

  ///Use cache data if the origin source can validate it; otherwise, load from the origin.
  ///
  ///**NOTE**: Versions earlier than macOS 15, iOS 13, watchOS 6, and tvOS 13 don’t implement this constant.
  static const RELOAD_REVALIDATING_CACHE_DATA =
      IOSURLRequestCachePolicy._internal(5, 5);

  ///Use existing cache data, regardless or age or expiration date, and fail if no cached data is available.
  ///
  ///If there is no existing data in the cache corresponding to a URL load request,
  ///no attempt is made to load the data from the originating source, and the load is considered to have failed.
  ///This constant specifies a behavior that is similar to an “offline” mode.
  static const RETURN_CACHE_DATA_DONT_LOAD =
      IOSURLRequestCachePolicy._internal(3, 3);

  ///Use existing cache data, regardless or age or expiration date, loading from originating source only if there is no cached data.
  static const RETURN_CACHE_DATA_ELSE_LOAD =
      IOSURLRequestCachePolicy._internal(2, 2);

  ///Use the caching logic defined in the protocol implementation, if any, for a particular URL load request.
  ///This is the default policy for URL load requests.
  static const USE_PROTOCOL_CACHE_POLICY =
      IOSURLRequestCachePolicy._internal(0, 0);

  ///Set of all values of [IOSURLRequestCachePolicy].
  static final Set<IOSURLRequestCachePolicy> values = [
    IOSURLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
    IOSURLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA,
    IOSURLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA,
    IOSURLRequestCachePolicy.RETURN_CACHE_DATA_DONT_LOAD,
    IOSURLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD,
    IOSURLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
  ].toSet();

  ///Gets a possible [IOSURLRequestCachePolicy] instance from [int] value.
  static IOSURLRequestCachePolicy? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestCachePolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [IOSURLRequestCachePolicy] instance from a native value.
  static IOSURLRequestCachePolicy? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestCachePolicy.values
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
        return 'RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA';
      case 1:
        return 'RELOAD_IGNORING_LOCAL_CACHE_DATA';
      case 5:
        return 'RELOAD_REVALIDATING_CACHE_DATA';
      case 3:
        return 'RETURN_CACHE_DATA_DONT_LOAD';
      case 2:
        return 'RETURN_CACHE_DATA_ELSE_LOAD';
      case 0:
        return 'USE_PROTOCOL_CACHE_POLICY';
    }
    return _value.toString();
  }
}
