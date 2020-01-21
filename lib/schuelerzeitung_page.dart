import 'package:flutter/material.dart';

import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchuelerzeitungPage extends StatefulWidget {
  @override
  _SchuelerzeitungPageState createState() => _SchuelerzeitungPageState();
}

class _SchuelerzeitungPageState extends State<SchuelerzeitungPage> {
  Future _checkIfAlredyDimissed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('dimissed') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkIfAlredyDimissed(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Center(
            child: PdfDocumentLoader(
              assetName: 'assets/schuelerzeitung.pdf',
              documentBuilder: (context, pdfDocument, pageCount) =>
                  LayoutBuilder(
                builder: (context, constraints) => ListView.builder(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: pageCount,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(5.0),
                    color: Colors.black12,
                    child: PdfPageView(
                      pageFit: PdfPageFit(
                          fit: BoxFit.scaleDown,
                          height: constraints.maxHeight - 10,
                          width: constraints.maxWidth - 10),
                      pdfDocument: pdfDocument,
                      pageNumber: index + 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasData && !snapshot.data) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                      "Diese Funktion ist noch instabil und könnte Fehler erzeugen. Möchtest du sie dennoch ausprobieren?"),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("JA"),
                    onPressed: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      _prefs
                          .setBool("dimissed", true)
                          .whenComplete(() => setState(() {}));
                    },
                  )
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
