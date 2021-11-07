import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'error_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Future<List<String>> _getEvents() async {
    final eventStringList = <String>[];
    final url = Uri.parse('https://engelsburg.smmp.de/organisation/termine/');
    final res = await http.get(url);
    if (!res.statusCode.toString().startsWith('2')) {
      throw 'Error while trying to load the page';
    }
    final document = parse(res.body);
    final eventList =
        document.querySelectorAll('div.entry-content > ul.navlist > li');
    for (var event in eventList) {
      eventStringList.add(event.text);
    }
    return eventStringList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Termine'),
      ),
      body: FutureBuilder(
        future: _getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(snapshot.data[index].toString().substring(0, 10)),
                    subtitle:
                        Text(snapshot.data[index].toString().substring(12)),
                  );
                },
              ),
            );
          } else if (snapshot.hasData && snapshot.data.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Icon(
                      Icons.watch_later,
                      size: 64.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Aktuell keine Termine',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const ErrorCard();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
