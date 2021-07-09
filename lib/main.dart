import 'package:engelsburg_app/constants/app_constants.dart';
import 'package:engelsburg_app/provider/theme.dart';
import 'package:engelsburg_app/pages/home_page.dart';
import 'package:engelsburg_app/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
      ],
      child: const EngelsburgApp(),
    ),
  );
}

class EngelsburgApp extends StatelessWidget {
  const EngelsburgApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light().copyWith(
          primary: themeChanger.primaryColor,
          secondary: themeChanger.secondaryColor,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: themeChanger.primaryColor,
          secondary: themeChanger.secondaryColor,
        ),
      ),
      themeMode: themeChanger.themeMode,
      home: const HomePage(),
    );
  }
}
