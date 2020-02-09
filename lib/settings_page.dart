import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _substitutionSettingsChanged = false;
  List<String> _allClasses = [];
  SharedPreferences _prefs;
  Future _getSettings;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSettings = _getSettingsInit();
  }

  Future _getSettingsInit() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getStringList('allClasses') != null)
      _allClasses = _prefs.getStringList('allClasses');
    else {
      final Response navbar = await Client().get(Uri.encodeFull(
          'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/frames/navbar.htm'));

      // Klassenliste aus dem Javascript-Element der Seite in eine List<String> konvertieren
      _allClasses = navbar.body
          .substring(
              navbar.body.indexOf("var classes = ["), navbar.body.indexOf("];"))
          .trim()
          .replaceFirst("var classes = [", "")
          .replaceFirst("];", "")
          .replaceAll("\"", "")
          .split(",");
      _allClasses.insert(0, "Alle Klassen anzeigen");
      _prefs.setStringList('allClasses', _allClasses);
    }
    _prefs.getBool('teacherSelected') ?? false
        ? _textEditingController.text = _prefs.getString('substitutionFilter')
        : _textEditingController.text = "ARE";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(title: "Einstellungen", withBackButton: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _getSettings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String _selected = _prefs.getString('substitutionFilter');
              bool _teacherSelected =
                  _prefs.getBool('teacherSelected') ?? false;
              bool _isFiltered =
                  _selected != "Alle Klassen anzeigen" && _selected != null;

              return ListView(
                children: <Widget>[
                  Text("Vertretungsplan"),
                  RadioListTile(
                      title: const Text("Alle Klassen anzeigen"),
                      value: "Alle Klassen anzeigen",
                      groupValue: _selected,
                      onChanged: (value) {
                        _prefs.setString('substitutionFilter', value);
                        _prefs.setBool('teacherSelected', false);
                        setState(() => _substitutionSettingsChanged = true);
                      }),
                  RadioListTile(
                      title: const Text("Nach Klasse filtern"),
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
                      title: const Text("Nach Lehrer filtern"),
                      value: _teacherSelected ? _selected : "ARE",
                      groupValue: _selected,
                      onChanged: (value) {
                        _teacherSelected
                            ? _textEditingController.text = _selected
                            : _textEditingController.text = "ARE";
                        _prefs.setString('substitutionFilter', value);
                        _prefs.setBool('teacherSelected', true);
                        setState(() => _substitutionSettingsChanged = true);
                      }),
                  _isFiltered &&
                          !_teacherSelected &&
                          _allClasses.sublist(1).contains(_selected)
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4.0)))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  items: _allClasses
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                              value: item, child: Text(item)))
                                      .toList(),
                                  onChanged: (value) {
                                    _prefs.setString(
                                        'substitutionFilter', value);
                                    setState(() =>
                                        _substitutionSettingsChanged = true);
                                  },
                                  value: _allClasses.contains(_selected)
                                      ? _selected
                                      : _allClasses[1]),
                            ),
                          ),
                        )
                      : Container(),
                  _isFiltered && _teacherSelected
                      ? TextField(
                          controller: _textEditingController,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          onChanged: (value) {
                            _prefs.setString('substitutionFilter', value);
                            setState(() => _substitutionSettingsChanged = true);
                          },
                        )
                      : Container(),
                  _substitutionSettingsChanged
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Icon(
                                      Icons.warning,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Nach Änderung der Einstellungen für den Vertretungsplan ist ein Neustart der App notwendig.",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
