import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _substitutionSettingsChanged = false;
  var _allClasses = <String>[];
  Future _getSettings;
  final _textEditingController = TextEditingController();
  final _prefs = SharedPrefs.instance;

  @override
  void initState() {
    super.initState();
    _getSettings = _getSettingsInit();
  }

  Future _getSettingsInit() async {
    if (_prefs.getStringList('allClasses') != null) {
      _allClasses = _prefs.getStringList('allClasses');
    } else {
      final url = Uri.parse(
          'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/frames/navbar.htm');
      final res = await http.get(url);

      // Klassenliste aus dem Javascript-Element der Seite in eine List<String> konvertieren
      _allClasses = res.body
          .substring(
              res.body.indexOf('var classes = ['), res.body.indexOf('];'))
          .trim()
          .replaceFirst('var classes = [', '')
          .replaceFirst('];', '')
          .replaceAll('"', '')
          .split(',');
      _allClasses.insert(0, 'Alle Klassen anzeigen');
      await _prefs.setStringList('allClasses', _allClasses);
    }
    _prefs.getBool('teacherSelected') ?? false
        ? _textEditingController.text = _prefs.getString('substitutionFilter')
        : _textEditingController.text = 'ARE';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Einstellungen'),
      ),
      body: FutureBuilder(
        future: _getSettings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final _selected = _prefs.getString('substitutionFilter');
            final _teacherSelected = _prefs.getBool('teacherSelected') ?? false;
            final _isFiltered =
                _selected != 'Alle Klassen anzeigen' && _selected != null;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                const Text('Vertretungsplan'),
                RadioListTile(
                    title: const Text('Alle Klassen anzeigen'),
                    value: 'Alle Klassen anzeigen',
                    groupValue: _selected,
                    onChanged: (value) {
                      _prefs.setString('substitutionFilter', value);
                      _prefs.setBool('teacherSelected', false);
                      setState(() => _substitutionSettingsChanged = true);
                    }),
                RadioListTile(
                    title: const Text('Nach Klasse filtern'),
                    value: _allClasses.sublist(1).contains(_selected)
                        ? _selected
                        : _allClasses[1],
                    groupValue: _selected,
                    onChanged: (value) {
                      _prefs.setString('substitutionFilter', value);
                      _prefs.setBool('teacherSelected', false);
                      setState(() => _substitutionSettingsChanged = true);
                    }),
                RadioListTile(
                    title: const Text('Nach Lehrer filtern'),
                    value: _teacherSelected ? _selected : 'ARE',
                    groupValue: _selected,
                    onChanged: (value) {
                      _teacherSelected
                          ? _textEditingController.text = _selected
                          : _textEditingController.text = 'ARE';
                      _prefs.setString('substitutionFilter', value);
                      _prefs.setBool('teacherSelected', true);
                      setState(() => _substitutionSettingsChanged = true);
                    }),
                if (_isFiltered &&
                    !_teacherSelected &&
                    _allClasses.sublist(1).contains(_selected))
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
                            items: _allClasses
                                .sublist(1)
                                .map((String item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (value) {
                              _prefs.setString('substitutionFilter', value);
                              setState(
                                  () => _substitutionSettingsChanged = true);
                            },
                            value: _allClasses.contains(_selected)
                                ? _selected
                                : _allClasses[1]),
                      ),
                    ),
                  ),
                if (_isFiltered && _teacherSelected)
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      _prefs.setString('substitutionFilter', value);
                      setState(() => _substitutionSettingsChanged = true);
                    },
                  ),
                if (_substitutionSettingsChanged)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.warning,
                                color: Colors.yellow,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Nach Änderung der Einstellungen für den Vertretungsplan ist ein Neustart der App notwendig.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
