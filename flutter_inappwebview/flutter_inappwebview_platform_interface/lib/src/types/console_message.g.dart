// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_message.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class representing a JavaScript console message from WebCore.
///This could be a issued by a call to one of the console logging functions (e.g. console.log('...')) or a JavaScript error on the page.
///
///To receive notifications of these messages, use the [PlatformWebViewCreationParams.onConsoleMessage] event.
class ConsoleMessage {
  ///Console message
  String message;

  ///Console message level
  ConsoleMessageLevel messageLevel;
  ConsoleMessage(
      {this.message = "", this.messageLevel = ConsoleMessageLevel.LOG});

  ///Gets a possible [ConsoleMessage] instance from a [Map] value.
  static ConsoleMessage? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ConsoleMessage();
    instance.message = map['message'];
    instance.messageLevel =
        ConsoleMessageLevel.fromNativeValue(map['messageLevel'])!;
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "messageLevel": messageLevel.toNativeValue(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ConsoleMessage{message: $message, messageLevel: $messageLevel}';
  }
}
