import 'package:engelsburg_app/src/solar_panel/models/solar_panel_data.dart';
import 'package:engelsburg_app/src/solar_panel/solar_panel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../error_card.dart';

class SolarPanelView extends StatelessWidget {
  const SolarPanelView({Key? key}) : super(key: key);

  static const routeName = '/solar_panel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Daten der Solaranlage'),
      ),
      body: FutureBuilder<SolarPanelData>(
        future: SolarPanelService.getSolarPanelData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            final iconBoxes = [
              _iconBox(const Icon(Icons.calendar_today, size: 56), 'Datum',
                  data.date),
              _iconBox(const Icon(Icons.lightbulb_outline, size: 56), 'Energie',
                  data.energy),
              _iconBox(const Icon(Icons.landscape, size: 56), 'Vermiedenes CO2',
                  data.avoidedCarbonDioxide),
              _iconBox(const Icon(Icons.monetization_on, size: 56), 'Vergütung',
                  '${data.revenue}€'),
            ];

            return ListView(
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
                          children: iconBoxes,
                        ),
                      );
                    }
                    return GridView.count(
                      padding: const EdgeInsets.all(16.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      children: iconBoxes,
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: HtmlWidget(data.html),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return const ErrorCard();
          }
          return const Center(child: CircularProgressIndicator());
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
        const Padding(padding: EdgeInsets.only(top: 8.0)),
        Text(description)
      ],
    );
  }
}
