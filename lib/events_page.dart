import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';

class EventsPage extends StatelessWidget {
  Future _getTermine() async {
    final List<String> _termineStringList = [];
    final Response termine =
        await Client().get('https://engelsburg.smmp.de/organisation/termine/');
    final dom.Document document = parse(termine.body);
    final List<dom.Element> termineList =
        document.querySelectorAll("div.entry-content > ul.navlist > li");
    for (var termin in termineList) {
      _termineStringList.add(termin.text);
    }
    return _termineStringList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Termine"),
      ),
      body: FutureBuilder(
        future: _getTermine(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () => _getTermine(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            snapshot.data[index].toString().substring(0, 10),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          snapshot.data[index].toString().substring(12),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                      ),
                    ],
                  );
                },
              ),
            );
          } else if (snapshot.hasData && snapshot.data.isEmpty) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.watch_later,
                      size: 64.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Aktuell keine Termine",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
