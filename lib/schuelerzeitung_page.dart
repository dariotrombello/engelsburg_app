import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:device_info/device_info.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class SchuelerzeitungPage extends StatefulWidget {
  @override
  _SchuelerzeitungPageState createState() => _SchuelerzeitungPageState();
}

class _SchuelerzeitungPageState extends State<SchuelerzeitungPage>
    with AutomaticKeepAliveClientMixin<SchuelerzeitungPage> {
  bool _hasSupport;

  Future<PDFDocument> _pdfDocument() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _hasSupport = int.parse(iosInfo.systemVersion.split('.').first) >= 11;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _hasSupport = androidInfo.version.sdkInt >= 21;
    }

    return PDFDocument.openAsset("assets/schuelerzeitung.pdf");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _pdfDocument(),
      builder: (context, snapshot) {
        if (snapshot.hasData && !_hasSupport)
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
                    "Schülerzeitung wird erst ab Android 5.0 und iOS 11 unterstützt",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ],
            ),
          );
        if (snapshot.hasData) return PDFView(document: snapshot.data);
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
