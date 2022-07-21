import 'package:flutter/material.dart';

class SubstitutionPlanUtils {
  static MaterialColor getColorBySubstitutionType(String type) {
    switch (type) {
      case 'Betreuung':
        return Colors.indigo;
      case 'eigenv. Arb.':
        return Colors.purple;
      case 'Entfall':
        return Colors.red;
      case 'Raum-Vtr.':
        return Colors.green;
      case 'Veranst.':
        return Colors.orange;
      case 'Sondereins.':
        return Colors.brown;
      case 'Unterr. geändert':
        return Colors.amber;
      case 'Verlegung':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }
}
