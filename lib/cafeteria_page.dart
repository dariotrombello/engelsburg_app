import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';

class CafeteriaPage extends StatefulWidget {
  @override
  _CafeteriaPageState createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {
  bool _isLoading = true;
  final List<String> _cafeteriaDetailList = [];

  @override
  void initState() {
    super.initState();
    getCafeteriaPlan();
  }

  Future getCafeteriaPlan() async {
    final Response content = await Client()
        .get('https://engelsburg.smmp.de/leben-an-der-schule/cafeteria/');
    final dom.Document document = parse(content.body);
    final List<dom.Element> cafeteria =
        document.querySelectorAll("div.entry-content > p");
    for (var cafeteriaDetail in cafeteria) {
      _cafeteriaDetailList.add(cafeteriaDetail.text);
      _cafeteriaDetailList.add("\n");
    }
    // CircularProgressIndicator wieder deaktivieren, wenn der Text geladen wurde.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Center(
                  child: Text(_cafeteriaDetailList[0],
                      style: TextStyle(fontWeight: FontWeight.w700))),
              // Erstes Element in der Liste überspringen,
              // da das bereits angezeigt wird und join() verwenden,
              // um unerwünschte Zeichen auszublenden und mit \n einen Absatz einzufügen.
              Text(
                _cafeteriaDetailList.sublist(1).join("\n"),
              )
            ],
          );
  }
}
