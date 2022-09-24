import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:engelsburg_app/src/weather/models/hitzefrei_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'models/hitzefrei_data.dart';
import 'models/weatherdata.dart';

class WeatherService {
  static Future<OpenWeatherMap> loadWeather() async {
    // openweathermap api key
    const apiKey = '[PASTE_YOUR_API_KEY]';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=51.315229&lon=9.48816&appid=$apiKey&lang=de&units=metric&exclude=alerts,minutely');
    final res = await http.get(url);
    if (!res.statusCode.toString().startsWith('2')) {
      throw 'Error while trying to load the page';
    }
    final json = jsonDecode(res.body);
    return OpenWeatherMap.fromJson(json);
  }

  static HitzefreiData? getHitzefreiProbability(List<Hourly> hourly) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final hitzefreiWeather = hourly.firstWhereOrNull((element) {
      final hitzefreiDate =
          DateTime.fromMillisecondsSinceEpoch(element.dt * 1000);
      return DateFormat('HH:mm').format(hitzefreiDate) == '11:00';
    });
    if (hitzefreiWeather == null) return null;

    final hitzefreiDate =
        DateTime.fromMillisecondsSinceEpoch(hitzefreiWeather.dt * 1000);
    final hitzefreiDateWithoutHour =
        DateTime(hitzefreiDate.year, hitzefreiDate.month, hitzefreiDate.day);

    final isToday = hitzefreiDateWithoutHour == today;
    final day = isToday ? 'heute' : 'morgen';

    final temp = hitzefreiWeather.temp;

    if (temp < 22) {
      return null;
    } else if (temp < 23) {
      return HitzefreiData(
          text: 'Es ist sehr unwahrscheinlich, dass es $day Hitzefrei gibt',
          color: Colors.lightBlue,
          isToday: isToday);
    } else if (temp < 24) {
      return HitzefreiData(
          text: 'Es ist eher unwahrscheinlich, dass es $day Hitzefrei gibt',
          color: Colors.green,
          isToday: isToday);
    } else if (temp >= 24 && temp < 26) {
      return HitzefreiData(
          text: 'Es ist wahrscheinlich, dass es $day Hitzefrei gibt',
          color: Colors.orange,
          isToday: isToday);
    } else {
      return HitzefreiData(
          text: 'Es ist sehr wahrscheinlich, dass es $day Hitzefrei gibt',
          color: Colors.red,
          isToday: isToday);
    }
  }
}
