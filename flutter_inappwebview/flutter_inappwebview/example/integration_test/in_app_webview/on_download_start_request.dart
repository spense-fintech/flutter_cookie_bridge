part of 'main.dart';

void onDownloadStartRequest() {
  final shouldSkip = kIsWeb
      ? true
      : ![
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        ].contains(defaultTargetPlatform);

  skippableTestWidgets('onDownloadStartRequest', (WidgetTester tester) async {
    final Completer<InAppWebViewController> controllerCompleter =
        Completer<InAppWebViewController>();
    final Completer<String> onDownloadStartCompleter = Completer<String>();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: InAppWebView(
          key: GlobalKey(),
          initialData: InAppWebViewInitialData(data: """
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>InAppWebViewOnDownloadStartTest</title>
    </head>
    <body>
        <h1>InAppWebViewOnDownloadStartTest</h1>
        <a id="download-file" href="http://${environment["NODE_SERVER_IP"]}:8082/test-download-file">download file</a>
        <script>
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                document.querySelector("#download-file").click();
            });
        </script>
    </body>
</html>
          """),
          onWebViewCreated: (controller) {
            controllerCompleter.complete(controller);
          },
          onDownloadStartRequest: (controller, request) {
            onDownloadStartCompleter.complete(request.url.toString());
          },
        ),
      ),
    );

    final String url = await onDownloadStartCompleter.future;
    expect(
        url, "http://${environment["NODE_SERVER_IP"]}:8082/test-download-file");
  }, skip: shouldSkip);
}
