class SubstitutionPlanData {
  final String lastChanged;
  final List<SubstitutionDay> substitutionDays;
  final List<SubstitutionNewsDay> substitutionNewsDays;

  SubstitutionPlanData({
    required this.substitutionDays,
    required this.substitutionNewsDays,
    required this.lastChanged,
  });
}

class SubstitutionNewsDay {
  final String day;
  final List<String> texts;

  SubstitutionNewsDay({required this.day, required this.texts});
}

class SubstitutionDay {
  final String day;
  final List<Substitution> substitutions;

  SubstitutionDay({required this.substitutions, required this.day});
}

class Substitution {
  String className;
  String hour;
  String subject;
  String substitutingTeacher;
  String substitutedTeacher;
  String type;
  String newTime;
  String room;
  String note;

  Substitution({
    required this.className,
    required this.hour,
    required this.subject,
    required this.substitutingTeacher,
    required this.substitutedTeacher,
    required this.type,
    required this.newTime,
    required this.room,
    required this.note,
  });
}
