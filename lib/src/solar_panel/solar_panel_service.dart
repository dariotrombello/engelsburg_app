import 'dart:convert';

import 'package:engelsburg_app/src/solar_panel/models/solar_panel_data.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class SolarPanelService {
  static Future<SolarPanelData> getSolarPanelData() async {
    final dataUrl = Uri.parse(
        'https://www.sunnyportal.com/Templates/PublicPageOverview.aspx?plant=554d90c7-84a2-474c-94db-d2ac5f5af3c3&splang=de-DE');
    final dataRes = await http.get(dataUrl);
    if (!dataRes.statusCode.toString().startsWith('2')) {
      throw 'Error while trying to load the page';
    }
    final explanationUrl =
        Uri.parse('https://engelsburg.smmp.de/wp-json/wp/v2/pages/68');
    final explanationRes = await http.get(explanationUrl);
    final dataDoc = parse(dataRes.body);
    final explanationJson = json.decode(explanationRes.body);

    return SolarPanelData(
        avoidedCarbonDioxide: dataDoc
            .querySelector(
                'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelCO2Value')!
            .text,
        energy: dataDoc
            .querySelector(
                'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelETotalValue')!
            .text,
        date: dataDoc
            .querySelector(
                'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelTime')!
            .text,
        revenue: dataDoc
            .querySelector(
                'div.base-label-titel > #ctl00_ContentPlaceHolder1_PublicPagePlaceholder_PageUserControl_ctl00_UserControl0_LabelRevenueValue')!
            .text,
        html: explanationJson['content']['rendered']);
  }
}
