import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/web_view_callback.dart';
import 'package:flutter_cookie_bridge/network_manager.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
import 'package:flutter_cookie_bridge_example/DeviceInfoManager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  final DeviceInfoManager _deviceInfoManager = DeviceInfoManager();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    print("Checking session");
    Response? response = await _networkManager.get('$baseUrl/api/user/session');
    Map<String, dynamic> responseMap = response?.data;
    if (responseMap.containsKey("user")) {
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
        url: '$baseUrl/api/user/token',
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

  Future<String> createToken() async {
    final String clientId = dotenv.env['KID']!;

    final Map<String, Object> headers = {
      'kid': clientId,
      'typ': 'JWT',
      'alg': 'HS256',
    };

    // final Map<String, String> attributes = {
    //   'name': "Sukesh Bairy",
    //   'photo': "",
    // };
    // const Duration expirationDuration = Duration(milliseconds: 300000);
    // final clientSecret = dotenv.env['CLIENT_SECRET'];
    // final jwt = JWT(
    //   {
    //     'email': "sukeshbairy@gmail.com",
    //     'phone': "9686853769",
    //     'attributes': attributes,
    //     'module': "/banking/sbm/credit_card/CRE",
    //   },
    //   header: headers,
    // );

    final Map<String, String> attributes = {
      'name': "Varun Jha",
      'photo': "",
    };
    const Duration expirationDuration = Duration(milliseconds: 300000);
    final clientSecret = dotenv.env['CLIENT_SECRET'];
    final jwt = JWT(
      {
        'email': "jha.varun6@gmail.com",
        'phone': "7979945216",
        'attributes': attributes,
        'module': "/banking/sbm/credit_card/CRE",
      },
      header: headers,
    );

    String token = await jwt.sign(
      SecretKey(clientSecret!),
      expiresIn: expirationDuration,
    );

    print("Token generated FROM client side is: $token");

    return token;
  }

  Future<void> open(BuildContext context, String module, String token,
      WebViewCallbackFunction? callback) async {
    try {
      String bank = "";

      if (module.contains("banking/")) {
        int startIndex = module.indexOf("banking/") + "banking/".length;
        String temp = module.substring(startIndex);
        int endIndex = temp.indexOf("/");
        bank = endIndex == -1 ? temp : temp.substring(0, endIndex);
      }
      await _loginAndNavigateToWebView(module, bank, context, token, callback!);
    } catch (e) {
      debugPrint('Error opening webview: $e');
      rethrow;
    }
  }

  Future<void> _loginAndNavigateToWebView(
    String module,
    String bank,
    BuildContext context,
    String token,
    WebViewCallbackFunction callback,
  ) async {
    try {
      await cookieBridge.clearSession();
      final tokenResponse = await _networkManager.request(
          url: "https://sbmsmartbankinguat.esbeeyem.com:9443/api/user/token",
          method: 'POST',
          body: {"token": token});

      print("token Response is: $tokenResponse");

      if (tokenResponse?.statusCode == 200 &&
          tokenResponse?.data['code'] == "USER_LOGIN_SUCCESS") {
        final cookies = await cookieBridge.checkSession();

        if (cookies.isEmpty) {
          throw Exception('Session not established after login');
        }

        await _checkDeviceBinding(context, bank, module, callback);
      } else {
        debugPrint('Error during login: $tokenResponse');
        // rethrow;
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }

  Future<void> _checkDeviceBinding(BuildContext context, String bank,
      String url, WebViewCallbackFunction callback) async {
    // if (LibraryConstants.deviceBindingEnabled) {
    //   // TODO Build the device binding flow
    // } else {
    //Skip device binding and bind device to session
    await _setupDeviceSession(context, bank, url, callback);
    // }
  }

  Future<void> _setupDeviceSession(BuildContext context, String bank,
      String url, WebViewCallbackFunction callback) async {
    try {
      Map<String, String> deviceInfo = await _deviceInfoManager.getDeviceInfo();
      final packageInfo = await PackageInfo.fromPlatform();
      if (kDebugMode) {
        print("Device Info: $deviceInfo");
        print("Package Info: $packageInfo");
      }
      final bindDeviceToSessionResponse = await _networkManager.request(
          url:
              "https://sbmsmartbankinguat.esbeeyem.com:9443/api/device/sbm/session",
          method: 'POST',
          body: {
            "manufacturer": deviceInfo["manufacturer"]!,
            "model": deviceInfo["model"]!,
            "device_uuid": deviceInfo["device_uuid"]!,
            "os": Platform.isAndroid ? "Android" : "iOS",
            "os_version": deviceInfo["os_version"]!,
            "app_version": packageInfo.version,
          });
      print("bind device to session response $bindDeviceToSessionResponse");
      if (bindDeviceToSessionResponse?.statusCode == 200) {
        await _openWebView();
      } else {
        debugPrint(
            'Error setting up device session: $bindDeviceToSessionResponse');
        await _openWebView();
      }
    } catch (e) {
      debugPrint('Error setting up device session: $e');
      rethrow;
    }
  }

  Future<void> _openWebView() async {
    final cookiesBefore = await cookieBridge.checkSession();
    print('Cookies before WebView: $cookiesBefore');
    final webView = await cookieBridge.getWebView(
      url:
          "https://sbmsmartbankinguat.esbeeyem.com:9443/banking/sbm/credit_card/CRE",
      callback: (WebViewCallback action) {
        switch (action.type) {
          case WebViewCallbackType.redirect:
            print(
                "--------------- Redirect Redirected with status main: ${action.status}");
            break;
          case WebViewCallbackType.logout:
            print("--------------- Redirect User logged out main");
            break;
        }
      },
      whitelistedUrlsAndroid: [
        "sbmsmartbankinguat.esbeeyem.com:9443",
        "smtplatform.sbmbank.co.in",
        "razorpay.com",
        "uat-m2p-ccms.m2pfintech.com"
      ],
      whitelistedUrlsIos: [
        "sbmsmartbankinguat.esbeeyem.com:9443",
        "smtplatform.sbmbank.co.in",
        "sbmkycuat.esbeeyem.com",
        "razorpay.com",
        "uat-m2p-ccms.m2pfintech.com"
      ],
      hostName: "https://sbmsmartbankinguat.esbeeyem.com:9443",
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => webView,
    ));
  }

  Future<void> _loginAndNavigate() async {
    String token = await createToken();

    open(context, "/banking/sbm/credit_card/CRE", token,
        (WebViewCallback action) {
      switch (action.type) {
        case WebViewCallbackType.redirect:
          print("Redirected with status: ${action.status}");
          break;
        case WebViewCallbackType.logout:
          print("User logged out");
          break;
      }
    });
    _openWebView();
  }
}
