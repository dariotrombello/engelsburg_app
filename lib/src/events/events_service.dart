import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class EventsService {
  static Future<List<String>> getEvents() async {
    final eventStringList = <String>[];
    final url = Uri.parse('https://engelsburg.smmp.de/wp-json/wp/v2/pages/318');
    final res = await http.get(url);
    if (!res.statusCode.toString().startsWith('2')) {
      throw 'Error while trying to load the page';
    }
    final document = parse(json.decode(res.body)['content']['rendered']);
    final eventList = document.querySelectorAll('ul.navlist > li:not([class])');
    for (var event in eventList) {
      eventStringList.add(event.text);
    }
    return eventStringList;
  }
}
