import 'package:engelsburg_app/src/about/about_view.dart';
import 'package:engelsburg_app/src/about_school/about_school_view.dart';
import 'package:engelsburg_app/src/home/home_view.dart';
import 'package:engelsburg_app/src/solar_panel/solar_panel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings/settings_view.dart';

/// The Widget that configures your application.
class EngelsburgApp extends StatelessWidget {
  const EngelsburgApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'engelsburg_app',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('de', ''),
        ],
        title: 'Engelsburg-App',
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case AboutView.routeName:
                  return const AboutView();
                case AboutSchoolView.routeName:
                  return const AboutSchoolView();
                case SettingsView.routeName:
                  return const SettingsView();
                case SolarPanelView.routeName:
                  return const SolarPanelView();
                default:
                  return const HomeView();
              }
            },
          );
        },
      ),
    );
  }
}
