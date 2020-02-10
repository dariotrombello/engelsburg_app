import 'package:flutter/material.dart';

import 'about_page.dart';
import 'ag-list_page.dart';
import 'cafeteria_page.dart';
import 'news_page.dart';
import 'schuelerzeitung_page.dart';
import 'settings_page.dart';
import 'solarpanel_page.dart';
import 'termine_page.dart';
import 'vertretungsplan_page.dart';
import 'weather_page.dart';

void main() {
  runApp(MaterialApp(
    home: EngelsburgApp(),
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
  ));
}

class EngelsburgApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EngelsburgAppState();
}

class _EngelsburgAppState extends State<EngelsburgApp> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          NewsPage(),
          CafeteriaPage(),
          SchuelerzeitungPage(),
          VertretungsplanPage()
        ],
        physics: NeverScrollableScrollPhysics(),
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
                        "assets/applogo.png",
                        height: 72,
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Engelsburg-App"))
                ]),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(
                "AGs",
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AGListPage())),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(
                "Daten der Solaranlage",
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SolarPanelPage())),
            ),
            ListTile(
              leading: Icon(Icons.watch_later),
              title: Text(
                "Termine",
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TerminePage())),
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text(
                "Wetter",
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WeatherPage())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "Einstellungen",
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
          ],
        ),
      ),
      appBar: EngelsburgAppBar(
        title: "Engelsburg-App",
        withBackButton: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.library_books,
                color:
                    Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
              ),
              icon: Icon(Icons.library_books,
                  color: Theme.of(context).buttonTheme.colorScheme.secondary),
              title: Text('News',
                  style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor))),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.local_dining,
                color:
                    Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
              ),
              icon: Icon(Icons.local_dining,
                  color: Theme.of(context).buttonTheme.colorScheme.secondary),
              title: Text('Caféteria',
                  style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor))),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.import_contacts,
                color:
                    Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
              ),
              icon: Icon(Icons.import_contacts,
                  color: Theme.of(context).buttonTheme.colorScheme.secondary),
              title: Text('Schülerzeitung',
                  style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor))),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.dashboard,
                color:
                    Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
              ),
              icon: Icon(Icons.dashboard,
                  color: Theme.of(context).buttonTheme.colorScheme.secondary),
              title: Text('Vertretungsplan',
                  style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor))),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }
}

class EngelsburgAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool withBackButton;

  EngelsburgAppBar({Key key, this.title, this.withBackButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    withBackButton ?? false
                        ? IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        : IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                    Expanded(
                      child: Text(
                        title ?? "Engelsburg-App",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    Visibility(
                      visible: !withBackButton ?? true,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage())),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
