import 'package:engelsburg_app/about_page.dart';
import 'package:flutter/material.dart';

import 'cafeteria_page.dart';
import 'news_page.dart';
import 'school_newspaper_page.dart';
import 'settings_page.dart';
import 'solarpanel_page.dart';
import 'events_page.dart';
import 'substitution_plan_page.dart';
import 'weather_page.dart';

void main() {
  runApp(MaterialApp(
    home: EngelsburgApp(),
    theme: ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    darkTheme: ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class EngelsburgApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EngelsburgAppState();
}

class _EngelsburgAppState extends State<EngelsburgApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          NewsPage(),
          CafeteriaPage(),
          SchoolNewspaperPage(),
          SubstitutionPlanPage()
        ],
        index: _currentIndex,
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
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Engelsburg-App'))
                ]),
              ),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(
                'Daten der Solaranlage',
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SolarPanelPage())),
            ),
            ListTile(
              leading: Icon(Icons.watch_later),
              title: Text(
                'Termine',
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EventsPage())),
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text(
                'Wetter',
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WeatherPage())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Einstellungen',
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutPage())))
        ],
        centerTitle: true,
        title: Text('Engelsburg-App'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor:
            Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
        unselectedItemColor:
            Theme.of(context).buttonTheme.colorScheme.secondary,
        items: [
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
