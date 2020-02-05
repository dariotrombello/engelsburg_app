import 'package:flutter/material.dart';

import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class SchuelerzeitungPage extends StatefulWidget {
  @override
  _SchuelerzeitungPageState createState() => _SchuelerzeitungPageState();
}

class _SchuelerzeitungPageState extends State<SchuelerzeitungPage>
    with AutomaticKeepAliveClientMixin<SchuelerzeitungPage> {
  Future _pdfDocument;

  Future<PDFDocument> _pdfDocumentInit() {
    return PDFDocument.openAsset("assets/schuelerzeitung.pdf");
  }

  @override
  void initState() {
    _pdfDocument = _pdfDocumentInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _pdfDocument,
      builder: (context, snapshot) {
        if (snapshot.hasData) return PDFView(document: snapshot.data);
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
