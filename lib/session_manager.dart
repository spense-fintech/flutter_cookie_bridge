import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cookieKey);
      await CookieManager.instance().deleteAllCookies();
    } catch (e) {
      debugPrint('Error clearing session: $e');
      rethrow;
    }
  }
}
