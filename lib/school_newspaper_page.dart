import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:device_info/device_info.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class SchoolNewspaperPage extends StatefulWidget {
  @override
  _SchoolNewspaperPageState createState() => _SchoolNewspaperPageState();
}

class _SchoolNewspaperPageState extends State<SchoolNewspaperPage> {
  Future _hasSupport;
  final PdfController _pdfController = PdfController(
    document: PdfDocument.openAsset('assets/documents/schuelerzeitung.pdf'),
  );

  @override
  void initState() {
    super.initState();
    _hasSupport = _hasSupportInit();
  }

  Future<bool> _hasSupportInit() async {
    if (Platform.isMacOS || Platform.isIOS) {
      return true;
    }
    final deviceInfo = DeviceInfoPlugin();
    bool hasSupport = false;
    if (Platform.isAndroid == true) {
      final androidInfo = await deviceInfo.androidInfo;
      hasSupport = androidInfo.version.sdkInt >= 21;
    }
    return hasSupport;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hasSupport,
      builder: (context, snapshot) {
        if (snapshot.data == false)
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.import_contacts,
                  size: 128.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Schülerzeitung wird erst ab Android 5.0 unterstützt",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ],
            ),
          );
        if (snapshot.data == true) {
          return PdfView(controller: _pdfController);
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
