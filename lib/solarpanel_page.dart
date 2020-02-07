import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';

import 'main.dart';

class SolarPanelPage extends StatefulWidget {
  @override
  _SolarPanelPageState createState() => _SolarPanelPageState();
}

class _SolarPanelPageState extends State<SolarPanelPage> {
  String _solarAvoidedCarbonDioxide = "";
  String _solarDate = "";
  String _solarEnergy = "";
  String _solarRevenue = "";

  Future<List<String>> _getSolarPanelData() async {
    final List<String> _solarDescription = [];
    final Response solarDataLink = await Client().get(Uri.encodeFull(
        'https://www.sunnyportal.com/Templates/PublicPageOverview.aspx?plant=554d90c7-84a2-474c-94db-d2ac5f5af3c3&splang=de-DE'));
    final Response solarDescriptionLink = await Client().get(Uri.encodeFull(
        'https://engelsburg.smmp.de/leben-an-der-schule/solaranlage/'));
    final dom.Document document1 = parse(solarDataLink.body);
    final dom.Document document2 = parse(solarDescriptionLink.body);
    final List<dom.Element> solarDescriptionList =
        document2.querySelectorAll("div.entry-content > p");
    for (var _solarText in solarDescriptionList) {
      _solarDescription.add(
        _solarText.text,
      );
    }
    _solarAvoidedCarbonDioxide = document1
        .querySelector(
            "div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelCO2Value")
        .text;
    _solarDate = document1
        .querySelector(
            "div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelTime")
        .text;
    _solarEnergy = document1
        .querySelector(
            "div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelETotalValue")
        .text;
    _solarRevenue = document1
        .querySelector(
            "div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelRevenueValue")
        .text;
    return _solarDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        text: "Daten der Solaranlage",
        withBackButton: true,
      ),
      body: FutureBuilder(
        future: _getSolarPanelData(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return RefreshIndicator(
              onRefresh: () => _getSolarPanelData(),
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
                                  Text("Datum"),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarDate)
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline, size: 56),
                                  Text("Energie"),
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
                                  Text("Vermiedenes CO2"),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarAvoidedCarbonDioxide)
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.monetization_on, size: 56),
                                  Text("Vergütung"),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0)),
                                  Text(_solarRevenue + "€")
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
                    child: Text(snapshot.data.join("\n\n")),
                  )
                ],
              ),
            );
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
