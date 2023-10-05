

import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keyUsername = "username";
  static const _keyEmail = "email";
  static const _keyCurrency = "currency";
  static const _keyImage = "image";

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserInfo(
    String username,
    String email,
    String currency,
  ) async {
    await _preferences!.setString(_keyUsername, username);
    await _preferences!.setString(_keyEmail, email);
    await _preferences!.setString(_keyCurrency, currency);
  }

  static Future saveImage(String value) async {
    await _preferences!.setString(_keyImage, value);
  }

  static String? getUsername() => _preferences!.getString(_keyUsername);
  static String? getEmail() => _preferences!.getString(_keyEmail);
  static String? getCurrency() => _preferences!.getString(_keyCurrency);
  static String? getImage() => _preferences!.getString(_keyImage);
}
