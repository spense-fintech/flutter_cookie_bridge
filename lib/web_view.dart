import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/web_view_callback.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'session_manager.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  print('Download callback: id=$id, status=$status, progress=$progress');
}

class WebView extends StatefulWidget {
  final String url;
  final String cookie;
  final Map<String, dynamic>? options;
  late final Function(WebViewCallback)? onCallback;
  final List<String>? whitelistedUrls;
  final String? hostName;

// // GlobalKey to access the state of the WebViewManager
// static final GlobalKey<CustomWebViewState> globalKey =
//     GlobalKey<CustomWebViewState>();

  WebView({
    Key? key,
    required this.url,
    required this.cookie,
    this.options,
    this.onCallback,
    this.whitelistedUrls,
    this.hostName,
  }) : super(key: key);

  Future<void> loadUrl(String url) async {
    final state = (key as GlobalKey<CustomWebViewState>?)?.currentState;
    if (state != null) {
      await state.loadUrl(url);
    }
  }

  Future<void> logout(BuildContext context) async {
    final state = (key as GlobalKey<CustomWebViewState>?)?.currentState;
    if (state != null) {
      await state.logout(context);
    }
  }

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<WebView> {
  InAppWebViewController? _webViewController;
  String? _currentUrl;
  Map<String, String>? _headers;
  bool _isDownloaderInitialized = false;

  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _initializeDownloader();
// _flutterDownloader = FlutterDownloader();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  Future<void> _initializeDownloader() async {
    try {
      await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
      _isDownloaderInitialized = true;
    } catch (e) {
      print('Downloader initialization failed: $e');
      _isDownloaderInitialized = false;
    }
  }

  Future<void> _syncCookiesToWebView() async {
    Uri? uri = Uri.tryParse(_currentUrl!);
    String? domain = uri?.host;

    String decodedCookie = Uri.decodeComponent(widget.cookie);

    List<String> cookieParts = decodedCookie.split('=');
    if (cookieParts.length == 2) {
      String cookieName = cookieParts[0];
      String cookieValue = cookieParts[1];

      await CookieManager.instance().setCookie(
        url: WebUri(_currentUrl!),
        name: cookieName,
        value: cookieValue,
        domain: domain,
        path: '/',
      );
     }
  }

  InAppWebViewSettings _buildWebViewSettings() {
    return InAppWebViewSettings(
      cacheEnabled: widget.options?['cacheEnabled'] ?? true,
      javaScriptEnabled: widget.options?['javaScriptEnabled'] ?? true,
      domStorageEnabled: true,
      allowFileAccess: true,
      geolocationEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      userAgent:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 _Partner_Flutter",
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );
  }

  Future<void> loadUrl(String url) async {
    if (_webViewController != null) {
      await _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(url)),
      );
      setState(() {
        _currentUrl = url;
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13 and above
        return await Permission.photos.request().isGranted;
      } else {
        // Below Android 13
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }

  String _getFileExtension(String url) {
  try {
    final uri = Uri.parse(url);
    final path = uri.path;
    
    // Check if path contains a dot
    if (path.contains('.')) {
      final ext = path.substring(path.lastIndexOf('.'));
      return ext.isNotEmpty ? ext : '.pdf';
    }
    
    // If no extension found, check content disposition or default to .pdf
    return '.pdf';
  } catch (e) {
    print('Error getting file extension: $e');
    return '.pdf';
  }
}

  Future<void> _onDownloadStartRequest(
    InAppWebViewController controller, DownloadStartRequest request) async {
  try {
    print('Download started: ${request.url}');

    // Request storage permissions
    if (!await _requestStoragePermission()) {
      print('Storage permission denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission required for downloads')),
        );
      }
      return;
    }

    // Get cookies for authentication
    final cookies = await CookieManager.instance().getCookies(url: request.url);
    final cookieString = cookies.map((c) => '${c.name}=${c.value}').join('; ');

    // Prepare headers
    final headers = {
      'Cookie': cookieString,
      'User-Agent': _buildWebViewSettings().userAgent!,
    };

    // Create unique filename using timestamp and suggested filename or default
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final suggestedName = request.suggestedFilename ?? 'document';
    final fileExt = _getFileExtension(request.url.toString());
    final fileName = '${timestamp}_$suggestedName$fileExt';

    // Get downloads directory
    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    final filePath = '${downloadsDir.path}/$fileName';

    print('Downloading file to: $filePath');

    // Download file using http
    final response = await http.get(
      Uri.parse(request.url.toString()),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('File saved successfully at: $filePath');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded successfully')),
        );
      }

      // Open the file
      try {
        final result = await OpenFile.open(filePath);
        print('Open file result: ${result.type} - ${result.message}');

        if (result.type != ResultType.done) {
          throw Exception(result.message);
        }
      } catch (e) {
        print('Error opening file: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening file: $e')),
          );
        }
      }
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  } catch (e) {
    print('Download/Open error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download/open file: $e')),
      );
    }
  }
}

  // String _getFileExtension(String url) {
  //   final uri = Uri.parse(url);
  //   final path = uri.path;
  //   final ext = path.substring(path.lastIndexOf('.'));
  //   return ext.isNotEmpty ? ext : '.pdf';
  // }

  Future<void> logout(BuildContext context) async {
    await _sessionManager.clearSession();
    await CookieManager.instance().deleteAllCookies();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    Uri uri = navigationAction.request.url!;
    String url = uri.toString();

    // Get whitelisted URLs and hostname from widget, with fallback to empty values
    final whitelistedUrls = widget.whitelistedUrls ?? [];
    final hostName = widget.hostName ?? '';

    if (url.contains("session-expired")) {
      widget.onCallback?.call(WebViewCallback.logout());
      await logout(context);
      return NavigationActionPolicy.CANCEL;
    }

    if (url.contains('/redirect?status=')) {
      String? status = uri.queryParameters['status'];
      if (status != null) {
        widget.onCallback?.call(WebViewCallback.redirect(status));
        // if (await _webViewController!.canGoBack()) {
        //   await _webViewController!.goBack();
        // } else {
        //   Navigator.of(context).pop();
        // }
        Navigator.of(context).pop();
        return NavigationActionPolicy.ALLOW;
      }
    }
    if (url.contains(".pdf") ||
        url.contains("/statements/") ||
        url.contains("/download_statements") ||
        url.contains(".jpeg") ||
        url.contains(".png")) {
      await _onDownloadStartRequest(
        controller,
        DownloadStartRequest(
          url: uri as WebUri,
          mimeType: 'application/pdf',
          contentDisposition: 'attachment',
          userAgent: _buildWebViewSettings().userAgent,
          suggestedFilename: uri.pathSegments.last,
          contentLength: -1,
        ),
      );
      return NavigationActionPolicy.CANCEL;
    }

    for (String whitelistedUrl in whitelistedUrls) {
      if (url.contains(whitelistedUrl) ||
          (hostName.isNotEmpty && url.contains(hostName))) {
        return NavigationActionPolicy.ALLOW;
      }
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }

    return NavigationActionPolicy.CANCEL;
  }

  Future<bool> _onWillPop() async {
    if (_webViewController != null && await _webViewController!.canGoBack()) {
      await _webViewController!.goBack();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(_currentUrl!),
              headers: _headers,
            ),
            initialSettings: _buildWebViewSettings(),
            onWebViewCreated: (controller) async {
              _webViewController = controller;
              await _syncCookiesToWebView();
            },
            onLoadStart: (controller, url) async {
              await _syncCookiesToWebView();
            },
            onLoadStop: (controller, url) async {
              _currentUrl = url?.toString();
              setState(() {});

              // if (_currentUrl!.contains('/logout')) {
              //   await logout(context);
              // } else if (_currentUrl!.contains('/redirect')) {
              //   Uri uri = Uri.parse(_currentUrl!);
              //
              //   String? status = uri.queryParameters['status'];
              //
              //   if (status != null) {
              //     widget.onCallback?.call(WebViewCallback.redirect(status));
              //     if (await _webViewController!.canGoBack()) {
              //       await _webViewController!.goBack();
              //     } else {
              //       Navigator.of(context).pop();
              //     }
              //   }
              // }
            },
            onDownloadStartRequest: _onDownloadStartRequest,
            shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
          ),
        ));
  }
}
