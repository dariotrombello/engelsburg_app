import 'package:engelsburg_app/constants/app_constants.dart';
import 'package:engelsburg_app/pages/about_page.dart';
import 'package:engelsburg_app/pages/events_page.dart';
import 'package:engelsburg_app/pages/settings_page.dart';
import 'package:engelsburg_app/pages/solar_panel_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          const DrawerHeader(
            margin: EdgeInsets.zero,
            child: Text(AppConstants.appName),
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: const Text(AppConstants.dataOfSolarPanel),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SolarPanelPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.watch_later),
            title: const Text(AppConstants.events),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EventsPage()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppConstants.settings),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(AppConstants.about),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: AppConstants.bottomNavigationBarItems,
        onTap: (index) {
          setState(() => _currentPage = index);
          _pageController.jumpToPage(_currentPage);
        },
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: AppConstants.bottomNavigationBarPages,
      ),
    );
  }
}
