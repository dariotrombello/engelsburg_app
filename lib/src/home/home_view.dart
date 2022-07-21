import 'package:engelsburg_app/src/about/about_view.dart';
import 'package:engelsburg_app/src/events/events_view.dart';
import 'package:engelsburg_app/src/news/news_view.dart';
import 'package:engelsburg_app/src/settings/settings_view.dart';
import 'package:engelsburg_app/src/solar_panel/solar_panel_view.dart';
import 'package:engelsburg_app/src/substitution_plan/substitution_plan_view.dart';
import 'package:engelsburg_app/src/weather/weather_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PageController _pageController;
  final _pages = [
    const NewsView(),
    const SubstitutionPlanView(),
    const EventsView(),
    const WeatherView()
  ];
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
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
              onTap: () =>
                  Navigator.of(context).pushNamed(SolarPanelView.routeName),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Einstellungen',
              ),
              onTap: () =>
                  Navigator.of(context).pushNamed(SettingsView.routeName),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              tooltip: 'Über',
              icon: const Icon(Icons.info_outline),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AboutView.routeName)),
        ],
        centerTitle: true,
        title: const Text('Engelsburg-App'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: onTabTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.library_books), label: 'News'),
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Plan'),
          NavigationDestination(
              icon: Icon(Icons.watch_later), label: 'Termine'),
          NavigationDestination(icon: Icon(Icons.cloud), label: 'Wetter'),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(_currentIndex);
    });
  }
}
