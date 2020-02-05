import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'backend/weatherdata.dart';
import 'main.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Future loadWeather() async {
    final Response jsonAddress = await Client().get(Uri.encodeFull(
        "https://api.openweathermap.org/data/2.5/weather/?appid=207d22dfb93ecdec162c7a496c3592f4&units=metric&lat=51.315334&lon=9.488239"));
    final jsonResponse = json.decode(jsonAddress.body);
    return WeatherData.fromJson(jsonResponse);
  }

  weekDay() {
    switch (DateTime.now().weekday) {
      case 1:
        return "MONTAG";
      case 2:
        return "DIENSTAG";
      case 3:
        return "MITTWOCH";
      case 4:
        return "DONNERSTAG";
      case 5:
        return "FREITAG";
      case 6:
        return "SAMSTAG";
      case 7:
        return "SONNTAG";
    }
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Einmal pro Minute aktualisieren
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final _time = DateFormat('HH:mm').format(_dateTime);

    return Scaffold(
      appBar: EngelsburgAppBar(
        text: "Wetter",
        withBackButton: true,
      ),
      body: FutureBuilder(
        future: loadWeather(),
        builder: (context, snapshot) {
          weather() {
            switch (snapshot.data.weather[0].main) {
              case "Thunderstorm":
                return "Gewitter";
              case "Drizzle":
                return "Nieselregen";
              case "Rain":
                return "Regen";
              case "Snow":
                return "Schnee";
              case "Mist":
                return "Nebel";
              case "Smoke":
                return "Rauch";
              case "Haze":
                return "Dunst";
              case "Dust":
                return "Staub";
              case "Fog":
                return "Nebel";
              case "Sand":
                return "Sand";
              case "Ash":
                return "Asche";
              case "Squall":
                return "Böen";
              case "Tornado":
                return "Tornado";
              case "Clear":
                return "Klar";
              case "Clouds":
                return "Bewölkt";
              default:
                return snapshot.data.weather[0].main;
            }
          }

          if (snapshot.hasData)
            return RefreshIndicator(
              // Beim Wischen von oben nach unten, Wetter aktualisieren
              onRefresh: () => loadWeather(),
              child: ListView(
                children: <Widget>[
                  ClipPath(
                    clipper: ImageClip(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          image: AssetImage(
                            "assets/weather-background.jpg",
                          ),
                        ),
                      ),
                      height: 360,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Text(
                                _time,
                                style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                weekDay(),
                                style: TextStyle(
                                    letterSpacing: 5,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 48.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                    ),
                                    // Als dauerhaften Standort das Engelsburg Gymnasium angeben
                                    Text(
                                      "Engelsburg Gymnasium Kassel",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Das richtige Wetterschaubild laden
                            // (icon ID wird von der JSON API abgerufen und in die Bild-URL miteingefügt)
                            Image.network(
                              "http://openweathermap.org/img/wn/" +
                                  snapshot.data.weather[0].icon +
                                  "@2x.png",
                            ),
                            Flexible(
                              child: AutoSizeText(
                                weather(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 64),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                snapshot.data.mainData.temp.round().toString() +
                                    "°",
                                style: TextStyle(
                                    fontSize: 128, fontWeight: FontWeight.w200),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(
                              width: 78,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    snapshot.data.mainData.tempMax
                                            .round()
                                            .toString() +
                                        " °C",
                                    style: TextStyle(fontSize: 32),
                                  ),
                                  Divider(),
                                  Text(
                                    snapshot.data.mainData.tempMin
                                            .round()
                                            .toString() +
                                        " °C",
                                    style: TextStyle(fontSize: 32),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ImageClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path _path = Path();
    _path.lineTo(0.0, size.height - 20);

    final Offset _firstControlPoint = Offset(size.width / 4, size.height);
    final Offset _firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    _path.quadraticBezierTo(_firstControlPoint.dx, _firstControlPoint.dy,
        _firstEndPoint.dx, _firstEndPoint.dy);

    final Offset _secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    final Offset _secondEndPoint = Offset(size.width, size.height - 40);
    _path.quadraticBezierTo(_secondControlPoint.dx, _secondControlPoint.dy,
        _secondEndPoint.dx, _secondEndPoint.dy);

    _path.lineTo(size.width, size.height - 40);
    _path.lineTo(size.width, 0.0);
    _path.close();

    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
