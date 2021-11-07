import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutSchoolPage extends StatefulWidget {
  const AboutSchoolPage({Key key}) : super(key: key);

  @override
  _AboutSchoolPageState createState() => _AboutSchoolPageState();
}

class _AboutSchoolPageState extends State<AboutSchoolPage> {
  final LatLng _engelsburgPosition = const LatLng(51.315228, 9.488160);
  GoogleMapController _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Über die Schule'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset('assets/images/school.jpg'),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Text(
              'Info',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
          const Text(
              'Das Engelsburg-Gymnasium ist ein staatlich anerkanntes katholisches Gymnasium in Trägerschaft des Ordens der Schwestern der heiligen Maria Magdalena Postel (SMMP). Es ist ausgezeichnet mit dem Gütesiegel „Hochbegabtenförderung“ des Landes Hessen. An der Schule werden die Schulformen G8 und G9 parallel unterrichtet.'),
          RichText(
              text: TextSpan(
                  text: 'Quelle: ',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                  children: [
                TextSpan(
                    text: 'kassel.de',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        url_launcher.launch(
                            'https://www1.kassel.de/verzeichnisse/schulen/gymnasiale-oberstufen-und-gymnasien/engelsburg.php');
                      })
              ])),
          const Padding(
            padding: EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Text(
              'Standort',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: SizedBox(
              height: 250,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationButtonEnabled: false,
                liteModeEnabled: Platform.isAndroid,
                initialCameraPosition:
                    CameraPosition(target: _engelsburgPosition, zoom: 14.0),
                markers: {
                  Marker(
                    markerId: const MarkerId('0'),
                    position: _engelsburgPosition,
                    infoWindow: const InfoWindow(
                      title: 'Engelsburg-Gymnasium',
                      snippet: 'Richardweg 3, 34117 Kassel',
                    ),
                  ),
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
          ),
          ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Pforte anrufen'),
              onTap: () => url_launcher.launch('tel:+49561789670')),
          ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Sekretariat anrufen'),
              onTap: () => url_launcher.launch('tel:+495617896727')),
          ListTile(
              leading: const Icon(Icons.mail),
              title: const Text('E-Mail an das Sekretariat'),
              onTap: () =>
                  url_launcher.launch('mailto:sekretariat@engelsburg.smmp.de')),
        ],
      ),
    );
  }
}
