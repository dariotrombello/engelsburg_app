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
  final PdfController _pdfController = PdfController(
    document: PdfDocument.openAsset('assets/schuelerzeitung.pdf'),
  );

  Future<bool> _hasSupport() async {
    if (Platform.isMacOS || Platform.isIOS) {
      return true;
    }
    final deviceInfo = DeviceInfoPlugin();
    bool hasSupport = false;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      hasSupport = androidInfo.version.sdkInt >= 21;
    }
    return hasSupport;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _hasSupport(),
      builder: (context, snapshot) {
        if (!snapshot.data)
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
        if (snapshot.data) {
          return PdfView(controller: _pdfController);
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
