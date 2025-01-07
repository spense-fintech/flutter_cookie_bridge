import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/WebViewCallback.dart';
import 'package:flutter_cookie_bridge/network_manager.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
import 'package:flutter_cookie_bridge/web_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'custom_webview_screen.dart';

final cookieBridge = FlutterCookieBridge();

void main() async {
  await dotenv.load(fileName: "lib/.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  final String? baseUrl = dotenv.env['BASE_URL'];

  final NetworkManager _networkManager = NetworkManager();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    Response? response = await _networkManager.get('$baseUrl/api/user/session');
    Map<String, dynamic> responseMap = response?.data;
    if (responseMap.containsKey("user")) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CustomWebViewScreen(
      //         key: UniqueKey(), url: '$baseUrl/api/user/session'),
      //   ),
      // );
      _openWebView();
    }
  }

  Future<Response?> sso(
      Map<String, dynamic> requestBody, Map<String, dynamic> headers) async {
    try {
      Response? response = await _networkManager.request(
        url: '$baseUrl/api/user/sso/',
        method: 'POST',
        body: requestBody,
        headers: headers,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error during login request to get token: $e');
      }
      return null;
    }
  }

  Future<Response?> login(Map<String, dynamic> requestBody) async {
    try {
      Response? response = await _networkManager.request(
        url: '$baseUrl/api/user/token/',
        method: 'POST',
        body: requestBody,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error during token request: $e');
      }
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

  Future<void> _openWebView() async {
    final webView = await cookieBridge.getWebView(
      url: "https://sbmsmartbankinguat.esbeeyem.com:9443/banking/sbm/credit_card/CRE",
      callback: (WebViewCallback action) {
        switch (action.type) {
          case WebViewCallbackType.redirect:
            print("--------------- Redirect Redirected with status main: ${action.status}");
            break;
          case WebViewCallbackType.logout:
            print("--------------- Redirect User logged out main");
            break;
        }
      },
      whitelistedUrls: [],
      hostName: "https://sbmsmartbankinguat.esbeeyem.com:9443",
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => webView,
    ));
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

    print(loginResponse);

    if (loginResponse != null && loginResponse.statusCode == 200) {
      var token = loginResponse.data['token'];
      var tokenResponse = await login({"token": token});

      if (tokenResponse != null && tokenResponse.statusCode == 200) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CustomWebViewScreen(
        //         key: UniqueKey(), url: '$baseUrl/banking/sbm/credit_card/CRE'),
        //   ),
        // );
        _openWebView();
      }
    }
  }
}
