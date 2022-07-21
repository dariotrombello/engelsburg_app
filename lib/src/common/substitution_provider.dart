import 'package:engelsburg_app/src/common/shared_prefs.dart';
import 'package:flutter/foundation.dart' show immutable, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

@immutable
class SubstitutionData {
  const SubstitutionData({
    this.isLoggedIn = false,
    required this.allClasses,
    required this.selectedClass,
    this.selectedTeacher = 'ARE',
    this.isTeacherSelected = false,
    this.isFilterActive = false,
  });

  final bool isLoggedIn;
  final List<String> allClasses;
  final String selectedClass;
  final String selectedTeacher;
  final bool isTeacherSelected;
  final bool isFilterActive;

  SubstitutionData copyWith({
    final bool? isLoggedIn,
    final List<String>? allClasses,
    final String? selectedClass,
    final String? selectedTeacher,
    final bool? isTeacherSelected,
    final bool? isFilterActive,
  }) {
    return SubstitutionData(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      allClasses: allClasses ?? this.allClasses,
      selectedClass: selectedClass ?? this.selectedClass,
      selectedTeacher: selectedTeacher ?? this.selectedTeacher,
      isTeacherSelected: isTeacherSelected ?? this.isTeacherSelected,
      isFilterActive: isFilterActive ?? this.isFilterActive,
    );
  }
}

Future<SubstitutionData> initialize() async {
  var allClasses = SharedPrefs.instance.getStringList('all_classes');

  try {
    final url = Uri.parse(
        'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/frames/navbar.htm');
    final res = await http.get(url);

    // Klassenliste aus dem Javascript-Element der Seite in eine List<String> konvertieren
    allClasses = res.body
        .substring(res.body.indexOf('var classes = ['), res.body.indexOf('];'))
        .trim()
        .replaceFirst('var classes = [', '')
        .replaceFirst('];', '')
        .replaceAll('"', '')
        .split(',');

    SharedPrefs.instance.setStringList('all_classes', allClasses);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return SubstitutionData(
    isLoggedIn: SharedPrefs.instance.getBool('isLoggedIn') ??
        SharedPrefs.instance.getBool('is_logged_in') ??
        false,
    allClasses: allClasses!,
    selectedClass:
        SharedPrefs.instance.getString('selected_class') ?? allClasses[0],
    selectedTeacher:
        SharedPrefs.instance.getString('selected_teacher') ?? 'ARE',
    isTeacherSelected:
        SharedPrefs.instance.getBool('is_teacher_selected') ?? false,
    isFilterActive: SharedPrefs.instance.getBool('is_filter_active') ?? false,
  );
}

class SubstitutionDataNotifier
    extends StateNotifier<AsyncValue<SubstitutionData>> {
  SubstitutionDataNotifier() : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = await AsyncValue.guard(() => initialize());
  }

  /// Do not call this method until the class is initialized
  Future<void> setSelectedClass(String? selectedClass) async {
    state = await AsyncValue.guard(() async {
      if (selectedClass == null) {
        await SharedPrefs.instance.remove('selected_class');
      } else {
        await SharedPrefs.instance.setString('selected_class', selectedClass);
      }

      return state.value!.copyWith(selectedClass: selectedClass);
    });
  }

  /// Do not call this method until the class is initialized
  Future<void> setSelectedTeacher(String? selectedTeacher) async {
    state = await AsyncValue.guard(() async {
      if (selectedTeacher == null) {
        SharedPrefs.instance.remove('selected_teacher');
      } else {
        await SharedPrefs.instance
            .setString('selected_teacher', selectedTeacher);
      }

      return state.value!.copyWith(selectedTeacher: selectedTeacher);
    });
  }

  /// Do not call this method until the class is initialized
  Future<void> setIsTeacher(bool isTeacherSelected) async {
    state = await AsyncValue.guard(() async {
      await SharedPrefs.instance
          .setBool('is_teacher_selected', isTeacherSelected);

      return state.value!.copyWith(isTeacherSelected: isTeacherSelected);
    });
  }

  /// Do not call this method until the class is initialized
  Future<void> toggleFilter() async {
    state = await AsyncValue.guard(() async {
      await SharedPrefs.instance
          .setBool('is_filter_active', !state.value!.isFilterActive);

      return state.value!
          .copyWith(isFilterActive: !state.value!.isFilterActive);
    });
  }

  /// Do not call this method until the class is initialized
  Future<void> logIn() async {
    state = await AsyncValue.guard(() async {
      await SharedPrefs.instance.setBool('is_logged_in', true);

      return state.value!.copyWith(isLoggedIn: true);
    });
  }
}

final substitutionDataProvider = StateNotifierProvider<SubstitutionDataNotifier,
    AsyncValue<SubstitutionData>>((ref) {
  return SubstitutionDataNotifier();
});
