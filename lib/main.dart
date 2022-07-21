import 'package:engelsburg_app/src/common/shared_prefs.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  if (SharedPrefs.instance.getBool('isLoggedIn') == true &&
      SharedPrefs.instance.getBool('is_logged_in') == null) {
    SharedPrefs.instance.setBool('is_logged_in', true);
  }

  runApp(const EngelsburgApp());
}
