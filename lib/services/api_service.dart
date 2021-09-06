import 'dart:convert';

import 'package:engelsburg_app/constants/api_constants.dart';
import 'package:engelsburg_app/models/engelsburg_api/articles.dart';
import 'package:engelsburg_app/models/engelsburg_api/cafeteria.dart';
import 'package:engelsburg_app/models/engelsburg_api/events.dart';
import 'package:engelsburg_app/models/engelsburg_api/solar_panel.dart';
import 'package:engelsburg_app/services/shared_prefs.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> cachedGet(
      {required Uri uri,
      String? cacheKey,
      Map<String, String>? headers}) async {
    String? body;
    try {
      final res = await http.get(uri, headers: headers);
      if (!res.statusCode.toString().startsWith('2')) {
        throw Exception('Interner Server Error!');
      } else if (res.body.isEmpty) {
        throw Exception('Empty response!');
      }
      body = res.body;
      if (cacheKey != null) {
        await SharedPrefs.instance!.setString(cacheKey, body);
      }
    } catch (_) {
      if (cacheKey != null) {
        body = SharedPrefs.instance!.getString(cacheKey);
      }
    }
    if (body == null) {
      throw Exception('Bitte überprüfe deine Internetverbindung!');
    }
    return body;
  }

  static Future<Articles> getArticles() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiArticlesUrl);
    final body = await cachedGet(
        uri: uri,
        cacheKey: 'articles_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
    final json = jsonDecode(body);
    final articles = Articles.fromJson(json);
    return articles;
  }

  static Future<Events> getEvents() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiEventsUrl);
    final body = await cachedGet(
        uri: uri,
        cacheKey: 'events_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
    final json = jsonDecode(body);
    final events = Events.fromJson(json);
    return events;
  }

  static Future<Cafeteria> getCafeteria() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiCafeteriaUrl);
    final body = await cachedGet(
        uri: uri,
        cacheKey: 'cafeteria_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
    final json = jsonDecode(body);
    final cafeteria = Cafeteria.fromJson(json);
    return cafeteria;
  }

  static Future<SolarPanel> getSolarSystemData() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSolarSystemUrl);
    final body = await cachedGet(
        uri: uri,
        cacheKey: 'solar_panel_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
    final json = jsonDecode(body);
    final solarPanel = SolarPanel.fromJson(json);
    return solarPanel;
  }

}
