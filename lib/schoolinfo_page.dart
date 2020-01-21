import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'main.dart';

class SchoolInfoPage extends StatelessWidget {
  final LatLng _engelsburgPosition = LatLng(51.315334, 9.488239);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        text: "Über die Schule",
        withBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Image.asset("assets/school.jpg"),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
          ),
          Text(
              "Das Engelsburg-Gymnasium ist ein staatlich anerkanntes katholisches Gymnasium in Trägerschaft des Ordens der Schwestern der heiligen Maria Magdalena Postel (SMMP). Es ist ausgezeichnet mit dem Gütesiegel „Hochbegabtenförderung“ des Landes Hessen. An der Schule werden die Schulformen G8 und G9 parallel unterrichtet."),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
          ),
          Text("Informationen\n",
              style: TextStyle(fontWeight: FontWeight.w700)),
          Text(
            "Schulform: Gymnasium\nGründung: 1892\nAdresse: Richardweg 3, 34117 Kassel\nStadt: Kassel\nLand: Hessen\nTräger: Schwestern der hl. Maria Magdalena Postel\nSchüler: 1070\nLehrkräfte: 85\nSchulleitung: Thorsten Prinz, Dr. Monika Rack",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
          ),
          Text(
            "Standort (interaktive Karte)\n",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 250,
            child: FlutterMap(
              options: MapOptions(
                center: _engelsburgPosition,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://api.tiles.mapbox.com/v4/"
                      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiZGFyaW90ciIsImEiOiJjanpmazk2ODIwY3pkM2NzOTdjYmt0eGo1In0.mn-vEcB44386UNqQKK6acg',
                    'id': 'mapbox.streets',
                  },
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      point: _engelsburgPosition,
                      builder: (context) => Container(
                        child: Image.asset("assets/logoengelsburg.png"),
                      ),
                    ),
                  ],
                ),
              ],
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
              title: Text("E-Mail an das Sektretariat"),
              onTap: () =>
                  url_launcher.launch("mailto:sekretariat@engelsburg.smmp.de")),
        ],
      ),
    );
  }
}
