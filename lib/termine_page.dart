import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';

import 'main.dart';

class TerminePage extends StatefulWidget {
  @override
  _TerminePageState createState() => _TerminePageState();
}

class _TerminePageState extends State<TerminePage> {
  bool _isLoading = true;
  final List<String> _termineStringList = [];

  void initState() {
    super.initState();
    getTermine();
  }

  Future getTermine() async {
    final Response termine =
        await Client().get('https://engelsburg.smmp.de/organisation/termine/');
    final dom.Document document = parse(termine.body);
    final List<dom.Element> termineList =
        document.querySelectorAll("div.entry-content > ul.navlist > li");
    for (var termin in termineList) {
      _termineStringList.add(termin.text);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        text: 'Termine',
        withBackButton: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _termineStringList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _termineStringList[index].substring(0, 10),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        _termineStringList[index].substring(12),
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
  }
}
