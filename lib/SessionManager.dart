import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  static const String _cookieKey = 'session_cookies';

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> saveSessionCookies(List<String> cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookiesString = cookies.join('; ');
    await prefs.setString(_cookieKey, cookiesString);
    print("Saving session  cookies: $_cookieKey : $cookiesString");
  }

  Future<List<String>> getSessionCookies() async {
    print("Retrieving session cookies...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookieString = prefs.getString(_cookieKey);
    print("Current stored cookies: $cookieString");
    if (cookieString != null && cookieString.isNotEmpty) {
      return cookieString.split('; ');
    }
    print("no session cookies in session manager class ");

    return [];
  }

  Future<void> clearSession() async {
    print("Clearing session cookies...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cookieKey);
  }
}
