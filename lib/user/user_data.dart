import 'dart:convert';
import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    image:
    "https://luxskogo-r24.gosweb.gosuslugi.ru/netcat_files/9/261/nonePhoto_15.png",
    name: 'Елизавета Булдыгина',
    email: 'test.test@gmail.com',
    phone: '7 (916) 555 222-44-75',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}