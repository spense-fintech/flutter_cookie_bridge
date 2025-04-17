// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_before_unload_response.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the response used by the [PlatformWebViewCreationParams.onJsBeforeUnload] event to control a JavaScript alert dialog.
class JsBeforeUnloadResponse {
  ///Action used to confirm that the user hit confirm or cancel button.
  JsBeforeUnloadResponseAction? action;

  ///Title of the cancel button.
  String cancelButtonTitle;

  ///Title of the confirm button.
  String confirmButtonTitle;

  ///Whether the client will handle the alert dialog.
  bool handledByClient;

  ///Message to be displayed in the window.
  String message;
  JsBeforeUnloadResponse(
      {this.action = JsBeforeUnloadResponseAction.CONFIRM,
      this.cancelButtonTitle = "",
      this.confirmButtonTitle = "",
      this.handledByClient = false,
      this.message = ""});

  ///Gets a possible [JsBeforeUnloadResponse] instance from a [Map] value.
  static JsBeforeUnloadResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsBeforeUnloadResponse();
    instance.action =
        JsBeforeUnloadResponseAction.fromNativeValue(map['action']);
    instance.cancelButtonTitle = map['cancelButtonTitle'];
    instance.confirmButtonTitle = map['confirmButtonTitle'];
    instance.handledByClient = map['handledByClient'];
    instance.message = map['message'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "cancelButtonTitle": cancelButtonTitle,
      "confirmButtonTitle": confirmButtonTitle,
      "handledByClient": handledByClient,
      "message": message,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'JsBeforeUnloadResponse{action: $action, cancelButtonTitle: $cancelButtonTitle, confirmButtonTitle: $confirmButtonTitle, handledByClient: $handledByClient, message: $message}';
  }
}
