import 'package:dio/dio.dart';
import 'SessionManager.dart';

class NetworkManager {
  SessionManager? sessionManager;

  static final NetworkManager _instance = NetworkManager._internal();
  late Dio _dio;

  factory NetworkManager({SessionManager? sessionManager}) {
    return _instance;
  }

  NetworkManager._internal() {
    _dio = Dio();
  }

  void setSessionManager(SessionManager sessionManager) {
    this.sessionManager = sessionManager;
  }

  Future<Response?> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Options? options,
  }) async {
    try {
      headers = headers ?? {};
      options = options ?? Options(headers: headers);

      List<String>? savedCookies = await sessionManager?.getSessionCookies();
      if (savedCookies!.isNotEmpty) {
        headers['Cookie'] = savedCookies.join('; ');
      }

      Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(url, data: body, options: options);
          break;
        case 'GET':
          response = await _dio.get(url, options: options);
          break;
        case 'PUT':
          response = await _dio.put(url, data: body, options: options);
          break;
        case 'PATCH':
          response = await _dio.patch(url, data: body, options: options);
          break;
        case 'DELETE':
          response = await _dio.delete(url, data: body, options: options);
          break;
        default:
          throw UnsupportedError("Method not supported: $method");
      }
      _storeResponseCookies(response);
      return response;
    } catch (e) {
      print("Error during network request: $e");
      return null;
    }
  }

  void _storeResponseCookies(Response response) {
    if (response.headers['set-cookie'] != null) {
      List<String> cookiesList = response.headers['set-cookie']!;

      print(" cookies response header is : $cookiesList");

      List<String> filteredCookies = [];

      for (String cookie in cookiesList) {
        String actualCookie = cookie.split(';')[0];

        if (actualCookie.isNotEmpty &&
            !actualCookie.contains('redirect_url=')) {
          filteredCookies.add(actualCookie);
        }
      }

      if (filteredCookies.isNotEmpty) {
        print("Filtered cookies to be stored: $filteredCookies");
        sessionManager?.saveSessionCookies(filteredCookies);
      } else {
        print("No valid cookies to store.");
      }
    }
  }

  Future<Response?> get(String url,
      {Map<String, dynamic>? headers, Options? options}) {
    return request(url: url, method: 'GET', headers: headers, options: options);
  }

  Future<Response?> post(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? headers, Options? options}) {
    return request(
        url: url,
        method: 'POST',
        body: body,
        headers: headers,
        options: options);
  }

  Future<Response?> put(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? headers, Options? options}) {
    return request(
        url: url,
        method: 'PUT',
        body: body,
        headers: headers,
        options: options);
  }

  Future<Response?> patch(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? headers, Options? options}) {
    return request(
        url: url,
        method: 'PATCH',
        body: body,
        headers: headers,
        options: options);
  }

  Future<Response?> delete(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? body,
      Options? options}) {
    return request(
        url: url,
        method: 'DELETE',
        body: body,
        headers: headers,
        options: options);
  }
}
