import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? instance;
  static Future init() async {
    instance = await SharedPreferences.getInstance();
  }
}
