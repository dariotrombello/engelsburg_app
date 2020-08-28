import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';

class CafeteriaPage extends StatefulWidget {
  @override
  _CafeteriaPageState createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {
  Future _getCafeteriaPlan;

  @override
  void initState() {
    super.initState();
    _getCafeteriaPlan = _getCafeteriaPlanInit();
  }

  Future<List<String>> _getCafeteriaPlanInit() async {
    final List<String> _cafeteriaDetailList = [];
    final Response content = await Client()
        .get('https://engelsburg.smmp.de/leben-an-der-schule/cafeteria/');
    final dom.Document document = parse(content.body);
    final List<dom.Element> cafeteria =
        document.querySelectorAll("div.entry-content > p");
    for (var cafeteriaDetail in cafeteria) {
      if (cafeteriaDetail.text.trim().isNotEmpty)
        _cafeteriaDetailList.add(
          HtmlUnescape()
              .convert(cafeteriaDetail.outerHtml.replaceAll("<br>", "\n"))
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .trim(),
        );
    }
    return _cafeteriaDetailList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCafeteriaPlan,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return RefreshIndicator(
            onRefresh: () => _getCafeteriaPlan = _getCafeteriaPlanInit(),
            child: ListView(
              padding: EdgeInsets.only(top: 16.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Center(
                        child: Text(snapshot.data[0].toString(),
                            style: TextStyle(fontWeight: FontWeight.w700)))),
                ListView.builder(
                  itemCount: snapshot.data.length - 1,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Erstes Element in der Liste überspringen,
                    // da das bereits angezeigt wird und join() verwenden,
                    // um unerwünschte Zeichen auszublenden und mit \n einen Absatz einzufügen.
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          snapshot.data.sublist(1)[index].toString(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
