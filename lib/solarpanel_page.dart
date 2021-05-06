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
          final _iconBoxes = [
            _iconBox(Icon(Icons.calendar_today, size: 56), 'Datum', _solarDate),
            _iconBox(Icon(Icons.lightbulb_outline, size: 56), 'Energie',
                _solarEnergy),
            _iconBox(Icon(Icons.landscape, size: 56), 'Vermiedenes CO2',
                _solarAvoidedCarbonDioxide),
            _iconBox(Icon(Icons.monetization_on, size: 56), 'Vergütung',
                _solarRevenue + '€'),
          ];
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.zero,
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.maxWidth > 400) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _iconBoxes,
                          ),
                        );
                      }
                      return GridView.count(
                        padding: const EdgeInsets.all(16.0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        children: _iconBoxes,
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(
                      snapshot.data.join('\n\n'),
                      style: TextStyle(
                          fontSize: 15.0,
                          height: 1.5,
                          fontFamily: 'Roboto Slab'),
                    ),
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

  Widget _iconBox(Icon icon, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        Text(title),
        Padding(padding: const EdgeInsets.only(top: 8.0)),
        Text(description)
      ],
    );
  }
}
