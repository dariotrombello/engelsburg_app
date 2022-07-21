import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences instance;
  static Future init() async {
    instance = await SharedPreferences.getInstance();
  }
}
