import 'dart:async';
import 'dart:io';

import 'package:engelsburg_app/src/about_school/about_school_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutSchoolView extends StatefulWidget {
  const AboutSchoolView({Key? key}) : super(key: key);

  static const routeName = '/about_school';

  @override
  State<AboutSchoolView> createState() => _AboutSchoolViewState();
}

class _AboutSchoolViewState extends State<AboutSchoolView> {
  final LatLng _engelsburgPosition = const LatLng(51.315228, 9.488160);
  final _mapController = Completer<GoogleMapController>();

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
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  children: [
                TextSpan(
                    text: 'kassel.de',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = AboutSchoolController.openKasselSource)
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
                  _mapController.complete(controller);
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
          const ListTile(
              leading: Icon(Icons.phone),
              title: Text('Pforte anrufen'),
              onTap: AboutSchoolController.callPforte),
          const ListTile(
              leading: Icon(Icons.phone),
              title: Text('Sekretariat anrufen'),
              onTap: AboutSchoolController.callSekretariat),
          const ListTile(
              leading: Icon(Icons.mail),
              title: Text('E-Mail an das Sekretariat'),
              onTap: AboutSchoolController.mailToSekretariat),
        ],
      ),
    );
  }
}
