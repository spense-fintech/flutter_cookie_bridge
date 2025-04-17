// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_action.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///An object that contains information about an action that causes navigation to occur.
class NavigationAction {
  ///Use [hasGesture] instead.
  @Deprecated('Use hasGesture instead')
  bool? androidHasGesture;

  ///Use [isRedirect] instead.
  @Deprecated('Use isRedirect instead')
  bool? androidIsRedirect;

  ///Gets whether a gesture (such as a click) was associated with the request.
  ///For security reasons in certain situations this method may return `false` even though
  ///the sequence of events which caused the request to be created was initiated by a user
  ///gesture.
  ///
  ///**NOTE for Android native WebView**: On Android < 21, this is always `false`
  ///
  ///**NOTE for Windows**: Available only if the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView 21+ ([Official API - WebResourceRequest.hasGesture](https://developer.android.com/reference/android/webkit/WebResourceRequest#hasGesture()))
  ///- Windows
  bool? hasGesture;

  ///Use [sourceFrame] instead.
  @Deprecated('Use sourceFrame instead')
  IOSWKFrameInfo? iosSourceFrame;

  ///Use [targetFrame] instead.
  @Deprecated('Use targetFrame instead')
  IOSWKFrameInfo? iosTargetFrame;

  ///Use [navigationType] instead.
  @Deprecated('Use navigationType instead')
  IOSWKNavigationType? iosWKNavigationType;

  ///Indicates whether the request was made for the main frame.
  ///
  ///**NOTE for Android and Windows**: If the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event, this is always `true`.
  ///Also, on Android < 21, this is always `true`.
  bool isForMainFrame;

  ///Gets whether the request was a result of a server-side redirect.
  ///
  ///**NOTE**: If the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event, this is always `false`.
  ///Also, on Android < 21, this is always `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView 21+ ([Official API - WebResourceRequest.isRedirect](https://developer.android.com/reference/android/webkit/WebResourceRequest#isRedirect()))
  ///- Windows
  bool? isRedirect;

  ///The type of action triggering the navigation.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationAction.navigationType](https://developer.apple.com/documentation/webkit/wknavigationaction/1401914-navigationtype))
  ///- MacOS ([Official API - WKNavigationAction.navigationType](https://developer.apple.com/documentation/webkit/wknavigationaction/1401914-navigationtype))
  ///- Windows
  NavigationType? navigationType;

  ///The URL request object associated with the navigation action.
  ///
  ///**NOTE for Android**: If the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event
  ///and the window has been created using JavaScript, [request.url] will be `null`,
  ///the [request.method] is always `GET`, and [request.headers] value is always `null`.
  ///Also, on Android < 21, the [request.method]  is always `GET` and [request.headers] value is always `null`.
  URLRequest request;

  ///A value indicating whether the web content used a download attribute to indicate that this should be downloaded.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS 14.5+ ([Official API - WKNavigationAction.shouldPerformDownload](https://developer.apple.com/documentation/webkit/wknavigationaction/3727357-shouldperformdownload))
  ///- MacOS 11.3+ ([Official API - WKNavigationAction.shouldPerformDownload](https://developer.apple.com/documentation/webkit/wknavigationaction/3727357-shouldperformdownload))
  bool? shouldPerformDownload;

  ///The frame that requested the navigation.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationAction.sourceFrame](https://developer.apple.com/documentation/webkit/wknavigationaction/1401926-sourceframe))
  ///- MacOS ([Official API - WKNavigationAction.sourceFrame](https://developer.apple.com/documentation/webkit/wknavigationaction/1401926-sourceframe))
  FrameInfo? sourceFrame;

  ///The frame in which to display the new content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationAction.targetFrame](https://developer.apple.com/documentation/webkit/wknavigationaction/1401918-targetframe))
  ///- MacOS ([Official API - WKNavigationAction.targetFrame](https://developer.apple.com/documentation/webkit/wknavigationaction/1401918-targetframe))
  FrameInfo? targetFrame;
  NavigationAction(
      {@Deprecated('Use hasGesture instead') this.androidHasGesture,
      @Deprecated('Use isRedirect instead') this.androidIsRedirect,
      this.hasGesture,
      @Deprecated('Use sourceFrame instead') this.iosSourceFrame,
      @Deprecated('Use targetFrame instead') this.iosTargetFrame,
      @Deprecated('Use navigationType instead') this.iosWKNavigationType,
      required this.isForMainFrame,
      this.isRedirect,
      this.navigationType,
      required this.request,
      this.shouldPerformDownload,
      this.sourceFrame,
      this.targetFrame}) {
    hasGesture = hasGesture ?? androidHasGesture;
    isRedirect = isRedirect ?? androidIsRedirect;
    sourceFrame = sourceFrame ?? FrameInfo.fromMap(iosSourceFrame?.toMap());
    targetFrame = targetFrame ?? FrameInfo.fromMap(iosTargetFrame?.toMap());
    navigationType = navigationType ??
        NavigationType.fromNativeValue(iosWKNavigationType?.toNativeValue());
  }

  ///Gets a possible [NavigationAction] instance from a [Map] value.
  static NavigationAction? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = NavigationAction(
      androidHasGesture: map['hasGesture'],
      androidIsRedirect: map['isRedirect'],
      hasGesture: map['hasGesture'],
      iosSourceFrame:
          IOSWKFrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>()),
      iosTargetFrame:
          IOSWKFrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>()),
      iosWKNavigationType:
          IOSWKNavigationType.fromNativeValue(map['navigationType']),
      isForMainFrame: map['isForMainFrame'],
      isRedirect: map['isRedirect'],
      navigationType: NavigationType.fromNativeValue(map['navigationType']),
      request: URLRequest.fromMap(map['request']?.cast<String, dynamic>())!,
      shouldPerformDownload: map['shouldPerformDownload'],
      sourceFrame:
          FrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>()),
      targetFrame:
          FrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>()),
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "hasGesture": hasGesture,
      "isForMainFrame": isForMainFrame,
      "isRedirect": isRedirect,
      "navigationType": navigationType?.toNativeValue(),
      "request": request.toMap(),
      "shouldPerformDownload": shouldPerformDownload,
      "sourceFrame": sourceFrame?.toMap(),
      "targetFrame": targetFrame?.toMap(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'NavigationAction{hasGesture: $hasGesture, isForMainFrame: $isForMainFrame, isRedirect: $isRedirect, navigationType: $navigationType, request: $request, shouldPerformDownload: $shouldPerformDownload, sourceFrame: $sourceFrame, targetFrame: $targetFrame}';
  }
}
