// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ajax_request_headers.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the HTTP headers of an [AjaxRequest].
class AjaxRequestHeaders {
  Map<String, dynamic> _headers;
  Map<String, dynamic> _newHeaders = {};
  AjaxRequestHeaders(this._headers);

  ///Gets a possible [AjaxRequestHeaders] instance from a [Map] value.
  static AjaxRequestHeaders? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return AjaxRequestHeaders(map);
  }

  ///Gets the HTTP headers of the [AjaxRequest].
  Map<String, dynamic> getHeaders() {
    return this._headers;
  }

  ///Sets/updates an HTTP header of the [AjaxRequest]. If there is already an existing [header] with the same name, the values are merged into one single request header.
  ///For security reasons, some headers can only be controlled by the user agent.
  ///These headers include the [forbidden header names](https://developer.mozilla.org/en-US/docs/Glossary/Forbidden_header_name)
  ///and [forbidden response header names](https://developer.mozilla.org/en-US/docs/Glossary/Forbidden_response_header_name).
  void setRequestHeader(String header, String value) {
    _newHeaders[header] = value;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return _newHeaders;
  }

  @override
  String toString() {
    return 'AjaxRequestHeaders{headers: $_headers, requestHeaders: $_newHeaders}';
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
