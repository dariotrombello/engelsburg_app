import 'package:engelsburg_app/error_card.dart';
import 'package:engelsburg_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class SubstitutionPlanPage extends StatefulWidget {
  @override
  SubstitutionPlanPageState createState() => SubstitutionPlanPageState();
}

class SubstitutionPlanPageState extends State<SubstitutionPlanPage>
    with SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;
  bool _noSubstitutionsAvailable = false;
  bool _wrongPassword = false;
  final List<dom.Element> _newsDays = [];
  final List<dom.Element> _substitutionDays = [];
  final List<String> _dayList = [];
  List<String> _allClasses = [];
  String _input;
  String _lastChanged = '';
  String _substitutionFilter;
  final String _password = '@Vertretung2019';
  TabController _tabController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teacherNameController = TextEditingController();
  Future _substitutionPlan;
  int _welcomePage = 0;
  final _prefs = SharedPrefs.instance;
  bool _teacherSelected;

  @override
  void initState() {
    super.initState();
    _substitutionPlan = _substitutionPlanInit();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future _checkLogin() async {
    setState(() => _isLoggedIn = (_prefs.getBool('isLoggedIn') ?? false) &&
        _prefs.getString('substitutionFilter') != null);
    await _prefs.setBool('isLoggedIn', _isLoggedIn);
  }

  Future _logIn() async {
    setState(
        () => _isLoggedIn = _prefs.getString('substitutionFilter') != null);
    await _prefs.setBool('isLoggedIn', true);
  }

  Future _getSubstitutionFilter() async {
    _teacherSelected = _prefs.getBool('teacherSelected');
    _substitutionFilter =
        _prefs.getString('substitutionFilter') ?? 'Alle Klassen anzeigen';
    await _prefs.setString('substitutionFilter', _substitutionFilter);
  }

  Future _setSubstitutionFilter() async {
    await _prefs.setString('substitutionFilter', _substitutionFilter);
  }

  Future _getSubstitutionPlan() async {
    final weekday = DateTime.now().weekday;
    _substitutionDays.clear();
    _newsDays.clear();
    var untisWeeks = <String>[];
    final navbarUrl = Uri.parse(
        'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/frames/navbar.htm');
    final navbarRes = await http.get(navbarUrl);
    final navbarDocument = parse(navbarRes.body);
    final navbarWeeks = weekday >= 5 || weekday == 1
        ? navbarDocument.querySelectorAll('select[name=week] > option')
        : [navbarDocument.querySelector('select[name=week] > option')];
    final info = navbarDocument.querySelector('span.description').text;
    _lastChanged = info.substring(info.indexOf('Stand:')).trim();

    for (var i = 0; i < navbarWeeks.length; i++) {
      untisWeeks.add(navbarWeeks[i].attributes['value']);
      final substitutionTableUrl = Uri.parse(
          'https://engelsburg.smmp.de/vertretungsplaene/ebg/Stp_Upload/' +
              untisWeeks[i] +
              '/w/w00000.htm');
      final substitutionTable = await http.get(substitutionTableUrl);
      final substitutionTableDocument = parse(substitutionTable.body);
      final _allSubstitutionDays =
          substitutionTableDocument.querySelectorAll('table.subst > tbody');
      final _allTables = substitutionTableDocument.querySelectorAll('table');
      final days = substitutionTableDocument
          .querySelectorAll('#vertretung > p > b, #vertretung > b');

      for (var i = 0; i < _allSubstitutionDays.length; i++) {
        if (_allSubstitutionDays[i].querySelector('tr.list > td') != null &&
            _allSubstitutionDays[i].querySelector('tr.list > td').text !=
                'Vertretungen sind nicht freigegeben') {
          _dayList.add(days[i].text);
          _substitutionDays.add(_allSubstitutionDays[i]);
        }
      }

      for (var i = 0; i < _allTables.length; i++) {
        if (_allTables[i].attributes['bgcolor'] == '#F4F4F4') {
          _newsDays.add(_allTables[i].querySelector('tbody'));
        }
      }
    }

    // Klassenliste aus dem Javascript-Element der Seite in eine List<String> konvertieren
    _allClasses = navbarRes.body
        .substring(navbarRes.body.indexOf('var classes = ['),
            navbarRes.body.indexOf('];'))
        .trim()
        .replaceFirst('var classes = [', '')
        .replaceFirst('];', '')
        .replaceAll('\"', '')
        .split(',');
    _allClasses.insert(0, 'Alle Klassen anzeigen');
    await _prefs.setStringList('allClasses', _allClasses);
  }

  Future _substitutionPlanInit() async {
    await _checkLogin();
    await _getSubstitutionFilter();
    await _getSubstitutionPlan();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _isLoggedIn
          ? TabBar(
              // TEMP: Umgehung eines Bugs, der im hellen Modus der App auftritt
              labelColor: Theme.of(context).textTheme.bodyText1.color,
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Vertretungsplan',
                  ),
                ),
                Tab(
                  child: Text(
                    'Nachrichten',
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
              _welcomePage == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => setState(() => _welcomePage = 1),
                child: Icon(Icons.arrow_forward),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/images/applogo.png',
                        height: 128.0,
                      ),
                    ),
                    Text(
                      'Willkommen beim Vertretungsplan\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                        text:
                            'Um sich anzumelden, wird das Passwort benötigt, das auch für den Vertretungsplan auf der Internetseite der Engelsburg verwendet wird. Falls Sie es nicht finden können, sprechen Sie mich in der Schule an oder schreiben Sie mir eine E-Mail mit Nachweis als Schüler/Lehrer an ',
                        children: <TextSpan>[
                          TextSpan(
                              text: 'info@dariotrombello.com',
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  url_launcher
                                      .launch('mailto:info@dariotrombello.com');
                                }),
                          TextSpan(text: '.')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done &&
              !_isLoggedIn &&
              _welcomePage == 1) {
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
                              size: 64.0,
                            ),
                            Text(
                              'Lehrer',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 32.0),
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
                              size: 64.0,
                            ),
                            Text(
                              'Schüler',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 32.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done &&
              !_isLoggedIn &&
              _welcomePage == 2) {
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
                                ? 'Falsches Passwort eingegeben'
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
                                    border: OutlineInputBorder()),
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
                                          width: 1.0, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: const Text('Nach Klasse filtern'),
                                  value:
                                      _allClasses.contains(_substitutionFilter)
                                          ? _substitutionFilter
                                          : _allClasses[0],
                                  items: _allClasses
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item.toString())))
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
                        width: width,
                        child: ElevatedButton(
                          onPressed: () => _input == _password
                              ? _logIn()
                              : setState(() {
                                  _wrongPassword = true;
                                  _passwordController.clear();
                                }),
                          child: Text('EINLOGGEN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done && _isLoggedIn) {
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () async => setState(
                      () => _substitutionPlan = _substitutionPlanInit()),
                  child: ListView.builder(
                    itemCount: _substitutionDays.length,
                    itemBuilder: (context, index) {
                      final _currentColumns = _substitutionDays[index]
                          .querySelectorAll('tr.list')
                          .sublist(1);
                      final _classes = <String>[];
                      final _hours = <String>[];
                      final _rooms = <String>[];
                      final _subjects = <String>[];
                      final _substitutionInformation = <String>[];
                      final _substitutionSpan = <String>[];
                      final _substitutionTeachers = <String>[];
                      final _substitutionTypes = <String>[];
                      final _teachers = <String>[];

                      for (var i = 0; i < _currentColumns.length; i++) {
                        final _currentRow =
                            _currentColumns[i].querySelectorAll('td');
                        if (_currentRow[1].text.trim().isEmpty &&
                            _currentRow[8].text.trim().isNotEmpty) {
                          final lastSubstitution = _classes
                              .lastIndexWhere((_class) => _class.isNotEmpty);
                          _substitutionInformation[lastSubstitution] =
                              _substitutionInformation[lastSubstitution] +
                                  ' ' +
                                  _currentRow[8].text.trim();
                        } else {
                          _classes.add(_currentRow[0].text.trim());
                          _hours.add(_currentRow[1].text.trim());
                          _subjects.add(_currentRow[2].text.trim());
                          _substitutionTeachers.add(
                              _currentRow[3].text.trim().replaceFirst('+', ''));
                          _teachers.add(_currentRow[4].text.trim());
                          _substitutionTypes.add(_currentRow[5].text.trim());
                          _substitutionSpan.add(_currentRow[6].text.trim());
                          _rooms.add(_currentRow[7]
                              .text
                              .trim()
                              .replaceFirst('---', ''));
                          _substitutionInformation
                              .add(_currentRow[8].text.trim());
                        }
                      }
                      if (_substitutionFilter == 'Alle Klassen anzeigen' &&
                          _hours.indexWhere((hour) => hour.isNotEmpty) != -1) {
                        _noSubstitutionsAvailable = false;
                      } else if (!_teacherSelected &&
                          _classes.contains(_substitutionFilter)) {
                        _noSubstitutionsAvailable = false;
                      } else if (_teacherSelected &&
                              _teachers.contains(_substitutionFilter) ||
                          _teacherSelected &&
                              _substitutionTeachers
                                  .contains(_substitutionFilter)) {
                        _noSubstitutionsAvailable = false;
                      } else {
                        _noSubstitutionsAvailable = true;
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 12.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _dayList[index].toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          _noSubstitutionsAvailable
                              ? SizedBox(
                                  width: width,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Center(
                                        child: Text(
                                          'Keine Vertretungen für diesen Tag',
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
                                    var _hideElement = false;
                                    if (_substitutionFilter ==
                                        'Alle Klassen anzeigen') {
                                      _hideElement = false;
                                    } else if (
                                        // Gibt es einen besseren Weg, um von Untis zusammengesetzte
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
                                        case 'Betreuung':
                                          return Colors.indigo;
                                        case 'eigenv. Arb.':
                                          return Colors.purple;
                                        case 'Entfall':
                                          return Colors.red;
                                        case 'Raum-Vtr.':
                                          return Colors.green;
                                        default:
                                          return Colors.blue;
                                      }
                                    }

                                    return Column(
                                      children: <Widget>[
                                        if (!_hideElement)
                                          Card(
                                            color: _substitutionTypeColor(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                      leading: Text(
                                                        _hours[index2]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 28.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      title: Text(
                                                        _substitutionTypes[
                                                                index2]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      subtitle: Wrap(
                                                        children: <Widget>[
                                                          RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70),
                                                              text: _classes[
                                                                      index2]
                                                                  .toString(),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: _subjects[index2].toString().isEmpty ||
                                                                            _classes[index2].toString().isEmpty
                                                                        ? ''
                                                                        : ' – '),
                                                                TextSpan(
                                                                    text: _subjects[
                                                                            index2]
                                                                        .toString()),
                                                                TextSpan(
                                                                    text: _substitutionTeachers[index2]
                                                                            .toString()
                                                                            .isEmpty
                                                                        ? ''
                                                                        : ' (${_substitutionTeachers[index2]}'),
                                                                TextSpan(
                                                                    text: _substitutionTeachers[index2].toString().isNotEmpty &&
                                                                            _teachers[index2].toString().isEmpty
                                                                        ? ')'
                                                                        : ''),
                                                                TextSpan(
                                                                    text: _substitutionTeachers[index2].toString().isNotEmpty &&
                                                                            _teachers[index2]
                                                                                .toString()
                                                                                .isNotEmpty &&
                                                                            _substitutionTeachers[index2].toString() !=
                                                                                _teachers[index2].toString()
                                                                        ? ' statt '
                                                                        : ''),
                                                                TextSpan(
                                                                    text: _substitutionTeachers[index2].toString().isEmpty &&
                                                                            _teachers[index2].toString().isNotEmpty
                                                                        ? ' ('
                                                                        : ''),
                                                                TextSpan(
                                                                    text: _teachers[index2].toString() ==
                                                                            _substitutionTeachers[index2]
                                                                                .toString()
                                                                        ? ''
                                                                        : _teachers[
                                                                            index2],
                                                                    style:
                                                                        TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                    )),
                                                                TextSpan(
                                                                    text: _teachers[index2]
                                                                            .toString()
                                                                            .isNotEmpty
                                                                        ? ')'
                                                                        : ''),
                                                                TextSpan(
                                                                    text: _rooms[index2]
                                                                            .toString()
                                                                            .isEmpty
                                                                        ? ''
                                                                        : ' in ' +
                                                                            _rooms[index2]),
                                                                TextSpan(
                                                                    text: _substitutionInformation[index2]
                                                                            .toString()
                                                                            .isEmpty
                                                                        ? ''
                                                                        : ' – ${_substitutionInformation[index2].toString()}'),
                                                                TextSpan(
                                                                    text: _substitutionSpan[index2]
                                                                            .toString()
                                                                            .isEmpty
                                                                        ? ''
                                                                        : ' – ${_substitutionSpan[index2].toString()}')
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (_substitutionDays.last ==
                                                _substitutionDays[index] &&
                                            index2 + 1 == _classes.length)
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child:
                                                  Text(_lastChanged.toString()))
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
                  onRefresh: () async => setState(
                      () => _substitutionPlan = _substitutionPlanInit()),
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
                                _dayList[index].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          ..._newsDays[index]
                              .querySelectorAll('tr')
                              .sublist(1)
                              .map((newsDay) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        newsDay.text.toString(),
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                  if (_newsDays.last == _newsDays[index] &&
                                      _newsDays[index]
                                              .querySelectorAll('tr')
                                              .sublist(1)
                                              .last ==
                                          newsDay)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(_lastChanged.toString()),
                                      ),
                                    )
                                ]);
                          }).toList(),

                          // ListView.builder(
                          //   shrinkWrap: true,
                          //   physics: NeverScrollableScrollPhysics(),
                          //   itemCount:
                          //       _newsDays[index].querySelectorAll('tr').length -
                          //           1,
                          //   itemBuilder: (context, index2) {
                          //     var _news = <String>[];
                          //     for (var _newsDay in _newsDays[index]
                          //         .querySelectorAll('tr')
                          //         .sublist(1)) {
                          //       _news.add(_newsDay.text);
                          //     }
                          //     return Column(
                          //       crossAxisAlignment: CrossAxisAlignment.stretch,
                          //       children: <Widget>[
                          //         Card(
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(16.0),
                          //             child: Text(
                          //               _news[index2].toString(),
                          //               style: TextStyle(fontSize: 16.0),
                          //             ),
                          //           ),
                          //         ),
                          //         if (_newsDays.last == _newsDays[index] &&
                          //             index2 + 1 ==
                          //                 _newsDays[index]
                          //                         .querySelectorAll('tr')
                          //                         .length -
                          //                     1)
                          //           Center(
                          //               child: Padding(
                          //                   padding: const EdgeInsets.all(6.0),
                          //                   child:
                          //                       Text(_lastChanged.toString())))
                          //       ],
                          //     );
                          //   },
                          // ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return ErrorCard();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
