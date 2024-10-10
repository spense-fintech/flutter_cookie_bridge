import 'package:shared_preferences/shared_preferences.dart';

//Can use Encrypted Network Manager..
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
  }

  Future<List<String>> getSessionCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookieString = prefs.getString(_cookieKey);
    if (cookieString != null && cookieString.isNotEmpty) {
      return cookieString.split('; ');
    }
    return [];
  }

  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cookieKey);
  }
}
