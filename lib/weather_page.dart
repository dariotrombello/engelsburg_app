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
                        height: 250,
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
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons.thermometer),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Gefühlte Temperatur',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data.current
                                                          .feelsLike
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
                                            ),
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
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Luftfeuchtigkeit',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data.current.humidity
                                                          .toString() +
                                                      '%',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color),
                                                ),
                                              ],
                                            ),
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
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Luftdruck',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data.current.pressure
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
                                            ),
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
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'UV-Index',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data.current.uvi
                                                      .round()
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Rotate(
                                            degree: snapshot
                                                .data.current.windDeg
                                                .toDouble(),
                                            child: Icon(WeatherIcons.wind),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Windgeschwindigkeit',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  (snapshot.data.current
                                                                  .windSpeed *
                                                              3.6)
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
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 24.0)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(WeatherIcons
                                              .thermometer_exterior),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Taupunkt',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  (snapshot.data.current
                                                              .dewPoint
                                                              .round())
                                                          .toString() +
                                                      ' ℃',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color),
                                                ),
                                              ],
                                            ),
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
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Bewölkung',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data.current.clouds
                                                          .toString() +
                                                      '%',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color),
                                                ),
                                              ],
                                            ),
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
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Sichtweite',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  (snapshot.data.current
                                                                  .visibility /
                                                              1000)
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
                                            ),
                                          )
                                        ],
                                      ),
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
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.hourly.length,
                            itemBuilder: (context, index) {
                              final hourly = snapshot.data.hourly[index];
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
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.umbrella),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
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
                                                          Text(daily.uvi
                                                              .round()
                                                              .toString()),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.rain),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Niederschlagswahrscheinlichkeit',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text((daily.pop * 100)
                                                                  .round()
                                                                  .toString() +
                                                              '%'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Rotate(
                                                      degree: daily.windDeg
                                                          .toDouble(),
                                                      child: Icon(
                                                          WeatherIcons.wind),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
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
                                                          Text((daily.windSpeed *
                                                                      3.6)
                                                                  .round()
                                                                  .toString() +
                                                              ' km/h'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.sunrise),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
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
                                                          Text(DateFormat(
                                                                  'HH:mm')
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      daily.sunrise *
                                                                          1000))),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.humidity),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Luftfeuchtigkeit',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(daily.humidity
                                                                  .toString() +
                                                              '%'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.cloud),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
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
                                                          Text((daily.clouds)
                                                                  .round()
                                                                  .toString() +
                                                              '%'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                        WeatherIcons.barometer),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
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
                                                          Text(daily.pressure
                                                                  .round()
                                                                  .toString() +
                                                              ' hPa'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(WeatherIcons.sunset),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.0)),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
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
                                                          Text(DateFormat(
                                                                  'HH:mm')
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      daily.sunset *
                                                                          1000))),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
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
}
