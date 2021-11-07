import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class SchoolNewspaperPage extends StatefulWidget {
  const SchoolNewspaperPage({Key key}) : super(key: key);

  @override
  _SchoolNewspaperPageState createState() => _SchoolNewspaperPageState();
}

class _SchoolNewspaperPageState extends State<SchoolNewspaperPage> {
  final PdfController _pdfController = PdfController(
    document: PdfDocument.openAsset('assets/documents/schuelerzeitung.pdf'),
  );

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(controller: _pdfController);
  }
}
