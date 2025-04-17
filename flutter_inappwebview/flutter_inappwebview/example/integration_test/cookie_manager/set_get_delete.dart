part of 'main.dart';

void setGetDelete() {
  final shouldSkip = kIsWeb
      ? true
      : ![
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        ].contains(defaultTargetPlatform);

  skippableTestWidgets('set, get, delete', (WidgetTester tester) async {
    CookieManager cookieManager = CookieManager.instance();
    final Completer<InAppWebViewController> controllerCompleter =
        Completer<InAppWebViewController>();
    final Completer<String> pageLoaded = Completer<String>();

    var headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: TEST_CROSS_PLATFORM_URL_1),
        onWebViewCreated: (controller) {
          controllerCompleter.complete(controller);
        },
        onLoadStop: (controller, url) async {
          pageLoaded.complete(url!.toString());
        });

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      await headlessWebView.run();
    } else {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: InAppWebView(
            key: GlobalKey(),
            initialUrlRequest: URLRequest(url: TEST_CROSS_PLATFORM_URL_1),
            onWebViewCreated: (controller) {
              controllerCompleter.complete(controller);
            },
            initialSettings: InAppWebViewSettings(
              clearCache: true,
            ),
            onLoadStop: (controller, url) {
              pageLoaded.complete(url!.toString());
            },
          ),
        ),
      );
    }

    final url = WebUri(await pageLoaded.future);

    if (defaultTargetPlatform == TargetPlatform.android) {
      await cookieManager.setCookie(
          url: url, name: "myCookie", value: "myValue");
      expect(await cookieManager.removeSessionCookies(), isTrue);
    }

    await cookieManager.setCookie(url: url, name: "myCookie", value: "myValue");
    List<Cookie> cookies = await cookieManager.getCookies(url: url);
    expect(cookies, isNotEmpty);

    Cookie? cookie = await cookieManager.getCookie(url: url, name: "myCookie");
    expect(cookie?.value.toString(), "myValue");

    expect(
        await cookieManager.deleteCookie(url: url, name: "myCookie"), isTrue);
    cookie = await cookieManager.getCookie(url: url, name: "myCookie");
    expect(cookie, isNull);

    expect(
        await cookieManager.deleteCookies(
            url: url, domain: ".${TEST_CROSS_PLATFORM_URL_1.host}"),
        isTrue);
    cookies = await cookieManager.getCookies(url: url);
    expect(cookies, isEmpty);

    await cookieManager.setCookie(url: url, name: "myCookie", value: "myValue");
    expect(await cookieManager.deleteAllCookies(), isTrue);
    cookies = await cookieManager.getCookies(url: url);
    expect(cookies, isEmpty);

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      headlessWebView.dispose();
    }
  }, skip: shouldSkip);
}
