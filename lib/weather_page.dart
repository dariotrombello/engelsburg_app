import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/error_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_icons/src/util/rotate.dart';

import 'models/weatherdata.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<OpenWeatherMap> _loadWeather() async {
    // openweathermap api key
    final apiKey = '<API_KEY>';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=51.315229&lon=9.48816&appid=$apiKey&lang=de&units=metric&exclude=alerts,minutely');
    final res = await http.get(url);
    if (!res.statusCode.toString().startsWith('2')) {
      throw 'Error while trying to load the page';
    }
    final json = jsonDecode(res.body);
    return OpenWeatherMap.fromJson(json);
  }

  String _localizedWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Montag';
      case 2:
        return 'Dienstag';
      case 3:
        return 'Mittwoch';
      case 4:
        return 'Donnerstag';
      case 5:
        return 'Freitag';
      case 6:
        return 'Samstag';
      case 7:
        return 'Sonntag';
      default:
        return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wetter'),
      ),
      body: FutureBuilder<OpenWeatherMap>(
        future: _loadWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/weather-background.jpg',
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        left: 25.0,
                        top: 25.0,
                        right: 25.0,
                        bottom: 25.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data.current.temp.round().toString() +
                                  '°',
                              style: TextStyle(
                                fontSize: 72.0,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                      color: Colors.black54)
                                ],
                              ),
                            ),
                            Text(
                              'Engelsburg Gymnasium Kassel – ' +
                                  snapshot
                                      .data.current.weather.first.description
                                      .toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontSize: 16.0,
                                shadows: [
                                  Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                      color: Colors.black54)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Einzelheiten',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Aktuelles Wetter',
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Column(
                                    children: <Widget>[
                                      _currentWeatherTile(
                                          leading:
                                              Icon(WeatherIcons.thermometer),
                                          title: 'Gefühlte Temperatur',
                                          subtitle: snapshot
                                                  .data.current.feelsLike
                                                  .round()
                                                  .toString() +
                                              ' ℃'),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      _currentWeatherTile(
                                          leading: Icon(WeatherIcons.humidity),
                                          title: 'Luftfeuchtigkeit',
                                          subtitle: snapshot
                                                  .data.current.humidity
                                                  .toString() +
                                              ' %'),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      _currentWeatherTile(
                                          leading: Icon(WeatherIcons.barometer),
                                          title: 'Luftdruck',
                                          subtitle: snapshot
                                                  .data.current.pressure
                                                  .round()
                                                  .toString() +
                                              ' hPa'),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      _currentWeatherTile(
                                          leading: Icon(WeatherIcons.umbrella),
                                          title: 'UV-Index',
                                          subtitle: snapshot.data.current.uvi
                                              .round()
                                              .toString()),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Column(
                                    children: <Widget>[
                                      _currentWeatherTile(
                                          leading: Rotate(
                                            degree: snapshot
                                                .data.current.windDeg
                                                .toDouble(),
                                            child: Icon(WeatherIcons.wind),
                                          ),
                                          title: 'Windgeschwindigkeit',
                                          subtitle:
                                              (snapshot.data.current.windSpeed *
                                                          3.6)
                                                      .round()
                                                      .toString() +
                                                  ' km/h'),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      _currentWeatherTile(
                                          leading: Icon(WeatherIcons
                                              .thermometer_exterior),
                                          title: 'Taupunkt',
                                          subtitle: (snapshot
                                                      .data.current.dewPoint
                                                      .round())
                                                  .toString() +
                                              ' ℃'),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      _currentWeatherTile(
                                          leading: Icon(WeatherIcons.cloud),
                                          title: 'Bewölkung',
                                          subtitle: snapshot.data.current.clouds
                                                  .toString() +
                                              ' %'),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      _currentWeatherTile(
                                          leading: Icon(WeatherIcons.fog),
                                          title: 'Sichtweite',
                                          subtitle: (snapshot.data.current
                                                          .visibility /
                                                      1000)
                                                  .round()
                                                  .toString() +
                                              ' km'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 32.0)),
                        Text(
                          'Wettervorhersage',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '24 Stunden',
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.0),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: snapshot.data.hourly.map((hourly) {
                              final hour = DateFormat('HH:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      hourly.dt * 1000));
                              final iconUrl =
                                  'https://openweathermap.org/img/wn/${hourly.weather.first.icon}@4x.png';
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(hourly.temp.round().toString() +
                                            ' ℃'),
                                        CachedNetworkImage(
                                          height: 48.0,
                                          width: 48.0,
                                          imageUrl: iconUrl,
                                          placeholder: (context, url) =>
                                              Container(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16.0),
                                        ),
                                        Text(hour.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.0),
                        ),
                        Text(
                          'Wettervorhersage',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '7 Tage',
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        Padding(padding: EdgeInsets.only(top: 16.0)),
                        ...snapshot.data.daily.map(
                          (daily) {
                            final iconUrl =
                                'https://openweathermap.org/img/wn/${daily.weather.first.icon}@4x.png';

                            return Theme(
                              data: Theme.of(context).copyWith(
                                  accentColor: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                  dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                leading: CachedNetworkImage(
                                  height: 48.0,
                                  width: 48.0,
                                  imageUrl: iconUrl,
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                title: Text(_localizedWeekday(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            daily.dt * 1000)
                                        .weekday)),
                                subtitle: Text(
                                    daily.temp.night.round().toString() +
                                        ' ℃ / ' +
                                        daily.temp.day.round().toString() +
                                        ' ℃'),
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: 16.0, left: 4.0, top: 8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      daily.weather.first.description,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            _dailyWeatherCard(
                                                leading:
                                                    Icon(WeatherIcons.umbrella),
                                                title: 'UV-Index',
                                                description: daily.uvi
                                                    .round()
                                                    .toString()),
                                            _dailyWeatherCard(
                                              leading: Icon(WeatherIcons.rain),
                                              title:
                                                  'Niederschlagswahrscheinlichkeit',
                                              description: (daily.pop * 100)
                                                      .round()
                                                      .toString() +
                                                  ' %',
                                            ),
                                            _dailyWeatherCard(
                                                leading: Rotate(
                                                  degree:
                                                      daily.windDeg.toDouble(),
                                                  child:
                                                      Icon(WeatherIcons.wind),
                                                ),
                                                title: 'Windgeschwindigkeit',
                                                description:
                                                    (daily.windSpeed * 3.6)
                                                            .round()
                                                            .toString() +
                                                        ' km/h'),
                                            _dailyWeatherCard(
                                                leading:
                                                    Icon(WeatherIcons.sunrise),
                                                title: 'Sonnenaufgang',
                                                description: DateFormat('HH:mm')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            daily.sunrise *
                                                                1000))),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            _dailyWeatherCard(
                                                leading:
                                                    Icon(WeatherIcons.humidity),
                                                title: 'Luftfeuchtigkeit',
                                                description:
                                                    daily.humidity.toString() +
                                                        ' %'),
                                            _dailyWeatherCard(
                                                leading:
                                                    Icon(WeatherIcons.cloud),
                                                title: 'Bewölkung',
                                                description: (daily.clouds)
                                                        .round()
                                                        .toString() +
                                                    ' %'),
                                            _dailyWeatherCard(
                                                leading: Icon(
                                                    WeatherIcons.barometer),
                                                title: 'Luftdruck',
                                                description: daily.pressure
                                                        .round()
                                                        .toString() +
                                                    ' hPa'),
                                            _dailyWeatherCard(
                                                leading:
                                                    Icon(WeatherIcons.sunset),
                                                title: 'Sonnenuntergang',
                                                description: DateFormat('HH:mm')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            daily.sunset *
                                                                1000))),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Text(
                          '\n\nWetterdaten von OpenWeatherMap',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorCard();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _currentWeatherTile({
    @required Widget leading,
    @required String title,
    @required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        leading,
        Padding(
          padding: EdgeInsets.only(left: 16.0),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style:
                    TextStyle(color: Theme.of(context).textTheme.caption.color),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _dailyWeatherCard({
    @required Widget leading,
    @required String title,
    @required String description,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            leading,
            Padding(padding: EdgeInsets.only(left: 16.0)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(description),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
