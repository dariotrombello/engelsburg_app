import 'package:engelsburg_app/src/substitution_plan/models/substitution.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../common/substitution_provider.dart';

class SubstitutionPlanService {
  static Future<SubstitutionPlanData> getSubstitutionPlan() async {
    final substitutionNewsDays = <SubstitutionNewsDay>[];
    final substitutionDays = <SubstitutionDay>[];

    final navbarUrl = Uri.parse(
        'https://engelsburg.smmp.de/vertretungsplaene/eng/Stp_Upload/frames/navbar.htm');
    final navbarRes = await http.get(navbarUrl);
    final navbarDocument = parse(navbarRes.body);

    final untisWeeks = navbarDocument
        .querySelectorAll('select[name=week] > option')
        .map((w) => w.attributes['value']!)
        .toList();
    final navbarInfo = navbarDocument.querySelector('span.description')!.text;
    final lastChanged =
        navbarInfo.substring(navbarInfo.indexOf('Stand:')).trim();

    for (var i = 0; i < untisWeeks.length; i++) {
      final substitutionTableUrl = Uri.parse(
          'https://engelsburg.smmp.de/vertretungsplaene/eng/Stp_Upload/${untisWeeks[i]}/w/w00000.htm');
      final substitutionTableRes = await http.get(substitutionTableUrl);
      final substitutionTableDocument = parse(substitutionTableRes.body);
      // Substitution days including ones with "Vertretungen sind nicht freigegeben"
      final allSubstitutionDays =
          substitutionTableDocument.querySelectorAll('table.subst > tbody');
      // 6.7. Mittwoch, 7.7. Donnerstag etc.
      final days = substitutionTableDocument
          .querySelectorAll('#vertretung > p > b, #vertretung > b');

      for (var i = 0; i < days.length; i++) {
        final day = days[i].text;
        final isValidSubstitutionDay =
            allSubstitutionDays[i].querySelector('tr.list > td') != null &&
                allSubstitutionDays[i].querySelector('tr.list > td')!.text !=
                    'Vertretungen sind nicht freigegeben';

        if (isValidSubstitutionDay) {
          final rows =
              allSubstitutionDays[i].querySelectorAll('tr.list').sublist(1);
          final substitutions = <Substitution>[];
          for (var row in rows) {
            final cols = row.querySelectorAll('td');

            // this is not a substitution - untis creates rows that just contain
            // a note column when the note has too many characters on the previous row
            if (cols[1].text.trim().isEmpty && cols[8].text.trim().isNotEmpty) {
              final lastSubstitution = substitutions.last;
              lastSubstitution.note =
                  '${lastSubstitution.note} ${cols[8].text.trim()}';
            } else {
              final className = cols[0].text.trim();
              final hour = cols[1].text.trim();
              final subject = cols[2].text.trim();
              final substitutingTeacher =
                  cols[3].text.trim().replaceFirst('+', '');
              final substitutedTeacher = cols[4].text.trim();
              final type = cols[5].text.trim();
              // only has a value if the substitution is of type "Verlegung"
              final newTime = cols[6].text.trim();
              final room = cols[7].text.trim().replaceFirst('---', '');
              final note = cols[8].text.trim();

              substitutions.add(
                Substitution(
                  className: className,
                  hour: hour,
                  subject: subject,
                  substitutingTeacher: substitutingTeacher,
                  substitutedTeacher: substitutedTeacher,
                  type: type,
                  newTime: newTime,
                  room: room,
                  note: note,
                ),
              );
            }
          }

          substitutionDays
              .add(SubstitutionDay(substitutions: substitutions, day: day));
        }
      }

      for (var i = 0; i < substitutionDays.length; i++) {
        final day = substitutionDays[i].day;

        final newsTables = substitutionTableDocument
            .querySelectorAll('table[bgcolor="#F4F4F4"]');
        final newsTexts = newsTables[i]
            .querySelectorAll('tbody > tr')
            .sublist(1)
            .map((e) => e.text)
            .toList();
        substitutionNewsDays
            .add(SubstitutionNewsDay(day: day, texts: newsTexts));
      }
    }

    return SubstitutionPlanData(
        substitutionDays: substitutionDays,
        substitutionNewsDays: substitutionNewsDays,
        lastChanged: lastChanged);
  }

  static List<Substitution> filterSubstitutions(
      List<Substitution> substitutions, SubstitutionData data) {
    if (!data.isFilterActive) return substitutions;

    final filteredSubstitutions = <Substitution>[];

    for (var substitution in substitutions) {
      if (!data.isTeacherSelected) {
        final compositedClasses =
            RegExp(r'\d+[a-z]+').allMatches(substitution.className);

        if (substitution.className == data.selectedClass) {
          filteredSubstitutions.add(substitution);
        } else if (compositedClasses.isNotEmpty) {
          for (var compositedClassMatch in compositedClasses) {
            // Gibt es einen besseren Weg, um von Untis zusammengesetzte
            // Klassen wie 7cd8bce wieder zu trennen?

            final compositedClass = compositedClassMatch.group(0)!;

            if (!data.selectedClass
                .startsWith(compositedClass.replaceAll(RegExp(r'[^\d]'), ''))) {
              continue;
            }

            if (compositedClass
                .replaceAll(r'[^\d]', '')
                .contains(data.selectedClass.substring(
                  data.selectedClass.indexOf(RegExp('[a-zA-Z]')),
                ))) {
              filteredSubstitutions.add(substitution);
            }
          }
        }
      } else if (data.isTeacherSelected &&
          (substitution.substitutedTeacher == data.selectedTeacher ||
              substitution.substitutingTeacher == data.selectedTeacher)) {
        filteredSubstitutions.add(substitution);
      }
    }

    return filteredSubstitutions;
  }
}
