import 'package:engelsburg_app/main.dart';
import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';

class AGListPage extends StatefulWidget {
  @override
  _AGListPageState createState() => _AGListPageState();
}

class _AGListPageState extends State<AGListPage> {
  bool _isLoading = true;
  final List<String> agColumnList = [];

  @override
  void initState() {
    super.initState();
    getAGList();
  }

  Future getAGList() async {
    final Response content = await Client().get(Uri.encodeFull(
        'https://engelsburg.smmp.de/leben-an-der-schule/arbeitsgemeinschaften/'));
    final dom.Document document = parse(content.body);
    final List<dom.Element> ags = document.querySelectorAll("tr > td.column-1");
    for (var singleAG in ags) {
      agColumnList.add(singleAG.text);
    }
    agColumnList.removeAt(agColumnList.length - 1);
    // CircularProgressIndicator wieder deaktivieren, wenn der Text geladen wurde.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        text: "AGs",
        withBackButton: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: agColumnList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(agColumnList[index]),
                    ),
                    index == agColumnList.length - 1 ? Container() : Divider()
                  ],
                );
              },
            ),
    );
  }
}
