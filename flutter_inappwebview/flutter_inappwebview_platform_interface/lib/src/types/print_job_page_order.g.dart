// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_page_order.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class representing the page order that will be used to generate the pages of a [PlatformPrintJobController].
class PrintJobPageOrder {
  final int _value;
  final int _nativeValue;
  const PrintJobPageOrder._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobPageOrder._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobPageOrder._internal(value, nativeValue());

  ///Ascending (back to front) page order.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  static final ASCENDING = PrintJobPageOrder._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  ///Descending (front to back) page order.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  static final DESCENDING = PrintJobPageOrder._internalMultiPlatform(-1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return -1;
      default:
        break;
    }
    return null;
  });

  ///The spooler does not rearrange pages—they are printed in the order received by the spooler.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  static final SPECIAL = PrintJobPageOrder._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  ///No page order specified.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  static final UNKNOWN = PrintJobPageOrder._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  ///Set of all values of [PrintJobPageOrder].
  static final Set<PrintJobPageOrder> values = [
    PrintJobPageOrder.ASCENDING,
    PrintJobPageOrder.DESCENDING,
    PrintJobPageOrder.SPECIAL,
    PrintJobPageOrder.UNKNOWN,
  ].toSet();

  ///Gets a possible [PrintJobPageOrder] instance from [int] value.
  static PrintJobPageOrder? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobPageOrder.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [PrintJobPageOrder] instance from a native value.
  static PrintJobPageOrder? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobPageOrder.values
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
        return 'ASCENDING';
      case -1:
        return 'DESCENDING';
      case 0:
        return 'SPECIAL';
      case 2:
        return 'UNKNOWN';
    }
    return _value.toString();
  }
}
