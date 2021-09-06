import 'dart:convert';

import 'package:engelsburg_app/models/engelsburg_api/cafeteria.dart';
import 'package:engelsburg_app/models/engelsburg_api/result.dart';
import 'package:engelsburg_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({Key? key}) : super(key: key);

  @override
  _CafeteriaPageState createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage>
    with AutomaticKeepAliveClientMixin<CafeteriaPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<Result>(
        future: ApiService.getCafeteria(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final html = snapshot.data!.onError((error) => {
              //TODO: implement errors
            }).handleUnexpectedError().parse((json) => json!['content']);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(html),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
