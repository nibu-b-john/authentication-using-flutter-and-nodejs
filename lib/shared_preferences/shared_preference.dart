import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;
  static const _keyToken = "token";
  static Future init() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  static Future setToken(dynamic token) async {
    return await _preferences.setString(_keyToken, token);
  }

  static Future getToken() async {
    return _preferences.getString(_keyToken);
  }

  static Future remove() async {
    return await _preferences.remove(_keyToken);
  }
}
