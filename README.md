# flutter_cookie_bridge

[![Pub Version](https://img.shields.io/pub/v/flutter_cookie_bridge)](https://pub.dev/packages/flutter_cookie_bridge)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/spense-fintech/flutter_cookie_bridge/blob/main/LICENSE)

A Flutter plugin that synchronizes cookies between network requests (using [Dio](https://pub.dev/packages/dio)) and WebViews (using [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)), enabling seamless session management across your Flutter application.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Getting Started](#getting-started)
    - [1. Import the Package](#1-import-the-package)
    - [2. Initialize FlutterCookieBridge](#2-initialize-fluttercookiebridge)
    - [3. Using NetworkManager](#3-using-networkmanager)
    - [4. Creating a WebView with Cookie Synchronization](#4-creating-a-webview-with-cookie-synchronization)
    - [5. Session Management](#5-session-management)
- [Example](#example)
- [API Reference](#api-reference)
- [Steps of Integration](#steps-of-integration)
- [Additional Configuration](#additional-configuration)
    - [Handling Environment Variables](#handling-environment-variables)
    - [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Cookie Synchronization**: Automatically sync cookies between your network requests and WebView instances.
- **Network Request Wrapper**: Simplified network requests using Dio with built-in cookie management.
- **Customizable WebView**: A wrapper around InAppWebView, allowing you to easily integrate WebViews with synchronized cookies.
- **Session Management**: Easily manage user sessions, ensuring consistency between your app and embedded web content.

## Installation

Add `flutter_cookie_bridge` to your `pubspec.yaml`:

    dependencies:
      flutter_cookie_bridge: ^0.0.1

Then, run:

    flutter pub get

## Getting Started

### 1. Import the Package

In your Dart files, import `flutter_cookie_bridge`:

    import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';

### 2. Initialize FlutterCookieBridge

Create an instance of `FlutterCookieBridge`:

    final cookieBridge = FlutterCookieBridge();

### 3. Using NetworkManager

Use the `NetworkManager` class provided by the plugin to make network requests with automatic cookie handling:

    final NetworkManager _networkManager = NetworkManager();

**Example GET request:**

    Response? response = await _networkManager.get('https://api.example.com/data');

**Example POST request:**

    Response? response = await _networkManager.request(
      url: 'https://api.example.com/data',
      method: 'POST',
      body: {'key': 'value'},
    );

### 4. Creating a WebView with Cookie Synchronization

Use the `getWebView` method to get a `WebView` widget with synchronized cookies:

    WebView _webViewManager;

    Future<void> _initializeWebView() async {
      _webViewManager = await cookieBridge.getWebView(url: 'https://your-url.com');
    }

### 5. Session Management

Manage user sessions by checking for existing sessions and performing login operations as needed. Use `NetworkManager` for API calls and ensure that the cookies are synchronized between the app and WebView.

**Example:**

    Future<void> _checkSession() async {
      Response? response = await _networkManager.get('$baseUrl/api/user/session');
      if (response?.data.containsKey("user")) {
        // User is logged in
      } else {
        // User is not logged in
      }
    }

## Example

Below is a comprehensive example demonstrating how to integrate `flutter_cookie_bridge` into your Flutter application.

### main.dart

    import 'package:flutter/material.dart';
    import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
    import 'package:flutter_cookie_bridge/network_manager.dart';
    import 'custom_webview_screen.dart';

    final cookieBridge = FlutterCookieBridge();

    void main() {
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
      final NetworkManager _networkManager = NetworkManager();
      final String baseUrl = 'https://your-api.com';

      @override
      void initState() {
        super.initState();
        _checkSession();
      }

      Future<void> _checkSession() async {
        Response? response = await _networkManager.get('$baseUrl/api/user/session');
        if (response?.data.containsKey("user")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomWebViewScreen(url: '$baseUrl/home'),
            ),
          );
        } else {
          // Stay on login screen
        }
      }

      Future<void> _loginAndNavigate() async {
        var loginRequestBody = {
          "username": "your_username",
          "password": "your_password",
        };

        var loginResponse = await _networkManager.request(
          url: '$baseUrl/api/user/login',
          method: 'POST',
          body: loginRequestBody,
        );

        if (loginResponse != null && loginResponse.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomWebViewScreen(url: '$baseUrl/home'),
            ),
          );
        } else {
          // Handle login error
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Center(
            child: ElevatedButton(
              onPressed: _loginAndNavigate,
              child: const Text('Login'),
            ),
          ),
        );
      }
    }

### custom_webview_screen.dart

    import 'package:flutter/material.dart';
    import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';
    import 'package:flutter_cookie_bridge/network_manager.dart';

    class CustomWebViewScreen extends StatefulWidget {
      final String url;

      const CustomWebViewScreen({Key? key, required this.url}) : super(key: key);

      @override
      _CustomWebViewScreenState createState() => _CustomWebViewScreenState();
    }

    class _CustomWebViewScreenState extends State<CustomWebViewScreen> {
      late WebView _webViewManager;
      final NetworkManager _networkManager = NetworkManager();

      @override
      void initState() {
        super.initState();
        _initializeWebView();
      }

      Future<void> _initializeWebView() async {
        _webViewManager = await FlutterCookieBridge().getWebView(url: widget.url);
        setState(() {});
      }

      Future<void> _logout() async {
        await _webViewManager.logout(context);
        Navigator.pop(context);
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('WebView with Cookie Sync'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: _webViewManager != null
              ? _webViewManager
              : const Center(child: CircularProgressIndicator()),
        );
      }
    }

In this example:

- **Login Flow**: The app attempts to log in the user. Upon successful login, it navigates to a `CustomWebViewScreen` displaying a WebView with cookies synchronized.
- **WebView Usage**: The `CustomWebViewScreen` initializes a WebView using `FlutterCookieBridge().getWebView()`.
- **Logout Functionality**: The WebView can be logged out using `_webViewManager.logout(context);`.

## API Reference

### FlutterCookieBridge

#### `getWebView({required String url})`

Returns a `WebView` widget with cookie synchronization enabled.

**Parameters:**

- `url` (String): The URL to load in the WebView.

**Example:**

    WebView _webViewManager = await FlutterCookieBridge().getWebView(url: 'https://your-url.com');

### NetworkManager

A wrapper around Dio for making HTTP requests with automatic cookie handling.

#### `request({required String url, required String method, Map<String, dynamic>? body, Map<String, dynamic>? headers})`

Performs an HTTP request.

**Parameters:**

- `url` (String): The request URL.
- `method` (String): The HTTP method (e.g., 'GET', 'POST').
- `body` (Map<String, dynamic>?): The request body.
- `headers` (Map<String, dynamic>?): The request headers.

**Example:**

    Response? response = await _networkManager.request(
      url: 'https://api.example.com/data',
      method: 'POST',
      body: {'key': 'value'},
    );

#### `get(String url, {Map<String, dynamic>? headers})`

Performs a GET request.

**Parameters:**

- `url` (String): The request URL.
- `headers` (Map<String, dynamic>?): The request headers.

**Example:**

    Response? response = await _networkManager.get('https://api.example.com/data');

### WebView

A wrapper around InAppWebView with cookie synchronization.

#### `loadUrl(String url)`

Loads the specified URL in the WebView.

**Parameters:**

- `url` (String): The URL to load.

**Example:**

    _webViewManager.loadUrl('https://your-url.com');

#### `logout(BuildContext context)`

Logs out the user by clearing cookies and session data.

**Parameters:**

- `context` (BuildContext): The build context.

**Example:**

    await _webViewManager.logout(context);

## Steps of Integration

To integrate `flutter_cookie_bridge` into your project, follow these steps:

1. **Add the Dependency**

   Add `flutter_cookie_bridge` to your `pubspec.yaml` file:

       dependencies:
         flutter_cookie_bridge: ^0.0.1

   Run `flutter pub get` to install the package.

2. **Import the Package**

   Import `flutter_cookie_bridge` in your Dart files where needed:

       import 'package:flutter_cookie_bridge/flutter_cookie_bridge.dart';

3. **Initialize FlutterCookieBridge**

   Create an instance of `FlutterCookieBridge`:

       final cookieBridge = FlutterCookieBridge();

4. **Use NetworkManager for API Requests**

   Use the `NetworkManager` class to perform network requests with automatic cookie synchronization:

       final NetworkManager _networkManager = NetworkManager();

   **Example GET request:**

       Response? response = await _networkManager.get('https://api.example.com/data');

   **Example POST request:**

       Response? response = await _networkManager.request(
         url: 'https://api.example.com/data',
         method: 'POST',
         body: {'key': 'value'},
       );

5. **Create WebView with Cookie Synchronization**

   Use `cookieBridge.getWebView` to create a WebView widget with cookies synchronized with your network requests:

       WebView _webViewManager;

       Future<void> _initializeWebView() async {
         _webViewManager = await cookieBridge.getWebView(url: 'https://your-url.com');
       }

6. **Manage User Sessions**

   Check for existing sessions and perform login operations as needed, using the `NetworkManager` and maintaining session consistency between your app and the WebView.

       // Check session
       Response? response = await _networkManager.get('$baseUrl/api/user/session');
       if (response?.data.containsKey("user")) {
         // User is logged in
       } else {
         // User is not logged in
       }

7. **Handle Logout**

   Use the `logout` method to clear cookies and session data:

       await _webViewManager.logout(context);

8. **Update WebView Content**

   Navigate to different URLs within the WebView:

       _webViewManager.loadUrl('https://your-url.com/new-page');

## Additional Configuration

### Handling Environment Variables

If your application uses environment variables (e.g., for base URLs or API keys), consider using the [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) package.

**Setup:**

1. Add `flutter_dotenv` to your `pubspec.yaml`:

       dependencies:
         flutter_dotenv: ^5.0.2

2. Create a `.env` file in your project's root directory and add your environment variables:

       BASE_URL=https://your-api.com
       API_KEY=your_api_key

3. Load the environment variables in your `main` function:

       void main() async {
         await dotenv.load(fileName: ".env");
         runApp(MyApp());
       }

4. Access the variables using `dotenv.env`:

       final String? baseUrl = dotenv.env['BASE_URL'];

### Dependencies

Ensure the following dependencies are added to your `pubspec.yaml`:

    dependencies:
      dio: ^5.2.1
      flutter_inappwebview: ^5.7.2+4
      shared_preferences: ^2.1.1

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

By following this guide, you can seamlessly integrate `flutter_cookie_bridge` into your Flutter application, ensuring consistent session management and cookie synchronization between your network requests and WebView instances.
