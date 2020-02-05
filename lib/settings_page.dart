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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(text: "Einstellungen", withBackButton: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _getSettings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String _selectedClass = _prefs.getString('selectedClass');
              bool _filtered = _selectedClass != "Alle Klassen anzeigen" &&
                  _selectedClass != null;

              return ListView(
                children: <Widget>[
                  Text("Vertretungsplan"),
                  RadioListTile(
                      title: const Text("Alle Klassen anzeigen"),
                      value: _selectedClass == null
                          ? null
                          : "Alle Klassen anzeigen",
                      groupValue: _selectedClass,
                      onChanged: (value) {
                        _prefs.setString('selectedClass', value);
                        setState(() {
                          _substitutionSettingsChanged = true;
                        });
                      }),
                  RadioListTile(
                      title: const Text("Nach Klasse filtern"),
                      value: _filtered ? _selectedClass : _allClasses[1],
                      groupValue: _selectedClass,
                      onChanged: (value) {
                        if (!_filtered)
                          _prefs.setString('selectedClass', value);
                        setState(() {
                          _substitutionSettingsChanged = true;
                        });
                      }),
                  _filtered
                      ? DropdownButton<String>(
                          items: _allClasses
                              .map((String item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (value) {
                            _prefs.setString('selectedClass', value);
                            setState(() {
                              _substitutionSettingsChanged = true;
                            });
                          },
                          value: _selectedClass,
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
