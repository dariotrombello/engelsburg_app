import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VertretungsplanPage extends StatefulWidget {
  @override
  VertretungsplanPageState createState() => VertretungsplanPageState();
}

class VertretungsplanPageState extends State<VertretungsplanPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _noSubstitutionsAvailable = false;
  bool _wrongPassword = false;
  final List<dom.Element> _newsDays = [];
  final List<dom.Element> _substitutionDays = [];
  final List<String> _dayList = [];
  List<String> _allClasses = [];
  SharedPreferences _prefs;
  String _input;
  String _lastChanged = "";
  String _selectedClass;
  final String _password = "@Vertretung2019";
  String untisWeek = "";
  TabController _tabController;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkLogin();
    _getNavbar();
    _filterForClass();
    _getTables();
  }

  _checkLogin() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = (_prefs.getBool('isLoggedIn') ?? false);
    await _prefs.setBool('isLoggedIn', _isLoggedIn);
  }

  _logIn() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('isLoggedIn', true);
    setState(() => _isLoggedIn = (_prefs.getBool('isLoggedIn') ?? false));
  }

  _filterForClass() async {
    _prefs = await SharedPreferences.getInstance();
    _selectedClass = (_prefs.getString('selectedClass'));
    await _prefs.setString('selectedClass', _selectedClass);
  }

  _setFilteredClass() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('selectedClass', _selectedClass);
  }

  Future _getNavbar() async {
    final Response navbar = await Client().get(Uri.encodeFull(
        'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/frames/navbar.htm'));
    final dom.Document document = parse(navbar.body);
    final dom.Element navbarWeek =
        document.querySelector("select.selectbox > option");
    final String info = document.querySelector("span.description").text;
    _lastChanged = info.substring(info.indexOf("Stand:")).trim();
    setState(() {
      untisWeek = navbarWeek.attributes["value"];
      // Klassenliste aus dem Javascript-Element der Seite in eine List<String> konvertieren
      _allClasses = navbar.body
          .substring(navbar.body.indexOf("var classes"),
              navbar.body.lastIndexOf("var flcl"))
          .trim()
          .replaceAll("var classes = [", "")
          .replaceAll("];", "")
          .replaceAll("\"", "")
          .split(",");
      _allClasses.insert(0, "Alle Klassen anzeigen");
    });
  }

  Future _getTables() async {
    _getNavbar().whenComplete(() async {
      final Response substitutionTable = await Client().get(Uri.encodeFull(
          'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/' +
              untisWeek +
              '/w/w00000.htm'));
      final dom.Document document = parse(substitutionTable.body);
      final List<dom.Element> _allSubstitutionDays =
          document.querySelectorAll("table.subst > tbody");
      final List<dom.Element> _allTables = document.querySelectorAll("table");
      final List<dom.Element> days =
          document.querySelectorAll("#vertretung > p > b, #vertretung > b");

      for (int i = 0; i < _allSubstitutionDays.length; i++) {
        if (_allSubstitutionDays[i].querySelector("tr.list > td") != null &&
            _allSubstitutionDays[i].querySelector("tr.list > td").text !=
                "Vertretungen sind nicht freigegeben") {
          _dayList.add(days[i].text);
          _substitutionDays.add(_allSubstitutionDays[i]);
        }
      }

      for (int i = 0; i < _allTables.length; i++) {
        if (_allTables[i].attributes["bgcolor"] == "#F4F4F4") {
          _newsDays.add(_allTables[i].querySelector("tbody"));
        }
      }

      // CircularProgressIndicator wieder deaktivieren, wenn der Text geladen wurde.
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoggedIn
          ? TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  // TEMP: Umgehung eines Bugs, der im hellen Modus der App auftritt
                  child: Text(
                    "Vertretungsplan",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color),
                  ),
                ),
                Tab(
                  // TEMP: Umgehung eines Bugs, der im hellen Modus der App auftritt
                  child: Text(
                    "Nachrichten",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color),
                  ),
                ),
              ],
            )
          : null,
      body: !_isLoggedIn && !_isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _textEditingController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (input) => setState(() => _input = input),
                    onSubmitted: (input) => input == _password
                        ? _logIn()
                        : setState(() {
                            _wrongPassword = true;
                            _textEditingController.clear();
                          }),
                    decoration: InputDecoration(
                        hintText: 'Passwort eingeben',
                        contentPadding: const EdgeInsets.all(16.0),
                        errorText: _wrongPassword
                            ? "Falsches Passwort eingegeben"
                            : null,
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                ),
                RaisedButton(
                    child: Text("Einloggen"),
                    onPressed: () => _input == _password
                        ? _logIn()
                        : setState(() {
                            _wrongPassword = true;
                            _textEditingController.clear();
                          })),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                ),
                DropdownButton<String>(
                  hint: Text("Nach Klasse filtern"),
                  value: _selectedClass,
                  items: _allClasses
                      .map((String item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  onChanged: (_value) => setState(() {
                    _selectedClass = _value;
                    _setFilteredClass();
                  }),
                ),
              ],
            )
          : TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: _substitutionDays.length,
                  itemBuilder: (context, index) {
                    final List<dom.Element> _currentColumns =
                        _substitutionDays[index]
                            .querySelectorAll("tr.list")
                            .sublist(1);
                    final List<String> _classes = [];
                    final List<String> _hours = [];
                    final List<String> _rooms = [];
                    final List<String> _subjects = [];
                    final List<String> _substitutionInformation = [];
                    final List<String> _substitutionSpan = [];
                    final List<String> _substitutionTeachers = [];
                    final List<String> _substitutionTypes = [];
                    final List<String> _teachers = [];

                    for (int i = 0; i < _currentColumns.length; i++) {
                      final List<dom.Element> _currentRow =
                          _currentColumns[i].querySelectorAll("td");
                      _classes.add(_currentRow[0].text.trim());
                      _hours.add(_currentRow[1].text.trim());
                      _subjects.add(_currentRow[2].text.trim());
                      _substitutionTeachers
                          .add(_currentRow[3].text.trim().replaceAll("+", ""));
                      _teachers.add(_currentRow[4].text.trim());
                      _substitutionTypes.add(_currentRow[5].text.trim());
                      _substitutionSpan.add(_currentRow[6].text.trim());
                      _rooms.add(
                          _currentRow[7].text.trim().replaceAll("---", ""));
                      _substitutionInformation.add(_currentRow[8].text.trim());
                    }
                    if (!_classes.contains(_selectedClass) &&
                        _selectedClass != "Alle Klassen anzeigen" &&
                        _selectedClass != null) {
                      _noSubstitutionsAvailable = true;
                    } else {
                      _noSubstitutionsAvailable = false;
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _dayList[index],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        _noSubstitutionsAvailable
                            ? SizedBox(
                                width: double.maxFinite,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Center(
                                      child: Text(
                                        "Keine Vertretungen für diesen Tag",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _classes.length,
                                itemBuilder: (context, index2) {
                                  bool _hideElement = false;
                                  if (_selectedClass == null ||
                                      _selectedClass ==
                                          "Alle Klassen anzeigen") {
                                    _hideElement = false;
                                  } else if (
                                      // Gibt es einen besseren Weg, von Untis zusammengesetzte
                                      // Klassen wie 7abcd8abc wieder zu trennen?
                                      _classes[index2]
                                              .startsWith(RegExp(r'^\d+')) &&
                                          _selectedClass
                                              .startsWith(RegExp(r'^\d+')) &&
                                          _classes[index2].substring(
                                                  _classes[index2]
                                                      .indexOf(RegExp(r'^\d+')),
                                                  _classes[index2].lastIndexOf(
                                                          RegExp(r'^\d+')) +
                                                      1) ==
                                              _selectedClass.substring(
                                                  _selectedClass
                                                      .indexOf(RegExp(r'^\d+')),
                                                  _selectedClass.lastIndexOf(
                                                          RegExp(r'^\d+')) +
                                                      1)) {
                                    _classes[index2]
                                            .substring(_classes[index2]
                                                .indexOf(RegExp('[a-zA-Z]')))
                                            .contains(_selectedClass.substring(
                                              _selectedClass
                                                  .indexOf(RegExp('[a-zA-Z]')),
                                            ))
                                        ? _hideElement = false
                                        : _hideElement = true;
                                  } else if (_classes[index2] ==
                                      _selectedClass) {
                                    _hideElement = false;
                                  } else {
                                    _hideElement = true;
                                  }
                                  return Column(
                                    children: <Widget>[
                                      _hideElement
                                          ? Container()
                                          : Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                        leading: Text(
                                                          _hours[index2],
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                          ),
                                                        ),
                                                        title: Text(
                                                            _substitutionTypes[
                                                                index2]),
                                                        subtitle: Wrap(
                                                          children: <Widget>[
                                                            Text(_classes[
                                                                index2]),
                                                            Text(_subjects[
                                                                        index2] ==
                                                                    ""
                                                                ? ""
                                                                : " – "),
                                                            Text(_subjects[
                                                                index2]),
                                                            Text(_substitutionTeachers[
                                                                        index2] ==
                                                                    ""
                                                                ? ""
                                                                : " (${_substitutionTeachers[index2]}"),
                                                            Text(_substitutionTeachers[
                                                                            index2] !=
                                                                        "" &&
                                                                    _teachers[
                                                                            index2] ==
                                                                        ""
                                                                ? ")"
                                                                : ""),
                                                            Text(_substitutionTeachers[
                                                                            index2] !=
                                                                        "" &&
                                                                    _teachers[
                                                                            index2] !=
                                                                        "" &&
                                                                    _substitutionTeachers[
                                                                            index2] !=
                                                                        _teachers[
                                                                            index2]
                                                                ? " statt "
                                                                : ""),
                                                            Text(_substitutionTeachers[
                                                                            index2] ==
                                                                        "" &&
                                                                    _teachers[
                                                                            index2] !=
                                                                        ""
                                                                ? " ("
                                                                : ""),
                                                            Text(
                                                                _teachers[index2] ==
                                                                        _substitutionTeachers[
                                                                            index2]
                                                                    ? ""
                                                                    : _teachers[
                                                                        index2],
                                                                style:
                                                                    TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                )),
                                                            Text(_teachers[
                                                                        index2] !=
                                                                    ""
                                                                ? ")"
                                                                : ""),
                                                            Text(_rooms[index2] ==
                                                                    ""
                                                                ? ""
                                                                : " in " +
                                                                    _rooms[
                                                                        index2]),
                                                            Text(_substitutionInformation[
                                                                        index2] ==
                                                                    ""
                                                                ? ""
                                                                : " – ${_substitutionInformation[index2]}"),
                                                            Text(_substitutionSpan[
                                                                        index2] ==
                                                                    ""
                                                                ? ""
                                                                : " – ${_substitutionSpan[index2]}")
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      _substitutionDays[_substitutionDays
                                                      .indexOf(_substitutionDays
                                                          .last)] ==
                                                  _substitutionDays[index] &&
                                              index2 + 1 ==
                                                  _currentColumns.length
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Text(_lastChanged))
                                          : Container()
                                    ],
                                  );
                                },
                              ),
                      ],
                    );
                  },
                ),
                ListView.builder(
                  itemCount: _substitutionDays.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _dayList[index],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount:
                              _newsDays[index].querySelectorAll("tr").length -
                                  1,
                          itemBuilder: (context, index2) {
                            List<String> _news = [];
                            for (dom.Element _newsDay in _newsDays[index]
                                .querySelectorAll("tr")
                                .sublist(1)) {
                              _news.add(_newsDay.text);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      _news[index2],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                _newsDays[_newsDays.indexOf(_newsDays.last)] ==
                                            _newsDays[index] &&
                                        index2 + 1 ==
                                            _newsDays[index]
                                                    .querySelectorAll("tr")
                                                    .length -
                                                1
                                    ? Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(_lastChanged)))
                                    : Container()
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
