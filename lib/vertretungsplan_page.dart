import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class VertretungsplanPage extends StatefulWidget {
  @override
  VertretungsplanPageState createState() => VertretungsplanPageState();
}

class VertretungsplanPageState extends State<VertretungsplanPage>
    with
        AutomaticKeepAliveClientMixin<VertretungsplanPage>,
        SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;
  bool _noSubstitutionsAvailable = false;
  bool _wrongPassword = false;
  final List<dom.Element> _newsDays = [];
  final List<dom.Element> _substitutionDays = [];
  final List<String> _dayList = [];
  List<String> _allClasses = [];
  String _input;
  String _lastChanged = "";
  String _substitutionFilter;
  final String _password = "@Vertretung2019";
  TabController _tabController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teacherNameController = TextEditingController();
  Future _substitutionPlan;
  int _welcomePage = 0;
  SharedPreferences _prefs;
  bool _teacherSelected;

  @override
  void initState() {
    super.initState();
    _substitutionPlan = _substitutionPlanInit();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future _checkLogin() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = (_prefs.getBool('isLoggedIn') ?? false) &&
        _prefs.getString('substitutionFilter') != null;
    await _prefs.setBool('isLoggedIn', _isLoggedIn);
  }

  Future _logIn() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('isLoggedIn', true);
    setState(() => _isLoggedIn = (_prefs.getBool('isLoggedIn') ?? false));
  }

  Future _getSubstitutionFilter() async {
    _prefs = await SharedPreferences.getInstance();
    _teacherSelected = _prefs.getBool('teacherSelected');
    _substitutionFilter =
        _prefs.getString('substitutionFilter') ?? "Alle Klassen anzeigen";
    _prefs.setString('substitutionFilter', _substitutionFilter);
  }

  Future _setSubstitutionFilter() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('substitutionFilter', _substitutionFilter);
  }

  Future _getSubstitutionPlan() async {
    List<String> untisWeeks = [];
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final Response navbar = await Client().get(Uri.encodeFull(
        'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/frames/navbar.htm'));
    final dom.Document navbarDocument = parse(navbar.body);
    final List<dom.Element> navbarWeeks =
        navbarDocument.querySelectorAll("select.selectbox > option");
    final String info = navbarDocument.querySelector("span.description").text;
    _lastChanged = info.substring(info.indexOf("Stand:")).trim();

    for (var i = 0; i < navbarWeeks.length; i++) {
      untisWeeks.add(navbarWeeks[i].attributes["value"]);
      final Response substitutionTable = await Client().get(Uri.encodeFull(
          'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/' +
              untisWeeks[i] +
              '/w/w00000.htm'));
      final dom.Document substitutionTableDocument =
          parse(substitutionTable.body);
      final List<dom.Element> _allSubstitutionDays =
          substitutionTableDocument.querySelectorAll("table.subst > tbody");
      final List<dom.Element> _allTables =
          substitutionTableDocument.querySelectorAll("table");
      final List<dom.Element> days = substitutionTableDocument
          .querySelectorAll("#vertretung > p > b, #vertretung > b");
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
    }

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
    setState(() {});
  }

  Future _substitutionPlanInit() async {
    await _checkLogin();
    await _getSubstitutionFilter();
    await _getSubstitutionPlan();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double _displayHeight = MediaQuery.of(context).size.height;

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
      body: FutureBuilder(
        future: _substitutionPlan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !_isLoggedIn &&
              _welcomePage == 0)
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.arrow_forward),
                onPressed: () => setState(() => _welcomePage = 1),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Image.asset(
                        "assets/applogo.png",
                        height: _displayHeight * 0.2,
                      ),
                    ),
                    Text(
                      "Willkommen beim Vertretungsplan\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _displayHeight * 0.05,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: _displayHeight * 0.02,
                            color: Theme.of(context).textTheme.body1.color),
                        text:
                            "Um sich anzumelden, wird das Passwort benötigt, das auch für den Vertretungsplan auf der Internetseite der Engelsburg verwendet wird. Es steht derzeit auch auf Werbezetteln, die an der ganzen Schule an den Eingangstüren hängen. Falls Sie es nicht finden können, sprechen Sie mich in der Schule an oder schreiben Sie mir eine E-Mail mit Nachweis als Schüler/Lehrer an ",
                        children: <TextSpan>[
                          TextSpan(
                              text: "dariotrombello@gmail.com",
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  url_launcher.launch(
                                      "mailto:dariotrombello@gmail.com");
                                }),
                          TextSpan(text: ".")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

          if (snapshot.connectionState == ConnectionState.done &&
              !_isLoggedIn &&
              _welcomePage == 1)
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {
                          setState(() {
                            _teacherSelected = true;
                            _prefs.setBool('teacherSelected', _teacherSelected);
                            _welcomePage = 2;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: _displayHeight * 0.1,
                            ),
                            Text(
                              "Lehrer",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: _displayHeight * 0.04),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {
                          setState(() {
                            _teacherSelected = false;
                            _prefs.setBool('teacherSelected', _teacherSelected);
                            _welcomePage = 2;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.school,
                              size: _displayHeight * 0.1,
                            ),
                            Text(
                              "Schüler",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: _displayHeight * 0.04),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

          if (snapshot.connectionState == ConnectionState.done &&
              !_isLoggedIn &&
              _welcomePage == 2)
            return Center(
              child: Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _passwordController,
                        textAlign: TextAlign.center,
                        obscureText: true,
                        onChanged: (input) => setState(() => _input = input),
                        onSubmitted: (input) => input == _password
                            ? _logIn()
                            : setState(() {
                                _wrongPassword = true;
                                _passwordController.clear();
                              }),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Passwort eingeben',
                            errorText: _wrongPassword
                                ? "Falsches Passwort eingegeben"
                                : null,
                            border: const OutlineInputBorder()),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16.0)),
                      _teacherSelected
                          ? SizedBox(
                              width: 150,
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    hintText: 'Lehrerkürzel',
                                    border: const OutlineInputBorder()),
                                controller: _teacherNameController,
                                onChanged: (value) {
                                  setState(() {
                                    _substitutionFilter = value;
                                    _setSubstitutionFilter();
                                  });
                                },
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0, color: Colors.white38),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: const Text("Nach Klasse filtern"),
                                  value:
                                      _allClasses.contains(_substitutionFilter)
                                          ? _substitutionFilter
                                          : _allClasses[0],
                                  items: _allClasses
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                              value: item, child: Text(item)))
                                      .toList(),
                                  onChanged: (value) => setState(() {
                                    _substitutionFilter = value;
                                    _setSubstitutionFilter();
                                  }),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                      ),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          child: Text("EINLOGGEN"),
                          onPressed: () => _input == _password
                              ? _logIn()
                              : setState(() {
                                  _wrongPassword = true;
                                  _passwordController.clear();
                                }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          if (snapshot.connectionState == ConnectionState.done && _isLoggedIn)
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () => _substitutionPlan,
                  child: ListView.builder(
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
                        if (_currentRow[1].text.trim().isEmpty &&
                            _currentRow[8].text.trim().isNotEmpty) {
                          final int lastSubstitution = _classes
                              .lastIndexWhere((_class) => _class.isNotEmpty);
                          _substitutionInformation[lastSubstitution] =
                              _substitutionInformation[lastSubstitution] +
                                  " " +
                                  _currentRow[8].text.trim();
                        } else {
                          _classes.add(_currentRow[0].text.trim());
                          _hours.add(_currentRow[1].text.trim());
                          _subjects.add(_currentRow[2].text.trim());
                          _substitutionTeachers.add(
                              _currentRow[3].text.trim().replaceFirst("+", ""));
                          _teachers.add(_currentRow[4].text.trim());
                          _substitutionTypes.add(_currentRow[5].text.trim());
                          _substitutionSpan.add(_currentRow[6].text.trim());
                          _rooms.add(_currentRow[7]
                              .text
                              .trim()
                              .replaceFirst("---", ""));
                          _substitutionInformation
                              .add(_currentRow[8].text.trim());
                        }
                      }
                      if (_substitutionFilter == "Alle Klassen anzeigen" &&
                          _hours.indexWhere((hour) => hour.isNotEmpty) != -1)
                        _noSubstitutionsAvailable = false;
                      else if (!_teacherSelected &&
                          _classes.contains(_substitutionFilter))
                        _noSubstitutionsAvailable = false;
                      else if (_teacherSelected &&
                              _teachers.contains(_substitutionFilter) ||
                          _teacherSelected &&
                              _substitutionTeachers
                                  .contains(_substitutionFilter))
                        _noSubstitutionsAvailable = false;
                      else
                        _noSubstitutionsAvailable = true;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 12.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _dayList[index],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          _noSubstitutionsAvailable
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
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
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _classes.length,
                                  itemBuilder: (context, index2) {
                                    bool _hideElement = false;
                                    if (_substitutionFilter ==
                                        "Alle Klassen anzeigen") {
                                      _hideElement = false;
                                    } else if (
                                        // Gibt es einen besseren Weg, von Untis zusammengesetzte
                                        // Klassen wie 7abcd8abc wieder zu trennen?
                                        _classes[index2]
                                                .startsWith(RegExp(r'^\d+')) &&
                                            _substitutionFilter
                                                .startsWith(RegExp(r'^\d+')) &&
                                            _classes[index2].substring(
                                                    _classes[index2].indexOf(
                                                        RegExp(r'^\d+')),
                                                    _classes[index2].lastIndexOf(
                                                            RegExp(r'^\d+')) +
                                                        1) ==
                                                _substitutionFilter.substring(
                                                    _substitutionFilter.indexOf(
                                                        RegExp(r'^\d+')),
                                                    _substitutionFilter
                                                            .lastIndexOf(RegExp(
                                                                r'^\d+')) +
                                                        1)) {
                                      _classes[index2]
                                              .substring(_classes[index2]
                                                  .indexOf(RegExp('[a-zA-Z]')))
                                              .contains(
                                                  _substitutionFilter.substring(
                                                _substitutionFilter.indexOf(
                                                    RegExp('[a-zA-Z]')),
                                              ))
                                          ? _hideElement = false
                                          : _hideElement = true;
                                    } else if (!_teacherSelected &&
                                            _classes[index2] ==
                                                _substitutionFilter ||
                                        _teacherSelected &&
                                            _teachers[index2] ==
                                                _substitutionFilter ||
                                        _teacherSelected &&
                                            _substitutionTeachers[index2] ==
                                                _substitutionFilter) {
                                      _hideElement = false;
                                    } else {
                                      _hideElement = true;
                                    }

                                    MaterialColor _substitutionTypeColor() {
                                      switch (_substitutionTypes[index2]) {
                                        case "Betreuung":
                                          return Colors.indigo;
                                        case "eigenv. Arb.":
                                          return Colors.purple;
                                        case "Entfall":
                                          return Colors.red;
                                        case "Raum-Vtr.":
                                          return Colors.green;
                                        default:
                                          return Colors.blue;
                                      }
                                    }

                                    return Column(
                                      children: <Widget>[
                                        _hideElement
                                            ? Container()
                                            : Card(
                                                color: _substitutionTypeColor(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                          leading: Text(
                                                            _hours[index2],
                                                            style: TextStyle(
                                                                fontSize: 28.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          title: Text(
                                                            _substitutionTypes[
                                                                index2],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          subtitle: Wrap(
                                                            children: <Widget>[
                                                              RichText(
                                                                text: TextSpan(
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white70),
                                                                  text: _classes[
                                                                      index2],
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text: _subjects[index2].isEmpty ||
                                                                                _classes[index2].isEmpty
                                                                            ? ""
                                                                            : " – "),
                                                                    TextSpan(
                                                                        text: _subjects[
                                                                            index2]),
                                                                    TextSpan(
                                                                        text: _substitutionTeachers[index2].isEmpty
                                                                            ? ""
                                                                            : " (${_substitutionTeachers[index2]}"),
                                                                    TextSpan(
                                                                        text: _substitutionTeachers[index2].isNotEmpty &&
                                                                                _teachers[index2].isEmpty
                                                                            ? ")"
                                                                            : ""),
                                                                    TextSpan(
                                                                        text: _substitutionTeachers[index2].isNotEmpty &&
                                                                                _teachers[index2].isNotEmpty &&
                                                                                _substitutionTeachers[index2] != _teachers[index2]
                                                                            ? " statt "
                                                                            : ""),
                                                                    TextSpan(
                                                                        text: _substitutionTeachers[index2].isEmpty &&
                                                                                _teachers[index2].isNotEmpty
                                                                            ? " ("
                                                                            : ""),
                                                                    TextSpan(
                                                                        text: _teachers[index2] == _substitutionTeachers[index2]
                                                                            ? ""
                                                                            : _teachers[
                                                                                index2],
                                                                        style:
                                                                            TextStyle(
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        )),
                                                                    TextSpan(
                                                                        text: _teachers[index2].isNotEmpty
                                                                            ? ")"
                                                                            : ""),
                                                                    TextSpan(
                                                                        text: _rooms[index2].isEmpty
                                                                            ? ""
                                                                            : " in " +
                                                                                _rooms[index2]),
                                                                    TextSpan(
                                                                        text: _substitutionInformation[index2].isEmpty
                                                                            ? ""
                                                                            : " – ${_substitutionInformation[index2]}"),
                                                                    TextSpan(
                                                                        text: _substitutionSpan[index2].isEmpty
                                                                            ? ""
                                                                            : " – ${_substitutionSpan[index2]}")
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        _substitutionDays.last ==
                                                    _substitutionDays[index] &&
                                                index2 + 1 == _classes.length
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
                ),
                RefreshIndicator(
                  onRefresh: () => _substitutionPlan,
                  child: ListView.builder(
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
                            physics: NeverScrollableScrollPhysics(),
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
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        _news[index2],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  _newsDays.last == _newsDays[index] &&
                                          index2 + 1 ==
                                              _newsDays[index]
                                                      .querySelectorAll("tr")
                                                      .length -
                                                  1
                                      ? Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
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
                ),
              ],
            );
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
