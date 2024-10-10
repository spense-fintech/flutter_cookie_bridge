import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/web_view.dart';
import 'package:flutter_cookie_bridge_example/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cookie_bridge/network_manager.dart';

class CustomWebViewScreen extends StatefulWidget {
  final String url;

  const CustomWebViewScreen({
    super.key,
    required this.url,
  });

  @override
  CustomWebViewScreenState createState() => CustomWebViewScreenState();
}

class CustomWebViewScreenState extends State<CustomWebViewScreen>
    with WidgetsBindingObserver {
  String counterResult = '';
  String addCounterResult = '';
  String? _currentUrl;
  late WebView _webViewManager;

  final NetworkManager _networkManager = NetworkManager();
  final String? baseUrl = dotenv.env['BASE_URL'];

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;

    _initializeWebView();
    _loadSavedCounters();
  }

  Future<void> _initializeWebView() async {
    _webViewManager = await cookieBridge.getWebView(url: _currentUrl!);
  }

  Future<void> _loadSavedCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counterResult = prefs.getString('counterResult') ?? '';
      addCounterResult = prefs.getString('addCounterResult') ?? '';
    });
  }

  Future<void> handleLogout() async {
    print("logging out");
    await _webViewManager.logout(context);
  }

  Future<void> fetchCounter() async {
    try {
      var response = await getCounter();
      if (response != null && response.statusCode == 200) {
        setState(() {
          counterResult = response.data['count'].toString();
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('counterResult', counterResult);

        print('Counter fetched: $counterResult');
      } else {
        print("Counter can't be fetched");
      }
    } catch (e) {
      print('Failed to fetch counter: $e');
    }
  }

  Future<Response?> getCounter() async {
    try {
      Response? response =
          await _networkManager.get('$baseUrl/api/test/counter');
      print("Counter response: ${response?.data}");
      return response;
    } catch (e) {
      print('Error during getCounter request: $e');
      return null;
    }
  }

  Future<Response?> incrementCounter() async {
    try {
      Response? response =
          await _networkManager.get('$baseUrl/api/test/counter-add');

      print("Increment counter response: ${response?.data}");
      return response;
    } catch (e) {
      print('Error during incrementCounter request: $e');
      return null;
    }
  }

  Future<void> addCounter() async {
    try {
      var response = await incrementCounter();
      if (response != null && response.statusCode == 200) {
        setState(() {
          addCounterResult = response.data['count'].toString();
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('addCounterResult', addCounterResult);

        print('Counter incremented: $addCounterResult');
      } else {
        print('Failed to increment counter');
      }
    } catch (e) {
      print('Failed to increment counter: $e');
    }
  }

  Future<void> navigateToCounter() async {
    print("navigating..");
    // _webViewManager = WebViewManager(
    //   url: '$baseUrl/design/counter',
    //   cookie: widget.cookie,
    // );

    _webViewManager.loadUrl('$baseUrl/design/counter');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom WebView')),
      body: Column(
        children: [
          Expanded(flex: 6, child: _webViewManager),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: fetchCounter,
                      child: Text('Fetch Counter'),
                    ),
                    ElevatedButton(
                      onPressed: addCounter,
                      child: Text('Add to Counter'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await handleLogout();
                        },
                        child: Text('Logout'),
                      ),
                      ElevatedButton(
                        onPressed: navigateToCounter,
                        child: Text('Counter test'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Counter: $counterResult\nAdded: $addCounterResult'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
