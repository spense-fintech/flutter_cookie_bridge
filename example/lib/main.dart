import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/web_view_callback.dart';
import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final cookieBridge = FlutterCookieBridge();

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  final TextEditingController _urlController = TextEditingController(
    text: "",
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView Opener')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openWebView(_urlController.text),
              child: const Text('Open WebView'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWebView(String url) async {
    final cookiesBefore = await cookieBridge.checkSession();
    print('Cookies before WebView: $cookiesBefore');

    final webView = await cookieBridge.getWebView(
      url: url,
      callback: (WebViewCallback action) {
        switch (action.type) {
          case WebViewCallbackType.redirect:
            print("Redirected with status: ${action.status}");
            break;
          case WebViewCallbackType.logout:
            print("User logged out");
            break;
        }
      },

      hostName: "${_urlController.text}",
    );

    if (!mounted) return;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => webView,
    ));
  }
}