import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

class CafeteriaPage extends StatefulWidget {
  @override
  _CafeteriaPageState createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {
  Future<List<String>> _getCafeteriaPlan() async {
    final cafeteriaDetailList = <String>[];
    final url =
        Uri.parse('https://engelsburg.smmp.de/leben-an-der-schule/cafeteria/');
    final res = await http.get(url);
    final document = parse(res.body);
    final cafeteria = document.querySelectorAll('div.entry-content > p');
    for (var cafeteriaDetail in cafeteria) {
      if (cafeteriaDetail.text.trim().isNotEmpty) {
        cafeteriaDetailList.add(
          HtmlUnescape()
              .convert(cafeteriaDetail.outerHtml.replaceAll('<br>', '\n'))
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .trim(),
        );
      }
    }
    return cafeteriaDetailList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getCafeteriaPlan(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Center(
                        child: Text(snapshot.data[0].toString(),
                            style: TextStyle(fontWeight: FontWeight.w700)))),
                ...snapshot.data.sublist(1).map((cafeteriaItem) {
                  // Erstes Element in der Liste überspringen,
                  // da das bereits angezeigt wird und join() verwenden,
                  // um unerwünschte Zeichen auszublenden und mit \n einen Absatz einzufügen.
                  return Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        cafeteriaItem.toString(),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
