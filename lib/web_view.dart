import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookie_bridge/custom_toast.dart';
import 'package:flutter_cookie_bridge/web_view_callback.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'session_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;

class WebView extends StatefulWidget {
  final String url;
  final String cookie;
  final Map<String, dynamic>? options;
  late final Function(WebViewCallback)? onCallback;
  final List<String>? whitelistedUrls;
  final String? hostName;
  final List<String>? iOSBrowserRedirectDomains;

// // GlobalKey to access the state of the WebViewManager
// static final GlobalKey<CustomWebViewState> globalKey =
//     GlobalKey<CustomWebViewState>();

  WebView(
      {Key? key,
      required this.url,
      required this.cookie,
      this.options,
      this.onCallback,
      this.whitelistedUrls,
      this.hostName,
      this.iOSBrowserRedirectDomains})
      : super(key: key);

  Future<void> loadUrl(String url) async {
    final state = (key as GlobalKey<CustomWebViewState>?)?.currentState;
    if (state != null) {
      await state.loadUrl(url);
    }
  }

  // Future<void> logout(BuildContext context) async {
  //   final state = (key as GlobalKey<CustomWebViewState>?)?.currentState;
  //   if (state != null) {
  //     await state.logout(context);
  //   }
  // }

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<WebView> {
  InAppWebViewController? _webViewController;
  String? _currentUrl;
  Map<String, String>? _headers;
  bool _hasRedirected = false;

  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  Future<bool> _handleIOSPermission(Permission permission) async {
    if (Platform.isIOS) {
      final status = await permission.status;
      if (status.isDenied || status.isRestricted) {
        // Show alert before requesting permission
        final shouldRequest = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permission Required'),
            content: Text(
                'This app needs ${permission.toString()} access to enable video and audio features'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text('Allow'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );

        if (shouldRequest == true) {
          final result = await permission.request();
          return result.isGranted;
        }
        return false;
      }
      return status.isGranted;
    }
    return true;
  }

  Future<bool> _handlePermissionRequest(Permission permission) async {
    if (Platform.isIOS) {
      return await _handleIOSPermission(permission);
    }
    return await permission.request().isGranted;
  }

  Future<void> _syncCookiesToWebView() async {
    Uri? uri = Uri.tryParse(_currentUrl!);
    String? domain = uri?.host;

    debugPrint('Syncing cookies to WebView for domain: $domain');
    debugPrint('Original cookie: ${widget.cookie}');

    try {
      // IMPORTANT: Clear existing cookies for this domain first
      await CookieManager.instance().deleteCookies(url: WebUri(_currentUrl!));
      debugPrint('Cleared existing cookies');

      String decodedCookie = Uri.decodeComponent(widget.cookie);
      debugPrint('Decoded cookie: $decodedCookie');

      if (!decodedCookie.contains(';')) {
        // Handle single cookie case
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
      } else {
        // Handle multiple cookies
        List<String> cookiesList = decodedCookie.split(';');

        for (String cookieString in cookiesList) {
          cookieString = cookieString.trim();
          if (cookieString.isEmpty) continue;

          int firstEqualIndex = cookieString.indexOf('=');
          if (firstEqualIndex > 0) {
            String cookieName =
                cookieString.substring(0, firstEqualIndex).trim();
            String cookieValue =
                cookieString.substring(firstEqualIndex + 1).trim();

            debugPrint('Setting cookie part: $cookieName=$cookieValue');

            await CookieManager.instance().setCookie(
              url: WebUri(_currentUrl!),
              name: cookieName,
              value: cookieValue,
              domain: domain,
              path: '/',
            );
          }
        }
      }

      // Verify cookies were set correctly
      final cookies =
          await CookieManager.instance().getCookies(url: WebUri(_currentUrl!));
      debugPrint(
          'Cookies after sync: ${cookies.map((c) => '${c.name}=${c.value}').join('; ')}');
    } catch (e) {
      debugPrint('Error syncing cookies: $e');
    }
  }

  // Future<void> _syncCookiesToWebView() async {
  //   // sbmsmartbankinguat.esbeeyem.com:9443
  //
  //   // smtplatform.sbmbank.co.in
  //   Uri? uri = Uri.tryParse(_currentUrl!);
  //   String? domain = uri?.host;
  //
  //   String decodedCookie = Uri.decodeComponent(widget.cookie);
  //
  //   List<String> cookieParts = decodedCookie.split('=');
  //   if (cookieParts.length == 2) {
  //     String cookieName = cookieParts[0];
  //     String cookieValue = cookieParts[1];
  //     await CookieManager.instance().setCookie(
  //       url: WebUri(_currentUrl!),
  //       name: cookieName,
  //       value: cookieValue,
  //       domain: domain,
  //       path: '/',
  //     );
  //   }
  // }

  Future<void> logout(BuildContext context) async {
    try {
      await _sessionManager.clearSession();
      await CookieManager.instance().deleteAllCookies();

      debugPrint("logging out from webview");

      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   if (!mounted) {
      //     await Future.delayed(Duration(milliseconds: 100));
      //   }
      //
      //   if (mounted) {
      //     await Navigator.of(context)
      //         .pushNamedAndRemoveUntil('/', (route) => false);
      //   } else {
      //     widget.onCallback?.call(WebViewCallback.logout());
      //   }
      // });
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  InAppWebViewSettings _buildWebViewSettings() {
    final String userAgent = Platform.isIOS
        ? "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"
        : "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36";
    return InAppWebViewSettings(
      cacheEnabled: widget.options?['cacheEnabled'] ?? true,
      javaScriptEnabled: widget.options?['javaScriptEnabled'] ?? true,
      domStorageEnabled: true,
      allowFileAccess: true,
      geolocationEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      supportMultipleWindows: true,
      javaScriptCanOpenWindowsAutomatically: true,
      userAgent: userAgent,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      supportZoom: true,
      useOnLoadResource: true,
      useShouldInterceptAjaxRequest: true,
      useShouldInterceptFetchRequest: true,
      allowsInlineMediaPlayback: true,
      useWideViewPort: true,
      databaseEnabled: true,
      applicationNameForUserAgent: "Version/8.0.2 Safari/600.2.5",
      //thirdPartyCookiesEnabled: true,
      iframeAllow: "camera *; microphone *",
      iframeAllowFullscreen: true,
      allowsAirPlayForMediaPlayback: true,
      disableInputAccessoryView: true,
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
      debugPrint('Error getting file extension: $e');
      return '.pdf';
    }
  }

  Future<bool> _getPermissions() async {
    debugPrint('Starting permission checks...');

    try {
      // Request permissions explicitly
      PermissionStatus cameraStatus = await Permission.camera.request();
      PermissionStatus micStatus = await Permission.microphone.request();

      debugPrint('Permission status - Camera: $cameraStatus, Mic: $micStatus');

      bool isGranted = cameraStatus.isGranted && micStatus.isGranted;

      // If permissions denied, show settings dialog
      if (!isGranted && mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissions Required'),
            content: Text(
                'Camera and microphone access are needed for video features. Please enable them in settings.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Settings'),
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
              ),
            ],
          ),
        );
      }

      return isGranted;
    } catch (e) {
      debugPrint('Error getting permissions: $e');
      return false;
    }
  }

  Future<void> _requestIOSStoragePermission(BuildContext context) async {
    if (await Permission.storage.status.isDenied) {
      final shouldRequest = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'This app needs storage access to save downloaded files.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (shouldRequest != true) {
        return;
      }

      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Storage permission required for downloads')),
          );
        }
        return;
      }
    }
  }

  Future<void> _onDownloadStartRequest(
      InAppWebViewController controller, DownloadStartRequest request) async {
    try {
      debugPrint('Download started: ${request.url}');

      // Request storage permissions

      if (Platform.isIOS) {
        _requestIOSStoragePermission(context);
      } else {
        //  Android permission
        if (!await _requestStoragePermission()) {
          debugPrint('Storage permission denied');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Storage permission required for downloads')),
            );
          }
          return;
        }
      }

      // Get cookies for authentication
      final cookies =
          await CookieManager.instance().getCookies(url: request.url);
      final cookieString =
          cookies.map((c) => '${c.name}=${c.value}').join('; ');
      final headers = {
        'Cookie': cookieString,
      };

      // Create unique filename using timestamp and suggested filename or default
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final suggestedName = request.suggestedFilename ?? 'document';
      final fileExt = _getFileExtension(request.url.toString());
      final fileName = '${timestamp}_$suggestedName$fileExt';

      // Get downloads directory
      final downloadsDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();

      if (!await downloadsDir!.exists()) {
        await downloadsDir.create(recursive: true);
      }
      final filePath = '${downloadsDir.path}/$fileName';

      debugPrint('Downloading file to: $filePath');

      // Download file using http
      final response = await http.get(
        Uri.parse(request.url.toString()),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        debugPrint('File saved successfully at: $filePath');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File downloaded successfully')),
          );
        }

        // Open the file
        try {
          final result = await OpenFilex.open(filePath);
          debugPrint('Open file result: ${result.type} - ${result.message}');

          if (result.type != ResultType.done) {
            throw Exception(result.message);
          }
        } catch (e) {
          debugPrint('Error opening file: $e');
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
      debugPrint('Download/Open error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download/open file: $e')),
        );
      }
    }
  }

  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    Uri uri = navigationAction.request.url!;
    String url = uri.toString();

    // Get whitelisted URLs and hostname from widget, with fallback to empty values
    final whitelistedUrls = widget.whitelistedUrls ?? [];
    final iOSBrowserRedirectDomain = widget.iOSBrowserRedirectDomains ?? [];
    final hostName = widget.hostName ?? '';
    debugPrint("Navigating to URL: $url");

    if (!_hasRedirected &&
        (url.contains('/redirect?status=') ||
            url.contains('/session-expired?status='))) {
      _hasRedirected = true;
      String? status = uri.queryParameters['status'];
      if (status != null) {
        await logout(context);
        widget.onCallback?.call(WebViewCallback.redirect(status));
        Navigator.of(context).pop();
        return NavigationActionPolicy.CANCEL;
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

    bool isAllowed = whitelistedUrls.any((white) => url.contains(white)) ||
        (hostName.isNotEmpty && url.contains(hostName));

    // Check if URL is ios redirection url
    bool isIOSRedirectedUrl =
        iOSBrowserRedirectDomain.any((black) => url.contains(black));

    if (isAllowed) {
      if (Platform.isIOS) {
        if (isIOSRedirectedUrl) {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          }
          return NavigationActionPolicy.CANCEL;
        }
      }
      // URL is only whitelisted - allow in WebView
      return NavigationActionPolicy.ALLOW;
    }

    if (url.contains("about:blank")) {
      return NavigationActionPolicy.CANCEL;
    }

    // URL is not whitelisted - open externally
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await Future.delayed(
            Duration(milliseconds: 200)); // Small delay to avoid conflicts
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $url");
        showCustomToast(context, "No application found to open this link");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
      showCustomToast(context, "Error opening link");
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_currentUrl!),
                headers: _headers,
              ),
              initialSettings: _buildWebViewSettings(),
              onCreateWindow: (controller, createWindowRequest) async {
                final url = createWindowRequest.request.url;
                try {
                  if (url != null && !url.toString().startsWith("https://")) {
                    if (await canLaunchUrl(url)) {
                      await Future.delayed(const Duration(
                          milliseconds: 200)); // Small delay to avoid conflicts
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint("Could not launch $url");
                      showCustomToast(
                          context, "No application found to open this link");
                    }
                  }

                } catch (e) {
                  debugPrint("Error launching URL: $e");
                  showCustomToast(context, "Error opening link");
                }
                // Return false to indicate that the new window should not be created in-app
                return false;
              },
              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                bool locationGranted = Platform.isIOS
                    ? await _handleIOSPermission(Permission.location)
                    : await _handlePermissionRequest(Permission.location);

                return GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: locationGranted, retain: true);
              },
              onPermissionRequest: (controller, resources) async {
                if (Platform.isIOS) {
                  bool granted = await _getPermissions();

                  if (granted) {
                    await controller.evaluateJavascript(source: """
                    navigator.mediaDevices.getUserMedia({
                      audio: true,
                      video: true
                    }).catch(function(err) {
                      console.log('Media permissions error:', err);
                    });
                  """);
                  }

                  return PermissionResponse(
                      resources: resources.resources,
                      action: granted
                          ? PermissionResponseAction.GRANT
                          : PermissionResponseAction.DENY);
                }

                bool granted = true;

                for (var resource in resources.resources) {
                  if (resource ==
                      PermissionResourceType.CAMERA_AND_MICROPHONE) {
                    granted &=
                        await _handlePermissionRequest(Permission.camera);
                    granted &=
                        await _handlePermissionRequest(Permission.microphone);
                  } else if (resource == PermissionResourceType.MICROPHONE) {
                    granted &=
                        await _handlePermissionRequest(Permission.microphone);
                  } else if (resource == PermissionResourceType.CAMERA) {
                    granted &=
                        await _handlePermissionRequest(Permission.camera);
                  } else if (resource ==
                      PermissionResourceType.FILE_READ_WRITE) {
                    granted &=
                        await _handlePermissionRequest(Permission.storage);
                  } else if (resource == PermissionResourceType.NOTIFICATIONS) {
                    granted &=
                        await _handlePermissionRequest(Permission.notification);
                  }
                }
                return PermissionResponse(
                    resources: resources.resources,
                    action: granted
                        ? PermissionResponseAction.GRANT
                        : PermissionResponseAction.DENY);
              },
              onWebViewCreated: (controller) async {
                _webViewController = controller;
                await _syncCookiesToWebView();
              },
              onLoadStart: (controller, url) async {
                // await _syncCookiesToWebView();
              },
              onLoadStop: (controller, url) async {
                await controller.evaluateJavascript(source: """
                (function() {
                  let originalOpen = window.open;
                  window.open = function(url, target) {
                    if (target === "_blank" && url) {
                      window.location.href = url; 
                    } else {
                      return originalOpen.apply(this, arguments);
                    }
                  };
                })();
              """);
              },
              onDownloadStartRequest: _onDownloadStartRequest,
              shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
            ),
          )),
    );
  }

  void showCustomToast(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 4)}) {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        width: MediaQuery.of(context).size.width,
        child: CustomToast(message: message),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
