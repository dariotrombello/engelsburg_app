import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_icons/src/util/rotate.dart';

import 'model/weatherdata.dart';

class WeatherPage extends StatelessWidget {
  Future _loadWeather() async {
    // DarkSky wurde durch Apple aufgekauft
    // und daher wird die API 2021 eingestellt
    // TODO: DarkSky durch anderen Wetterdatenanbieter ersetzen
    final jsonAddress = await Client().get(Uri.encodeFull(
        'https://api.darksky.net/forecast/<API_KEY>/51.315229,9.48816?lang=de&units=ca&exclude=minutely,flags'));
    final jsonResponse = json.decode(jsonAddress.body);
    return DarkSky.fromJson(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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

    Icon weatherIcon(String iconString) {
      switch (iconString) {
        case 'clear-day':
          return Icon(WeatherIcons.day_sunny);
        case 'clear-night':
          return Icon(WeatherIcons.night_clear);
        case 'rain':
          return Icon(WeatherIcons.rain);
        case 'snow':
          return Icon(WeatherIcons.snow);
        case 'sleet':
          return Icon(WeatherIcons.sleet);
        case 'wind':
          return Icon(WeatherIcons.strong_wind);
        case 'fog':
          return Icon(WeatherIcons.fog);
        case 'cloudy':
          return Icon(WeatherIcons.cloudy);
        case 'partly-cloudy-day':
          return Icon(WeatherIcons.day_cloudy);
        case 'partly-cloudy-night':
          return Icon(WeatherIcons.night_alt_partly_cloudy);
        case 'hail':
          return Icon(WeatherIcons.hail);
        case 'thunderstorm':
          return Icon(WeatherIcons.thunderstorm);
        case 'tornado':
          return Icon(WeatherIcons.tornado);
        default:
          return Icon(WeatherIcons.na);
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wetter'),
      ),
      body: FutureBuilder(
        future: _loadWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () => _loadWeather(),
              child: ListView(
                children: <Widget>[
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/weather-background.jpg',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 25.0,
                        top: 25.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data.currently.temperature
                                      .round()
                                      .toString() +
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
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: <Widget>[
                                Icon(Icons.location_on, color: Colors.white),
                                Container(
                                  padding: EdgeInsets.only(left: 8.0),
                                  width: width * 0.6,
                                  child: Text(
                                    'Engelsburg Gymnasium Kassel' ' – ' +
                                        snapshot.data.currently.summary
                                            .toString(),
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.all(22.0),
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.thermometer),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Gefühlte Temperatur',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data.currently
                                                        .apparentTemperature
                                                        .round()
                                                        .toString() +
                                                    ' ℃',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.humidity),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Luftfeuchtigkeit',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                (snapshot.data.currently
                                                                .humidity *
                                                            100)
                                                        .round()
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.barometer),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Luftdruck',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data.currently.pressure
                                                        .round()
                                                        .toString() +
                                                    ' hPa',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.umbrella),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'UV-Index',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data.currently.uvIndex
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Rotate(
                                            degree: snapshot
                                                .data.currently.windBearing
                                                .toDouble(),
                                            child: Icon(WeatherIcons.wind),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Windgeschwindigkeit',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data.currently
                                                        .windSpeed
                                                        .round()
                                                        .toString() +
                                                    ' km/h',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.rain),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Niederschlagswahrscheinlichkeit',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                (snapshot.data.currently
                                                                .precipProbability *
                                                            100)
                                                        .round()
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.cloud),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Bewölkung',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                (snapshot.data.currently
                                                                .cloudCover *
                                                            100)
                                                        .round()
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.fog),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  'Sichtweite',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                (snapshot.data.currently
                                                            .visibility)
                                                        .round()
                                                        .toString() +
                                                    ' km',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                            ),
                            SizedBox(
                              height: 90,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.hourly.data.length,
                                itemBuilder: (context, index) {
                                  final hour = DateFormat('HH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data.hourly.data[index]
                                                  .time *
                                              1000));

                                  return Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 0.0, 16.0, 16.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(snapshot.data.hourly
                                                    .data[index].temperature
                                                    .round()
                                                    .toString() +
                                                ' ℃'),
                                            weatherIcon(snapshot
                                                .data.hourly.data[index].icon),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 16.0),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(hour.toString())
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color),
                            ),
                            Padding(padding: EdgeInsets.only(top: 16.0)),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.daily.data.length,
                              itemBuilder: (context, index) {
                                final date = DateFormat('dd.MM.y')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data.daily.data[index].time *
                                            1000))
                                    .toString();

                                return ExpansionTile(
                                  leading: weatherIcon(
                                      snapshot.data.daily.data[index].icon),
                                  title: Text(_localizedWeekday(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  snapshot.data.daily
                                                          .data[index].time *
                                                      1000)
                                              .weekday) +
                                      ', ' +
                                      date),
                                  subtitle: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                                child: BoxedIcon(
                                              WeatherIcons.rain,
                                              size: 16.0,
                                            )),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 2.0),
                                                child: Text((snapshot
                                                                .data
                                                                .daily
                                                                .data[index]
                                                                .precipProbability *
                                                            100)
                                                        .round()
                                                        .toString() +
                                                    '%'),
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: VerticalDivider(),
                                            ),
                                            WidgetSpan(
                                                child: BoxedIcon(
                                              WeatherIcons.thermometer,
                                              size: 16.0,
                                            )),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 2.0),
                                                child: Text((snapshot
                                                            .data
                                                            .daily
                                                            .data[index]
                                                            .temperatureMin)
                                                        .round()
                                                        .toString() +
                                                    ' ℃' +
                                                    ' | ' +
                                                    (snapshot
                                                            .data
                                                            .daily
                                                            .data[index]
                                                            .temperatureMax)
                                                        .round()
                                                        .toString() +
                                                    ' ℃'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.umbrella),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: width * 0.2,
                                                          child: Text(
                                                            'UV-Index',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(snapshot.data.daily
                                                            .data[index].uvIndex
                                                            .toString()),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Rotate(
                                                      degree: snapshot
                                                          .data
                                                          .daily
                                                          .data[index]
                                                          .windBearing
                                                          .toDouble(),
                                                      child: Icon(
                                                          WeatherIcons.wind),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: width * 0.2,
                                                          child: Text(
                                                            'Windgeschwindigkeit',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(snapshot
                                                                .data
                                                                .daily
                                                                .data[index]
                                                                .windSpeed
                                                                .round()
                                                                .toString() +
                                                            ' km/h'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.sunrise),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: width * 0.2,
                                                          child: Text(
                                                            'Sonnenaufgang',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(DateFormat('HH:mm')
                                                            .format(DateTime
                                                                .fromMillisecondsSinceEpoch(snapshot
                                                                        .data
                                                                        .daily
                                                                        .data[
                                                                            index]
                                                                        .sunriseTime *
                                                                    1000))),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.cloud),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: width * 0.2,
                                                          child: Text(
                                                            'Bewölkung',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text((snapshot
                                                                        .data
                                                                        .daily
                                                                        .data[
                                                                            index]
                                                                        .cloudCover *
                                                                    100)
                                                                .round()
                                                                .toString() +
                                                            '%'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                        WeatherIcons.barometer),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: width * 0.2,
                                                          child: Text(
                                                            'Luftdruck',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(snapshot
                                                                .data
                                                                .daily
                                                                .data[index]
                                                                .pressure
                                                                .round()
                                                                .toString() +
                                                            ' hPa'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.sunset),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: width * 0.2,
                                                          child: Text(
                                                            'Sonnenuntergang',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(DateFormat('HH:mm')
                                                            .format(DateTime
                                                                .fromMillisecondsSinceEpoch(snapshot
                                                                        .data
                                                                        .daily
                                                                        .data[
                                                                            index]
                                                                        .sunsetTime *
                                                                    1000))),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            Text(
                              '\nWetterdaten von Dark Sky',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
