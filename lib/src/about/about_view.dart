import 'package:engelsburg_app/src/about/about_service.dart';
import 'package:engelsburg_app/src/about_school/about_school_view.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'about_controller.dart';

class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  static const routeName = '/about';

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  // Notiz, dass die App nicht von der Schule ist, MUSS erhalten bleiben.
  final appDescription =
      'Eine App von Dario Trombello (Q3, Englisch-LK CAW), die Informationen über das Engelsburg-Gymnasium übersichtlich zusammenstellt.';

  // Die Strings werden geändert, wenn PackageInfo die Daten der App geladen hat.
  var _packageInfo = PackageInfo(
    appName: 'Engelsburg-App',
    packageName: 'Lade...',
    version: 'Lade...',
    buildNumber: 'Lade...',
  );

  Future<void> _initPackageInfo() async {
    final info = await AboutService.getPackageInfo();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Über'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/applogo.png'),
            title: Text(
              _packageInfo.appName.toString(),
            ),
            subtitle: Text(
              _packageInfo.version.toString(),
            ),
          ),
          ListTile(
            title: Text(
              appDescription.toString(),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.star_half),
            title: Text(
              'App bewerten',
            ),
            onTap: AboutController.openReview,
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text(
              'Quellcode auf GitHub',
            ),
            onTap: AboutController.openGithub,
          ),
          const ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text(
              'Besuche meine Webseite',
            ),
            onTap: AboutController.openHomepage,
          ),
          const ListTile(
            leading: Icon(Icons.mail),
            title: Text(
              'Schreibe mir eine E-Mail',
            ),
            onTap: AboutController.openEmailApp,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(
              'Open-Source-Lizenzen',
            ),
            onTap: () => showLicensePage(
                applicationIcon: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/applogo.png',
                    height: 64.0,
                  ),
                ),
                applicationName: _packageInfo.appName.toString(),
                applicationVersion: _packageInfo.version.toString(),
                context: context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text(
              'Über die Schule',
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(AboutSchoolView.routeName),
          ),
        ],
      ),
    );
  }
}
