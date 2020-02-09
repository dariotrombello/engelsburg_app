import 'package:engelsburg_app/main.dart';
import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';

class AGListPage extends StatelessWidget {
  Future _getAGList() async {
    final List<String> agList = [];
    final List<String> teacherList = [];
    final List<String> dateList = [];
    final List<String> locationList = [];

    final Response content = await Client().get(Uri.encodeFull(
        'https://engelsburg.smmp.de/leben-an-der-schule/arbeitsgemeinschaften/'));
    final dom.Document document = parse(content.body);
    final List<dom.Element> agColumnList =
        document.querySelectorAll("tr > td.column-1");
    final List<dom.Element> teacherColumnList =
        document.querySelectorAll("tr > td.column-2");
    final List<dom.Element> dateColumnList =
        document.querySelectorAll("tr > td.column-3");
    final List<dom.Element> locationColumnList =
        document.querySelectorAll("tr > td.column-4");

    for (int i = 0; i < agColumnList.length; i++) {
      agList.add(agColumnList[i].text.trim());
      teacherList.add(teacherColumnList[i].text.trim());
      dateList.add(dateColumnList[i].text.trim());
      locationList.add(locationColumnList[i].text.trim());
    }
    agList.removeAt(agList.length - 1);
    teacherList.removeAt(agList.length);
    dateList.removeAt(agList.length);
    locationList.removeAt(agList.length);
    return [agList, teacherList, dateList, locationList];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        title: "AGs",
        withBackButton: true,
      ),
      body: FutureBuilder(
        future: _getAGList(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return RefreshIndicator(
              onRefresh: () => _getAGList(),
              child: ListView.builder(
                itemCount: snapshot.data[0].length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                snapshot.data[0][index],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(padding: EdgeInsets.only(top: 12.0)),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.person),
                                  Padding(padding: EdgeInsets.only(right: 4.0)),
                                  Flexible(
                                      child: Text("Leitung: " +
                                          snapshot.data[1][index]))
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 4.0)),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time),
                                  Padding(padding: EdgeInsets.only(right: 4.0)),
                                  Flexible(
                                      child: Text(
                                          "Zeit: " + snapshot.data[2][index]))
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 4.0)),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  Padding(padding: EdgeInsets.only(right: 4.0)),
                                  Flexible(
                                      child: Text(
                                          "Ort: " + snapshot.data[3][index]))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
