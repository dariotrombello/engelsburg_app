import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutSchoolPage extends StatelessWidget {
  final LatLng _engelsburgPosition = LatLng(51.315228, 9.488160);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Über die Schule"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset("assets/images/school.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Text(
              "Info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
          Text(
              "Das Engelsburg-Gymnasium ist ein staatlich anerkanntes katholisches Gymnasium in Trägerschaft des Ordens der Schwestern der heiligen Maria Magdalena Postel (SMMP). Es ist ausgezeichnet mit dem Gütesiegel „Hochbegabtenförderung“ des Landes Hessen. An der Schule werden die Schulformen G8 und G9 parallel unterrichtet."),
          RichText(
              text: TextSpan(
                  text: "Quelle: ",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                  children: [
                TextSpan(
                    text: "kassel.de",
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        url_launcher.launch(
                            "https://www1.kassel.de/verzeichnisse/schulen/gymnasiale-oberstufen-und-gymnasien/engelsburg.php");
                      })
              ])),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Text(
              "Standort",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: SizedBox(
              height: 250,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                liteModeEnabled: Platform.isAndroid,
                initialCameraPosition:
                    CameraPosition(target: _engelsburgPosition, zoom: 14.0),
                markers: {
                  Marker(
                    markerId: MarkerId("0"),
                    position: _engelsburgPosition,
                    infoWindow: InfoWindow(
                      title: "Engelsburg-Gymnasium",
                      snippet: "Richardweg 3, 34117 Kassel",
                    ),
                  ),
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
          ),
          ListTile(
              leading: Icon(Icons.phone),
              title: Text("Pforte anrufen"),
              onTap: () => url_launcher.launch("tel:+49561789670")),
          ListTile(
              leading: Icon(Icons.phone),
              title: Text("Sekretariat anrufen"),
              onTap: () => url_launcher.launch("tel:+495617896727")),
          ListTile(
              leading: Icon(Icons.mail),
              title: Text("E-Mail an das Sekretariat"),
              onTap: () =>
                  url_launcher.launch("mailto:sekretariat@engelsburg.smmp.de")),
        ],
      ),
    );
  }
}
