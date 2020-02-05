import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'main.dart';
import 'schoolinfo_page.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Die Strings werden geändert, wenn PackageInfo die Daten der App geladen hat.
  String appName = "";
  String packageName = "";
  String version = "";
  // Notiz, dass die App nicht von der Schule ist, MUSS erhalten bleiben.
  final String appDescription =
      "Eine App von Dario Trombello (Klasse 10d), die Informationen über das Engelsburg-Gymnasium übersichtlich zusammenstellt.";

  void initializePackageInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
      });
    });
  }

  void initState() {
    super.initState();
    initializePackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        text: "Über",
        withBackButton: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.asset("assets/applogo.png"),
            title: Text(
              appName,
            ),
            subtitle: Text(
              version,
            ),
            trailing: IconButton(icon: Icon(Icons.info), onPressed: null),
          ),
          ListTile(
            title: Text(
              appDescription,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_half),
            title: Text(
              'App Bewerten',
            ),
            onTap: () => url_launcher.launch(
                "https://play.google.com/store/apps/details?id=de.dariotrombello.engelsburg_app"),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text(
              'Quellcode auf GitHub',
            ),
            onTap: () => url_launcher
                .launch("https://github.com/dariotrombello/engelsburg_app"),
          ),
          ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text(
              'Besuche meine Webseite',
            ),
            onTap: () => url_launcher.launch("https://dariotrombello.de"),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(
              'Schreibe mir eine E-Mail',
            ),
            onTap: () => url_launcher.launch("mailto:dariotrombello@gmail.com"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.school),
            title: Text(
              'Über die Schule',
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SchoolInfoPage())),
          ),
        ],
      ),
    );
  }
}
