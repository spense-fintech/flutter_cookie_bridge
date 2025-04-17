// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributed_string_text_effect_style.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents the supported proxy types.
class AttributedStringTextEffectStyle {
  final String _value;
  final String _nativeValue;
  const AttributedStringTextEffectStyle._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory AttributedStringTextEffectStyle._internalMultiPlatform(
          String value, Function nativeValue) =>
      AttributedStringTextEffectStyle._internal(value, nativeValue());

  ///A graphical text effect that gives glyphs the appearance of letterpress printing, which involves pressing the type into the paper.
  static const LETTERPRESS_STYLE = AttributedStringTextEffectStyle._internal(
      'letterpressStyle', 'letterpressStyle');

  ///Set of all values of [AttributedStringTextEffectStyle].
  static final Set<AttributedStringTextEffectStyle> values = [
    AttributedStringTextEffectStyle.LETTERPRESS_STYLE,
  ].toSet();

  ///Gets a possible [AttributedStringTextEffectStyle] instance from [String] value.
  static AttributedStringTextEffectStyle? fromValue(String? value) {
    if (value != null) {
      try {
        return AttributedStringTextEffectStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [AttributedStringTextEffectStyle] instance from a native value.
  static AttributedStringTextEffectStyle? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return AttributedStringTextEffectStyle.values
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

///An iOS-specific Class that represents the supported proxy types.
///Use [AttributedStringTextEffectStyle] instead.
@Deprecated('Use AttributedStringTextEffectStyle instead')
class IOSNSAttributedStringTextEffectStyle {
  final String _value;
  final String _nativeValue;
  const IOSNSAttributedStringTextEffectStyle._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSNSAttributedStringTextEffectStyle._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSNSAttributedStringTextEffectStyle._internal(value, nativeValue());

  ///A graphical text effect that gives glyphs the appearance of letterpress printing, which involves pressing the type into the paper.
  static const LETTERPRESS_STYLE =
      IOSNSAttributedStringTextEffectStyle._internal(
          'letterpressStyle', 'letterpressStyle');

  ///Set of all values of [IOSNSAttributedStringTextEffectStyle].
  static final Set<IOSNSAttributedStringTextEffectStyle> values = [
    IOSNSAttributedStringTextEffectStyle.LETTERPRESS_STYLE,
  ].toSet();

  ///Gets a possible [IOSNSAttributedStringTextEffectStyle] instance from [String] value.
  static IOSNSAttributedStringTextEffectStyle? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSNSAttributedStringTextEffectStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [IOSNSAttributedStringTextEffectStyle] instance from a native value.
  static IOSNSAttributedStringTextEffectStyle? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return IOSNSAttributedStringTextEffectStyle.values
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
