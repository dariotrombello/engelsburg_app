import 'package:engelsburg_app/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cafeteria_page.dart';
import 'news_page.dart';
import 'school_newspaper_page.dart';
import 'settings_page.dart';
import 'solarpanel_page.dart';
import 'events_page.dart';
import 'substitution_plan_page.dart';
import 'weather_page.dart';

class SharedPrefs {
  static SharedPreferences instance;
  static Future init() async {
    instance = await SharedPreferences.getInstance();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('de')],
    home: const EngelsburgApp(),
    theme: ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    darkTheme: ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class EngelsburgApp extends StatefulWidget {
  const EngelsburgApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EngelsburgAppState();
}

class _EngelsburgAppState extends State<EngelsburgApp> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          NewsPage(),
          CafeteriaPage(),
          SchoolNewspaperPage(),
          SubstitutionPlanPage()
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: DrawerHeader(
                child: Stack(children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'assets/images/applogo.png',
                        height: 72,
                      )),
                  const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Engelsburg-App'))
                ]),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text(
                'Daten der Solaranlage',
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SolarPanelPage())),
            ),
            ListTile(
              leading: const Icon(Icons.watch_later),
              title: const Text(
                'Termine',
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const EventsPage())),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text(
                'Wetter',
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const WeatherPage())),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Einstellungen',
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage())),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              tooltip: 'Über',
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const AboutPage())))
        ],
        centerTitle: true,
        title: const Text('Engelsburg-App'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor:
            Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
        unselectedItemColor:
            Theme.of(context).buttonTheme.colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.library_books),
              icon: Icon(Icons.library_books),
              label: 'News'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.local_dining),
              icon: Icon(Icons.local_dining),
              label: 'Cafeteria'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.import_contacts),
              icon: Icon(Icons.import_contacts),
              label: 'Schülerzeitung'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.dashboard),
              icon: Icon(Icons.dashboard),
              label: 'Vertretungsplan'),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
