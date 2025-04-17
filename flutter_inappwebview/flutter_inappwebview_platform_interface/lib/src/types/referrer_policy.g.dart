// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referrer_policy.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents a Referrer-Policy HTTP header.
///It could be used with [ScriptHtmlTagAttributes] and [CSSLinkHtmlTagAttributes]
///when fetching a resource `<link>` or a `<script>` (or resources fetched by the `<script>`).
class ReferrerPolicy {
  final String _value;
  final String _nativeValue;
  const ReferrerPolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ReferrerPolicy._internalMultiPlatform(
          String value, Function nativeValue) =>
      ReferrerPolicy._internal(value, nativeValue());

  ///The Referer header will not be sent.
  static const NO_REFERRER =
      ReferrerPolicy._internal('no-referrer', 'no-referrer');

  ///The Referer header will not be sent to origins without TLS (HTTPS).
  static const NO_REFERRER_WHEN_DOWNGRADE = ReferrerPolicy._internal(
      'no-referrer-when-downgrade', 'no-referrer-when-downgrade');

  ///The sent referrer will be limited to the origin of the referring page: its scheme, host, and port.
  static const ORIGIN = ReferrerPolicy._internal('origin', 'origin');

  ///The referrer sent to other origins will be limited to the scheme, the host, and the port.
  ///Navigations on the same origin will still include the path.
  static const ORIGIN_WHEN_CROSS_ORIGIN = ReferrerPolicy._internal(
      'origin-when-cross-origin', 'origin-when-cross-origin');

  ///A referrer will be sent for same origin, but cross-origin requests will contain no referrer information.
  static const SAME_ORIGIN =
      ReferrerPolicy._internal('same-origin', 'same-origin');

  ///Only send the origin of the document as the referrer when the protocol security level stays the same (e.g. HTTPS -> HTTPS),
  ///but don't send it to a less secure destination (e.g. HTTPS -> HTTP).
  static const STRICT_ORIGIN =
      ReferrerPolicy._internal('strict-origin', 'strict-origin');

  ///Send a full URL when performing a same-origin request, but only send the origin when the protocol security level stays the same (e.g.HTTPS -> HTTPS),
  ///and send no header to a less secure destination (e.g. HTTPS -> HTTP).
  static const STRICT_ORIGIN_WHEN_CROSS_ORIGIN = ReferrerPolicy._internal(
      'strict-origin-when-cross-origin', 'strict-origin-when-cross-origin');

  ///The referrer will include the origin and the path (but not the fragment, password, or username).
  ///This value is unsafe, because it leaks origins and paths from TLS-protected resources to insecure origins.
  static const UNSAFE_URL =
      ReferrerPolicy._internal('unsafe-url', 'unsafe-url');

  ///Set of all values of [ReferrerPolicy].
  static final Set<ReferrerPolicy> values = [
    ReferrerPolicy.NO_REFERRER,
    ReferrerPolicy.NO_REFERRER_WHEN_DOWNGRADE,
    ReferrerPolicy.ORIGIN,
    ReferrerPolicy.ORIGIN_WHEN_CROSS_ORIGIN,
    ReferrerPolicy.SAME_ORIGIN,
    ReferrerPolicy.STRICT_ORIGIN,
    ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN,
    ReferrerPolicy.UNSAFE_URL,
  ].toSet();

  ///Gets a possible [ReferrerPolicy] instance from [String] value.
  static ReferrerPolicy? fromValue(String? value) {
    if (value != null) {
      try {
        return ReferrerPolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [ReferrerPolicy] instance from a native value.
  static ReferrerPolicy? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ReferrerPolicy.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets [String] value.
  String toValue() => _value;

  ///Gets [String] native value.
  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
