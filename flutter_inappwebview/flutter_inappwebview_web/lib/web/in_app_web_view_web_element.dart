import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';
import 'dart:js_interop';
import 'dart:developer';
import 'package:web/web.dart';

import 'headless_inappwebview_manager.dart';
import 'web_platform_manager.dart';
import 'js_bridge.dart';

extension on HTMLIFrameElement {
  // https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/csp
  external set csp(String? value);
  external String? get csp;
}

class InAppWebViewWebElement implements Disposable {
  late dynamic _viewId;
  late BinaryMessenger _messenger;
  late HTMLDivElement iframeContainer;
  late HTMLIFrameElement iframe;
  late MethodChannel? _channel;
  InAppWebViewSettings? initialSettings;
  URLRequest? initialUrlRequest;
  InAppWebViewInitialData? initialData;
  String? initialFile;
  String? headlessWebViewId;

  InAppWebViewSettings? settings;
  JSWebView? jsWebView;
  bool isLoading = false;

  InAppWebViewWebElement(
      {required dynamic viewId, required BinaryMessenger messenger}) {
    this._viewId = viewId;
    this._messenger = messenger;
    iframeContainer = HTMLDivElement()
      ..id = 'flutter_inappwebview-$_viewId-container'
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.border = 'none';
    iframe = HTMLIFrameElement()
      ..id = 'flutter_inappwebview-$_viewId'
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.border = 'none';
    iframeContainer.append(iframe);

    _channel = MethodChannel(
      'com.pichillilorenzo/flutter_inappwebview_$_viewId',
      const StandardMethodCodec(),
      _messenger,
    );

    this._channel?.setMethodCallHandler((call) async {
      try {
        return await handleMethodCall(call);
      } on Error catch (e) {
        log(e.toString(),
            name: runtimeType.toString(), error: e, stackTrace: e.stackTrace);
      }
    });

    jsWebView = flutterInAppWebView?.createFlutterInAppWebView(
        _viewId, iframe, iframeContainer);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "getIFrameId":
        return getIFrameId();
      case "loadUrl":
        URLRequest urlRequest = URLRequest.fromMap(
            call.arguments["urlRequest"].cast<String, dynamic>())!;
        await loadUrl(urlRequest: urlRequest);
        break;
      case "loadData":
        String data = call.arguments["data"];
        String mimeType = call.arguments["mimeType"];
        await loadData(data: data, mimeType: mimeType);
        break;
      case "loadFile":
        String assetFilePath = call.arguments["assetFilePath"];
        await loadFile(assetFilePath: assetFilePath);
        break;
      case "reload":
        await reload();
        break;
      case "goBack":
        await goBack();
        break;
      case "goForward":
        await goForward();
        break;
      case "goBackOrForward":
        int steps = call.arguments["steps"];
        await goBackOrForward(steps: steps);
        break;
      case "isLoading":
        return isLoading;
      case "evaluateJavascript":
        String source = call.arguments["source"];
        return await evaluateJavascript(source: source);
      case "stopLoading":
        await stopLoading();
        break;
      case "getSettings":
        return await getSettings();
      case "setSettings":
        InAppWebViewSettings newSettings = InAppWebViewSettings.fromMap(
                call.arguments["settings"].cast<String, dynamic>()) ??
            InAppWebViewSettings();
        await setSettings(newSettings);
        break;
      case "getUrl":
        return await getUrl();
      case "getTitle":
        return await getTitle();
      case "postUrl":
        String url = call.arguments["url"];
        Uint8List postData = call.arguments["postData"];
        return await postUrl(url: url, postData: postData);
      case "injectJavascriptFileFromUrl":
        String urlFile = call.arguments["urlFile"];
        Map<String, dynamic> scriptHtmlTagAttributes =
            call.arguments["scriptHtmlTagAttributes"].cast<String, dynamic>();
        await injectJavascriptFileFromUrl(
            urlFile: urlFile, scriptHtmlTagAttributes: scriptHtmlTagAttributes);
        break;
      case "injectCSSCode":
        String source = call.arguments["source"];
        await injectCSSCode(source: source);
        break;
      case "injectCSSFileFromUrl":
        String urlFile = call.arguments["urlFile"];
        Map<String, dynamic> cssLinkHtmlTagAttributes =
            call.arguments["cssLinkHtmlTagAttributes"].cast<String, dynamic>();
        await injectCSSFileFromUrl(
            urlFile: urlFile,
            cssLinkHtmlTagAttributes: cssLinkHtmlTagAttributes);
        break;
      case "scrollTo":
        int x = call.arguments["x"];
        int y = call.arguments["y"];
        bool animated = call.arguments["animated"];
        await scrollTo(x: x, y: y, animated: animated);
        break;
      case "scrollBy":
        int x = call.arguments["x"];
        int y = call.arguments["y"];
        bool animated = call.arguments["animated"];
        await scrollBy(x: x, y: y, animated: animated);
        break;
      case "printCurrentPage":
        await printCurrentPage();
        break;
      case "getContentHeight":
        return await getContentHeight();
      case "getContentWidth":
        return await getContentWidth();
      case "getOriginalUrl":
        return await getOriginalUrl();
      case "getSelectedText":
        return await getSelectedText();
      case "getScrollX":
        return await getScrollX();
      case "getScrollY":
        return await getScrollY();
      case "isSecureContext":
        return await isSecureContext();
      case "canScrollVertically":
        return await canScrollVertically();
      case "canScrollHorizontally":
        return await canScrollHorizontally();
      case "dispose":
        dispose();
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'flutter_inappwebview for web doesn\'t implement \'${call.method}\'',
        );
    }
    return null;
  }

  void prepare() {
    if (headlessWebViewId != null) {
      final headlessWebView =
          HeadlessInAppWebViewManager.webViews[headlessWebViewId!];
      if (headlessWebView != null && headlessWebView.webView != null) {
        final webView = headlessWebView.disposeAndGetFlutterWebView();
        if (webView != null) {
          webView.iframe.id = iframe.id;
          iframe.remove();
          iframeContainer.append(webView.iframe);
          iframe = webView.iframe;

          initialSettings = webView.initialSettings;
          settings = webView.settings;
          initialUrlRequest = webView.initialUrlRequest;
          initialData = webView.initialData;
          initialFile = webView.initialFile;

          jsWebView = flutterInAppWebView?.createFlutterInAppWebView(
              _viewId, iframe, iframeContainer);
        }
      }
    }

    if (headlessWebViewId == null && settings == null) {
      settings = initialSettings ?? InAppWebViewSettings();

      Set<Sandbox> sandbox = Set.from(Sandbox.values);

      if (settings!.javaScriptEnabled != null &&
          !settings!.javaScriptEnabled!) {
        sandbox.remove(Sandbox.ALLOW_SCRIPTS);
      }

      iframe.allow = settings!.iframeAllow ?? iframe.allow;
      iframe.allowFullscreen =
          settings!.iframeAllowFullscreen ?? iframe.allowFullscreen;
      iframe.referrerPolicy = settings!.iframeReferrerPolicy?.toNativeValue() ??
          iframe.referrerPolicy;
      iframe.name = settings!.iframeName ?? iframe.name;
      iframe.csp = settings!.iframeCsp ?? iframe.csp;

      if (settings!.iframeSandbox != null &&
          settings!.iframeSandbox != Sandbox.ALLOW_ALL) {
        iframe.setAttribute("sandbox",
            settings!.iframeSandbox!.map((e) => e.toNativeValue()).join(" "));
      } else if (settings!.iframeSandbox == Sandbox.ALLOW_ALL) {
        iframe.removeAttribute("sandbox");
      } else if (sandbox != Sandbox.values) {
        iframe.setAttribute(
            "sandbox", sandbox.map((e) => e.toNativeValue()).join(" "));
        settings!.iframeSandbox = sandbox;
      }
    }

    jsWebView?.prepare(settings?.toMap().jsify());
  }

  void makeInitialLoad() async {
    if (initialUrlRequest != null) {
      loadUrl(urlRequest: initialUrlRequest!);
    } else if (initialData != null) {
      loadData(data: initialData!.data, mimeType: initialData!.mimeType);
    } else if (initialFile != null) {
      loadFile(assetFilePath: initialFile!);
    }
  }

  Future<XMLHttpRequest> _makeRequest(URLRequest urlRequest,
      {bool? withCredentials,
      String? responseType,
      String? mimeType,
      void onProgress(ProgressEvent e)?}) {
    return HttpRequest.request(urlRequest.url?.toString() ?? 'about:blank',
        method: urlRequest.method,
        requestHeaders: urlRequest.headers,
        sendData: urlRequest.body,
        withCredentials: withCredentials,
        responseType: responseType,
        mimeType: mimeType,
        onProgress: onProgress);
  }

  String _convertHttpResponseToData(XMLHttpRequest httpRequest) {
    final String contentType =
        httpRequest.getResponseHeader('content-type') ?? 'text/html';
    return 'data:$contentType,' + Uri.encodeComponent(httpRequest.responseText);
  }

  String getIFrameId() {
    return iframe.id;
  }

  Future<void> loadUrl({required URLRequest urlRequest}) async {
    if ((urlRequest.method == null || urlRequest.method == "GET") &&
        (urlRequest.headers == null || urlRequest.headers!.isEmpty)) {
      iframe.src = urlRequest.url.toString();
    } else {
      try {
        iframe.src = _convertHttpResponseToData(await _makeRequest(urlRequest));
      } catch (e) {
        log('Can\'t load the URLRequest for "${urlRequest.url}". Probably caused by a CORS policy error.',
            name: runtimeType.toString(), error: e);
        if (urlRequest.method == null || urlRequest.method == "GET") {
          log('Load the request using just the URL.',
              name: runtimeType.toString(), error: e);
          iframe.src = urlRequest.url.toString();
        }
      }
    }
  }

  Future<void> loadData(
      {required String data, String mimeType = "text/html"}) async {
    iframe.src = 'data:$mimeType,' + Uri.encodeComponent(data);
  }

  Future<void> loadFile({required String assetFilePath}) async {
    iframe.src = assetFilePath;
  }

  Future<void> reload() async {
    jsWebView?.reload();
  }

  Future<void> goBack() async {
    jsWebView?.goBack();
  }

  Future<void> goForward() async {
    jsWebView?.goForward();
  }

  Future<void> goBackOrForward({required int steps}) async {
    jsWebView?.goBackOrForward(steps.toJS);
  }

  Future<dynamic> evaluateJavascript({required String source}) async {
    return jsWebView?.evaluateJavascript(source.toJS)?.toDart;
  }

  Future<void> stopLoading() async {
    jsWebView?.stopLoading();
  }

  Future<String?> getUrl() async {
    String? url = jsWebView?.getUrl()?.toDart;
    if (url == null || url.isEmpty || url == 'about:blank') {
      url = iframe.src;
    }
    return url;
  }

  Future<String?> getTitle() async {
    return jsWebView?.getTitle()?.toDart;
  }

  Future<void> postUrl(
      {required String url, required Uint8List postData}) async {
    await loadUrl(
        urlRequest:
            URLRequest(url: WebUri(url), method: "POST", body: postData));
  }

  Future<void> injectJavascriptFileFromUrl(
      {required String urlFile,
      Map<String, dynamic>? scriptHtmlTagAttributes}) async {
    jsWebView?.injectJavascriptFileFromUrl(
        urlFile.toJS, scriptHtmlTagAttributes?.jsify());
  }

  Future<void> injectCSSCode({required String source}) async {
    jsWebView?.injectCSSCode(source.toJS);
  }

  Future<void> injectCSSFileFromUrl(
      {required String urlFile,
      Map<String, dynamic>? cssLinkHtmlTagAttributes}) async {
    jsWebView?.injectCSSFileFromUrl(
        urlFile.toJS, cssLinkHtmlTagAttributes?.jsify());
  }

  Future<void> scrollTo(
      {required int x, required int y, bool animated = false}) async {
    jsWebView?.scrollTo(x.toJS, y.toJS, animated.toJS);
  }

  Future<void> scrollBy(
      {required int x, required int y, bool animated = false}) async {
    jsWebView?.scrollBy(x.toJS, y.toJS, animated.toJS);
  }

  Future<void> printCurrentPage() async {
    jsWebView?.printCurrentPage();
  }

  Future<int?> getContentHeight() async {
    return jsWebView?.getContentHeight()?.toDartInt;
  }

  Future<int?> getContentWidth() async {
    return jsWebView?.getContentWidth()?.toDartInt;
  }

  Future<String?> getOriginalUrl() async {
    return iframe.src;
  }

  Future<String?> getSelectedText() async {
    final jsPromise = jsWebView?.getSelectedText();
    if (jsPromise != null) {
      return jsPromise.toDart.then((value) => value?.toDart);
    }
    return null;
  }

  Future<int?> getScrollX() async {
    return jsWebView?.getScrollX()?.toDartInt;
  }

  Future<int?> getScrollY() async {
    return jsWebView?.getScrollY()?.toDartInt;
  }

  Future<bool> isSecureContext() async {
    return jsWebView?.isSecureContext().toDart ?? false;
  }

  Future<bool> canScrollVertically() async {
    return jsWebView?.canScrollVertically().toDart ?? false;
  }

  Future<bool> canScrollHorizontally() async {
    return jsWebView?.canScrollHorizontally().toDart ?? false;
  }

  Set<Sandbox> getSandbox() {
    var sandbox = iframe.sandbox;
    Set<Sandbox> values = Set();
    for (int i = 0; i < sandbox.length; i++) {
      var token = Sandbox.fromNativeValue(sandbox.item(i));
      if (token != null) {
        values.add(token);
      }
    }
    return values.isEmpty ? Set.from(Sandbox.values) : values;
  }

  Size getSize() {
    var size = jsWebView?.getSize();
    return Size(size!.width!.toDartDouble, size.height!.toDartDouble);
  }

  Future<void> setSettings(InAppWebViewSettings newSettings) async {
    Set<Sandbox> sandbox = getSandbox();

    if (newSettings.javaScriptEnabled != null &&
        settings!.javaScriptEnabled != newSettings.javaScriptEnabled) {
      if (!newSettings.javaScriptEnabled!) {
        sandbox.remove(Sandbox.ALLOW_SCRIPTS);
      } else {
        sandbox.add(Sandbox.ALLOW_SCRIPTS);
      }
    }

    if (settings!.iframeAllow != newSettings.iframeAllow) {
      iframe.allow = newSettings.iframeAllow ?? '';
    }
    if (settings!.iframeAllowFullscreen != newSettings.iframeAllowFullscreen) {
      iframe.allowFullscreen = newSettings.iframeAllowFullscreen ?? false;
    }
    if (settings!.iframeReferrerPolicy != newSettings.iframeReferrerPolicy) {
      iframe.referrerPolicy =
          newSettings.iframeReferrerPolicy?.toNativeValue() ?? '';
    }
    if (settings!.iframeName != newSettings.iframeName) {
      iframe.name = newSettings.iframeName ?? '';
    }
    if (settings!.iframeCsp != newSettings.iframeCsp) {
      iframe.csp = newSettings.iframeCsp;
    }

    if (settings!.iframeSandbox != newSettings.iframeSandbox) {
      var sandbox = newSettings.iframeSandbox;
      if (sandbox != null && sandbox != Sandbox.ALLOW_ALL) {
        iframe.setAttribute(
            "sandbox", sandbox.map((e) => e.toNativeValue()).join(" "));
      } else if (sandbox == Sandbox.ALLOW_ALL) {
        iframe.removeAttribute("sandbox");
      }
    } else if (sandbox != Sandbox.values) {
      iframe.setAttribute(
          "sandbox", sandbox.map((e) => e.toNativeValue()).join(" "));
    }
    newSettings.iframeSandbox = sandbox;

    jsWebView?.setSettings(newSettings.toMap().jsify());

    settings = newSettings;
  }

  Future<Map<String, dynamic>> getSettings() async {
    return settings!.toMap();
  }

  void onLoadStart(String url) async {
    isLoading = true;

    var obj = {"url": url};
    await _channel?.invokeMethod("onLoadStart", obj);
  }

  void onLoadStop(String url) async {
    isLoading = false;

    var obj = {"url": url};
    await _channel?.invokeMethod("onLoadStop", obj);
  }

  void onUpdateVisitedHistory(String url) async {
    var obj = {"url": url};
    await _channel?.invokeMethod("onUpdateVisitedHistory", obj);
  }

  void onScrollChanged(int x, int y) async {
    var obj = {"x": x, "y": y};
    await _channel?.invokeMethod("onScrollChanged", obj);
  }

  void onConsoleMessage(String type, String? message) async {
    int messageLevel = 1;
    switch (type) {
      case 'debug':
        messageLevel = 0;
        break;
      case 'error':
        messageLevel = 3;
        break;
      case 'warn':
        messageLevel = 2;
        break;
      case 'info':
      case 'log':
      default:
        messageLevel = 1;
    }
    var obj = {"messageLevel": messageLevel, "message": message};
    await _channel?.invokeMethod("onConsoleMessage", obj);
  }

  Future<bool?> onCreateWindow(
      int windowId, String url, String? target, String? windowFeatures) async {
    Map<String, dynamic> windowFeaturesMap = {};
    List<String> features = windowFeatures?.split(",") ?? [];
    for (var feature in features) {
      var keyValue = feature.trim().split("=");
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1].trim();
        if (['height', 'width', 'x', 'y'].contains(key)) {
          windowFeaturesMap[key] = double.parse(value);
        } else {
          windowFeaturesMap[key] = value;
        }
      }
    }

    var obj = {
      "windowId": windowId,
      "isForMainFrame": true,
      "request": {"url": url, "method": "GET"},
      "windowFeatures": windowFeaturesMap
    };
    return await _channel?.invokeMethod("onCreateWindow", obj);
  }

  void onWindowFocus() async {
    await _channel?.invokeMethod("onWindowFocus");
  }

  void onWindowBlur() async {
    await _channel?.invokeMethod("onWindowBlur");
  }

  void onPrintRequest(String? url) async {
    var obj = {"url": url, "printJobId": null};

    await _channel?.invokeMethod("onPrintRequest", obj);
  }

  void onEnterFullscreen() async {
    await _channel?.invokeMethod("onEnterFullscreen");
  }

  void onExitFullscreen() async {
    await _channel?.invokeMethod("onExitFullscreen");
  }

  void onTitleChanged(String? title) async {
    var obj = {"title": title};

    await _channel?.invokeMethod("onTitleChanged", obj);
  }

  void onZoomScaleChanged(double oldScale, double newScale) async {
    var obj = {"oldScale": oldScale, "newScale": newScale};

    await _channel?.invokeMethod("onZoomScaleChanged", obj);
  }

  void onInjectedScriptLoaded(String id) async {
    await _channel?.invokeMethod("onInjectedScriptLoaded", [id]);
  }

  void onInjectedScriptError(String id) async {
    await _channel?.invokeMethod("onInjectedScriptError", [id]);
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    _channel = null;
    iframeContainer.remove();
    if (WebPlatformManager.webViews.containsKey(_viewId)) {
      WebPlatformManager.webViews.remove(_viewId);
    }
  }
}
