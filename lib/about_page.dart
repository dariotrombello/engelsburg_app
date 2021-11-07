import 'dart:io';

import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'about_school_page.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Notiz, dass die App nicht von der Schule ist, MUSS erhalten bleiben.
  final appDescription =
      'Eine App von Dario Trombello (E2, Englisch-LK CAW), die Informationen über das Engelsburg-Gymnasium übersichtlich zusammenstellt.';

  // Die Strings werden geändert, wenn PackageInfo die Daten der App geladen hat.
  var _packageInfo = PackageInfo(
    appName: 'Engelsburg-App',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
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
        title: Text('Über'),
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
          Divider(),
          ListTile(
            leading: Icon(Icons.star_half),
            title: Text(
              'App bewerten',
            ),
            onTap: () => url_launcher.launch(Platform.isIOS
                ? 'https://apps.apple.com/app/engelsburg-app/id1529725542'
                : 'https://play.google.com/store/apps/details?id=de.dariotrombello.engelsburg_app'),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text(
              'Quellcode auf GitHub',
            ),
            onTap: () => url_launcher
                .launch('https://github.com/dariotrombello/engelsburg_app'),
          ),
          ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text(
              'Besuche meine Webseite',
            ),
            onTap: () => url_launcher.launch('https://www.dariotrombello.com'),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(
              'Schreibe mir eine E-Mail',
            ),
            onTap: () => url_launcher.launch('mailto:info@dariotrombello.com'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
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
          Divider(),
          ListTile(
            leading: Icon(Icons.school),
            title: Text(
              'Über die Schule',
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutSchoolPage())),
          ),
        ],
      ),
    );
  }
}
