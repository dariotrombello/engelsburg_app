import 'package:engelsburg_app/src/common/substitution_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final substitutionData = ref.watch(substitutionDataProvider);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Einstellungen'),
        ),
        body: substitutionData.when(
          data: (data) => ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              const Text('Vertretungsplan'),
              SwitchListTile(
                  title: const Text('Filter aktivieren'),
                  value: data.isFilterActive,
                  onChanged: (value) {
                    ref.read(substitutionDataProvider.notifier).toggleFilter();
                  }),
              if (data.isFilterActive) ...[
                RadioListTile<bool>(
                    title: const Text('Nach Klasse filtern'),
                    value: false,
                    groupValue: data.isTeacherSelected,
                    onChanged: (value) {
                      ref
                          .read(substitutionDataProvider.notifier)
                          .setIsTeacher(false);
                    }),
                RadioListTile<bool>(
                    title: const Text('Nach Lehrer filtern'),
                    value: true,
                    groupValue: data.isTeacherSelected,
                    onChanged: (value) {
                      ref
                          .read(substitutionDataProvider.notifier)
                          .setIsTeacher(true);
                    }),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                if (data.isTeacherSelected)
                  TextFormField(
                    initialValue: data.selectedTeacher,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Lehrerkürzel eingeben'),
                    onChanged: (value) {
                      ref
                          .read(substitutionDataProvider.notifier)
                          .setSelectedTeacher(value);
                    },
                  )
                else
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1.0, color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: data.allClasses
                              .map((String item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (value) {
                            ref
                                .read(substitutionDataProvider.notifier)
                                .setSelectedClass(value);
                          },
                          value: data.selectedClass,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
          error: (e, st) => ErrorWidget(e.toString()),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
