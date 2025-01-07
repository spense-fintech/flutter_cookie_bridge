enum WebViewCallbackType {
  logout,
  redirect,
}

class WebViewCallback {
  final WebViewCallbackType type;
  final String? status;

  const WebViewCallback.logout()
      : type = WebViewCallbackType.logout,
        status = null;
  const WebViewCallback.redirect(this.status)
      : type = WebViewCallbackType.redirect;
}

typedef WebViewCallbackFunction = void Function(WebViewCallback);
