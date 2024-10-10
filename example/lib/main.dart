import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/network_manager.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'custom_webview_screen.dart';

final cookieBridge = FlutterCookieBridge();

void main() async {
  await dotenv.load(fileName: "lib/.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final String? baseUrl = dotenv.env['BASE_URL'];

  final NetworkManager _networkManager = NetworkManager();
   @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    var savedCookies = await cookieBridge.getSessionCookies();
    if (savedCookies.isNotEmpty) {
      String allCookies = savedCookies.join('; ');
      print("Session found, navigating to WebViewScreen...");
      print("All saved cookies: $allCookies");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomWebViewScreen(
            key: UniqueKey(),
            url: '$baseUrl/api/user/session',
            cookie: allCookies,
          ),
        ),
      );
    } else {
      print("No session found, staying on login screen...");
    }
  }

  Future<Response?> sso(
      Map<String, dynamic> requestBody, Map<String, dynamic> headers) async {
    try {
      print("Sending request to get token\n$requestBody");
      print("Sending request to $baseUrl/api/user/sso/");
      print("headers: $headers");

      Response? response = await _networkManager.request(
        url: '$baseUrl/api/user/sso/',
        method: 'POST',
        body: requestBody,
        headers: headers,
      );

      print("Response from login request: ${response?.data}");
      return response;
    } catch (e) {
      print('Error during login request to get token: $e');
      return null;
    }
  }

  Future<Response?> login(Map<String, dynamic> requestBody) async {
    try {
      print("Sending token request with body: $requestBody");

      Response? response = await _networkManager.request(
        url: '$baseUrl/api/user/token/',
        method: 'POST',
        body: requestBody,
      );

      print("Response from token API: ${response?.data}");
      return response;
    } catch (e) {
      print('Error during token request: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: _loginAndNavigate,
          child: Text('Login'),
        ),
      ),
    );
  }

  Future<void> _loginAndNavigate() async {
    var loginRequestBody = {
      "phone": dotenv.env['PHONE'],
      "email": dotenv.env['EMAIL'],
      "attributes": {
        "name": dotenv.env['NAME'],
        "photo": dotenv.env['PHOTO'],
        "accountId": dotenv.env['ACCOUNT_ID'],
      },
      "module": dotenv.env['MODULE'],
      "device_binded": dotenv.env['DEVICE_BINDED'],
    };

    var loginResponse = await sso(
      loginRequestBody,
      {
        'Content-Type': 'application/json',
        'username': dotenv.env['USERNAME'],
        'password': dotenv.env['PASSWORD'],
        'kid': dotenv.env['KID'],
      },
    );

    if (loginResponse != null && loginResponse.statusCode == 200) {
      var token = loginResponse.data['token'];
      var tokenResponse = await login({"token": token});

      if (tokenResponse != null && tokenResponse.statusCode == 200) {
        var cookiesHeader = tokenResponse.headers['set-cookie'];
        List<String> savedCookies = [];

        if (cookiesHeader != null) {
          for (var cookie in cookiesHeader) {
            var cookieValue = cookie.split(';')[0];

            if (cookieValue.isNotEmpty &&
                !cookieValue.startsWith('redirect_url=')) {
              savedCookies.add(cookieValue);
            }
          }
        }

        // await sessionManager.saveSessionCookies(savedCookies);

        if (savedCookies.isNotEmpty) {
          String allCookies = savedCookies.join('; ');
          print("All cookies going to WebView: $allCookies");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomWebViewScreen(
                key: UniqueKey(),
                url: '$baseUrl/api/user/session',
                cookie: allCookies,
              ),
            ),
          );
        }
      }
    }
  }
}
