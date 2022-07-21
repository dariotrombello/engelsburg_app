import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/weather/models/hitzefrei_data.dart';
import 'package:engelsburg_app/src/weather/utils/weekday.dart';
import 'package:engelsburg_app/src/weather/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_icons/src/util/rotate.dart';

import '../error_card.dart';
import 'models/weatherdata.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with AutomaticKeepAliveClientMixin<WeatherView> {
  @override
  bool get wantKeepAlive => true;

  Color getHitzefreiColor(int code) {
    switch (code) {
      case 0:
        return Colors.lightBlue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String getHitzefreiText(HitzefreiData data) {
    final day = data.isToday ? 'heute' : 'morgen';

    switch (data.code) {
      case 0:
        return 'Es ist sehr unwahrscheinlich, dass es $day Hitzefrei gibt';
      case 1:
        return 'Es ist eher unwahrscheinlich, dass es $day Hitzefrei gibt';
      case 2:
        return 'Es ist wahrscheinlich, dass es $day Hitzefrei gibt';
      default:
        return 'Es ist sehr wahrscheinlich, dass es $day Hitzefrei gibt';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<OpenWeatherMap>(
      future: WeatherService.loadWeather(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final hitzefreiData =
              WeatherService.getHitzefreiProbability(data.hourly);

          return ListView(
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
                          '${data.current.temp.round()}°',
                          style: const TextStyle(
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
                          'Engelsburg Gymnasium Kassel – ${data.current.weather.first.description}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
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
              if (hitzefreiData != null)
                Card(
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  color: getHitzefreiColor(hitzefreiData.code),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      getHitzefreiText(hitzefreiData),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Einzelheiten',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    const Text('Aktuelles Wetter'),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Column(
                                children: <Widget>[
                                  _currentWeatherTile(
                                      leading:
                                          const Icon(WeatherIcons.thermometer),
                                      title: 'Gefühlte Temperatur',
                                      subtitle:
                                          '${data.current.feelsLike.round()} ℃'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 24.0)),
                                  _currentWeatherTile(
                                      leading:
                                          const Icon(WeatherIcons.humidity),
                                      title: 'Luftfeuchtigkeit',
                                      subtitle: '${data.current.humidity} %'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 24.0)),
                                  _currentWeatherTile(
                                      leading:
                                          const Icon(WeatherIcons.barometer),
                                      title: 'Luftdruck',
                                      subtitle:
                                          '${data.current.pressure.round()} hPa'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 24.0)),
                                  _currentWeatherTile(
                                      leading:
                                          const Icon(WeatherIcons.umbrella),
                                      title: 'UV-Index',
                                      subtitle:
                                          data.current.uvi.round().toString()),
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
                                        degree: data.current.windDeg.toDouble(),
                                        child: const Icon(WeatherIcons.wind),
                                      ),
                                      title: 'Windgeschwindigkeit',
                                      subtitle:
                                          '${(data.current.windSpeed * 3.6).round()} km/h'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 24.0)),
                                  _currentWeatherTile(
                                      leading: const Icon(
                                          WeatherIcons.thermometer_exterior),
                                      title: 'Taupunkt',
                                      subtitle:
                                          '${data.current.dewPoint.round()} ℃'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 24.0)),
                                  _currentWeatherTile(
                                      leading: const Icon(WeatherIcons.cloud),
                                      title: 'Bewölkung',
                                      subtitle: '${data.current.clouds} %'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 24.0)),
                                  _currentWeatherTile(
                                      leading: const Icon(WeatherIcons.fog),
                                      title: 'Sichtweite',
                                      subtitle:
                                          '${(data.current.visibility / 1000).round()} km'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 32.0)),
                    const Text(
                      'Wettervorhersage',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    const Text('24 Stunden'),
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: data.hourly.map((hourly) {
                          final hour = DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  hourly.dt * 1000));
                          final iconUrl =
                              'https://openweathermap.org/img/wn/${hourly.weather.first.icon}@4x.png';
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('${hourly.temp.round()} ℃'),
                                    CachedNetworkImage(
                                      height: 48.0,
                                      width: 48.0,
                                      imageUrl: iconUrl,
                                      placeholder: (context, url) =>
                                          Container(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const Padding(
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
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0),
                    ),
                    const Text(
                      'Wettervorhersage',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    const Text('7 Tage'),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    ...data.daily.map(
                      (daily) {
                        final iconUrl =
                            'https://openweathermap.org/img/wn/${daily.weather.first.icon}@4x.png';

                        return Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: CachedNetworkImage(
                              height: 48.0,
                              width: 48.0,
                              imageUrl: iconUrl,
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(WeekDay.toGerman(
                                DateTime.fromMillisecondsSinceEpoch(
                                        daily.dt * 1000)
                                    .weekday)),
                            subtitle: Text(
                                '${daily.temp.night.round()} ℃ / ${daily.temp.day.round()} ℃'),
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
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
                                            leading: const Icon(
                                                WeatherIcons.umbrella),
                                            title: 'UV-Index',
                                            description:
                                                daily.uvi.round().toString()),
                                        _dailyWeatherCard(
                                          leading:
                                              const Icon(WeatherIcons.rain),
                                          title:
                                              'Niederschlagswahrscheinlichkeit',
                                          description:
                                              '${(daily.pop * 100).round()} %',
                                        ),
                                        _dailyWeatherCard(
                                            leading: Rotate(
                                              degree: daily.windDeg.toDouble(),
                                              child:
                                                  const Icon(WeatherIcons.wind),
                                            ),
                                            title: 'Windgeschwindigkeit',
                                            description:
                                                '${(daily.windSpeed * 3.6).round()} km/h'),
                                        _dailyWeatherCard(
                                            leading: const Icon(
                                                WeatherIcons.sunrise),
                                            title: 'Sonnenaufgang',
                                            description: DateFormat('HH:mm')
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        daily.sunrise * 1000))),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        _dailyWeatherCard(
                                            leading: const Icon(
                                                WeatherIcons.humidity),
                                            title: 'Luftfeuchtigkeit',
                                            description: '${daily.humidity} %'),
                                        _dailyWeatherCard(
                                            leading:
                                                const Icon(WeatherIcons.cloud),
                                            title: 'Bewölkung',
                                            description:
                                                '${(daily.clouds).round()} %'),
                                        _dailyWeatherCard(
                                            leading: const Icon(
                                                WeatherIcons.barometer),
                                            title: 'Luftdruck',
                                            description:
                                                '${daily.pressure.round()} hPa'),
                                        _dailyWeatherCard(
                                            leading:
                                                const Icon(WeatherIcons.sunset),
                                            title: 'Sonnenuntergang',
                                            description: DateFormat('HH:mm')
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        daily.sunset * 1000))),
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
                    const Text(
                      '\n\nWetterdaten von OpenWeatherMap',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const ErrorCard();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _currentWeatherTile({
    required Widget leading,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        leading,
        const Padding(
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
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(subtitle),
            ],
          ),
        )
      ],
    );
  }

  Widget _dailyWeatherCard({
    required Widget leading,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            leading,
            const Padding(padding: EdgeInsets.only(left: 16.0)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
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
