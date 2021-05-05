import 'package:engelsburg_app/error_card.dart';
import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class SolarPanelPage extends StatefulWidget {
  @override
  _SolarPanelPageState createState() => _SolarPanelPageState();
}

class _SolarPanelPageState extends State<SolarPanelPage> {
  var _solarAvoidedCarbonDioxide = '';
  var _solarDate = '';
  var _solarEnergy = '';
  var _solarRevenue = '';

  Future<List<String>> _getSolarPanelData() async {
    final solarDescription = <String>[];

    final solarDataUrl = Uri.parse(
        'https://www.sunnyportal.com/Templates/PublicPageOverview.aspx?plant=554d90c7-84a2-474c-94db-d2ac5f5af3c3&splang=de-DE');
    final solarDataRes = await http.get(solarDataUrl);
    if (!solarDataRes.statusCode.toString().startsWith('2')) {
      throw 'Error while trying to load the page';
    }
    final solarDescriptionUrl = Uri.parse(
        'https://engelsburg.smmp.de/leben-an-der-schule/solaranlage/');
    final solarDescriptionRes = await http.get(solarDescriptionUrl);
    final document1 = parse(solarDataRes.body);
    final document2 = parse(solarDescriptionRes.body);
    final solarDescriptionList =
        document2.querySelectorAll('div.entry-content > p');
    for (var _solarText in solarDescriptionList) {
      solarDescription.add(
        _solarText.text,
      );
    }
    _solarAvoidedCarbonDioxide = document1
        .querySelector(
            'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelCO2Value')
        .text;
    _solarDate = document1
        .querySelector(
            'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelTime')
        .text;
    _solarEnergy = document1
        .querySelector(
            'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelETotalValue')
        .text;
    _solarRevenue = document1
        .querySelector(
            'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelRevenueValue')
        .text;
    return solarDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Daten der Solaranlage'),
      ),
      body: FutureBuilder(
        future: _getSolarPanelData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(Icons.calendar_today, size: 56),
                                  Text('Datum'),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarDate)
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline, size: 56),
                                  Text('Energie'),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarEnergy)
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 32.0, right: 32.0, bottom: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(Icons.landscape, size: 56),
                                  Text('Vermiedenes CO2'),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarAvoidedCarbonDioxide)
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.monetization_on, size: 56),
                                  Text('Vergütung'),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarRevenue + '€')
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(snapshot.data.join('\n\n')),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorCard();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
