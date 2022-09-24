import 'package:engelsburg_app/src/substitution_plan/models/substitution.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../common/substitution_provider.dart';

class SubstitutionPlanService {
  static Future<SubstitutionPlanData> getSubstitutionPlan() async {
    final substitutionNewsDays = <SubstitutionNewsDay>[];
    final substitutionDays = <SubstitutionDay>[];

    final navbarPageUrl = Uri.parse(
        'https://engelsburg.smmp.de/vertretungsplaene/eng/Stp_Upload/frames/navbar.htm');
    final navbarPageRes = await http.get(navbarPageUrl);
    final navbarPageDocument = parse(navbarPageRes.body);

    final untisWeeks = navbarPageDocument
        .querySelectorAll('select[name=week] > option')
        .map((w) => w.attributes['value']!)
        .toList();
    final navbarInfo =
        navbarPageDocument.querySelector('span.description')!.text;
    final lastChanged =
        navbarInfo.substring(navbarInfo.indexOf('Stand:')).trim();

    for (var i = 0; i < untisWeeks.length; i++) {
      final thisWeekSubstitutionDays = <SubstitutionDay>[];

      final substitutionTablePageUrl = Uri.parse(
          'https://engelsburg.smmp.de/vertretungsplaene/eng/Stp_Upload/${untisWeeks[i]}/w/w00000.htm');
      final substitutionTablePageRes = await http.get(substitutionTablePageUrl);
      final substitutionTablePageDocument =
          parse(substitutionTablePageRes.body);

      // Substitution days including ones with "Vertretungen sind nicht freigegeben"
      final subtitutionTableBodys =
          substitutionTablePageDocument.querySelectorAll('table.subst > tbody');

      // 6.7. Mittwoch, 7.7. Donnerstag etc.
      final dayStrings = substitutionTablePageDocument
          .querySelectorAll('#vertretung > p > b, #vertretung > b');

      for (var j = 0; j < dayStrings.length; j++) {
        final day = dayStrings[j].text;
        final isValidSubstitutionTable =
            subtitutionTableBodys[j].querySelector('tr.list > td') != null &&
                subtitutionTableBodys[j].querySelector('tr.list > td')!.text !=
                    'Vertretungen sind nicht freigegeben';

        if (isValidSubstitutionTable) {
          final tableRows =
              subtitutionTableBodys[j].querySelectorAll('tr.list').sublist(1);
          final substitutions = <Substitution>[];
          for (var tableRow in tableRows) {
            final cols = tableRow.querySelectorAll('td');

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

          thisWeekSubstitutionDays.add(SubstitutionDay(
              substitutions: substitutions,
              day: day,
              untisWeek: untisWeeks[i]));
        }
      }

      for (var k = 0; k < thisWeekSubstitutionDays.length; k++) {
        final day = thisWeekSubstitutionDays[k].day;

        final newsTables = substitutionTablePageDocument
            .querySelectorAll('table[bgcolor="#F4F4F4"]');
        final newsTexts = newsTables[k]
            .querySelectorAll('tbody > tr')
            .sublist(1)
            .map((e) => e.text)
            .toList();
        substitutionNewsDays
            .add(SubstitutionNewsDay(day: day, texts: newsTexts));
      }

      substitutionDays.addAll(thisWeekSubstitutionDays);
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
