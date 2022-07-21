import 'package:engelsburg_app/src/common/substitution_provider.dart';
import 'package:engelsburg_app/src/substitution_plan/models/substitution.dart';
import 'package:engelsburg_app/src/substitution_plan/substitution_plan_service.dart';
import 'package:engelsburg_app/src/substitution_plan/utils/substitution_plan_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../error_card.dart';

class SubstitutionPlanView extends ConsumerStatefulWidget {
  const SubstitutionPlanView({Key? key}) : super(key: key);

  @override
  ConsumerState<SubstitutionPlanView> createState() =>
      _SubstitutionPlanViewState();
}

class _SubstitutionPlanViewState extends ConsumerState<SubstitutionPlanView>
    with AutomaticKeepAliveClientMixin<SubstitutionPlanView> {
  @override
  bool get wantKeepAlive => true;

  final _password = '@Vertretung2019';
  final _passwordController = TextEditingController();
  final _teacherNameController = TextEditingController();
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  late Future<SubstitutionPlanData> _getSubstitutionPlan;

  @override
  void initState() {
    super.initState();
    _getSubstitutionPlan = SubstitutionPlanService.getSubstitutionPlan();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _teacherNameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 350), curve: Curves.easeOutSine);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final substitutionData = ref.watch(substitutionDataProvider);

    return substitutionData.when(
      data: (data) => data.isLoggedIn
          ? DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: TabBar(
                  // TEMP: Umgehung eines Bugs, der im hellen Modus der App auftritt
                  labelColor: Theme.of(context).textTheme.bodyText1!.color,
                  tabs: const <Widget>[
                    Tab(child: Text('Vertretungsplan')),
                    Tab(child: Text('Nachrichten')),
                  ],
                ),
                body: FutureBuilder<SubstitutionPlanData>(
                    future: _getSubstitutionPlan,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final substitutionPlan = snapshot.data!;
                        final substitutionDays =
                            substitutionPlan.substitutionDays;

                        return TabBarView(
                          children: <Widget>[
                            RefreshIndicator(
                                onRefresh: () async {
                                  setState(() {
                                    _getSubstitutionPlan =
                                        SubstitutionPlanService
                                            .getSubstitutionPlan();
                                  });
                                },
                                child: SubstitutionsWidget(
                                  substitutionPlan: substitutionPlan,
                                  width: width,
                                  substitutionDays: substitutionDays,
                                  data: data,
                                )),
                            RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  _getSubstitutionPlan = SubstitutionPlanService
                                      .getSubstitutionPlan();
                                });
                              },
                              child: SubstitutionNewsWidget(
                                  substitutionPlan: substitutionPlan),
                            ),
                          ],
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            )
          : PageView(
              controller: _pageController,
              children: [
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => _goToNextPage(),
                    child: const Icon(Icons.arrow_forward),
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/images/applogo.png',
                          height: 128.0,
                        ),
                      ),
                      const Text(
                        'Willkommen beim Vertretungsplan\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32.0,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              'Damit Sie sich anmelden können, benötigen Sie das Passwort, das auch für den Vertretungsplan auf der Internetseite der Engelsburg verwendet wird. Falls Sie es nicht finden können, sprechen Sie mich in der Schule an oder schreiben Sie eine E-Mail an ',
                          style: TextStyle(
                            // TEMP: Umgehung eines Bugs, der im hellen Modus der App auftritt
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'info@dariotrombello.com',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    url_launcher.launchUrl(Uri.parse(
                                        'mailto:info@dariotrombello.com'));
                                  }),
                            const TextSpan(text: '.')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // enter credentials
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  hintText: 'Passwort eingeben'),
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Passwort darf nicht leer sein';
                                } else if (input != _password) {
                                  return 'Falsches Passwort eingegeben';
                                }
                                return null;
                              },
                            ),
                            const Padding(padding: EdgeInsets.only(top: 16.0)),
                            SizedBox(
                              height: 60,
                              width: width,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ref
                                        .read(substitutionDataProvider.notifier)
                                        .logIn();
                                  }
                                },
                                child: const Text('Anmelden'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      error: (error, stackTrace) => const ErrorCard(),
      loading: () => Container(),
    );
  }
}

class SubstitutionNewsWidget extends StatefulWidget {
  const SubstitutionNewsWidget({
    Key? key,
    required this.substitutionPlan,
  }) : super(key: key);

  final SubstitutionPlanData substitutionPlan;

  @override
  State<SubstitutionNewsWidget> createState() => _SubstitutionNewsWidgetState();
}

class _SubstitutionNewsWidgetState extends State<SubstitutionNewsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: widget.substitutionPlan.substitutionNewsDays.map((newsDay) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  newsDay.day,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            ...newsDay.texts.map((newsDayText) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          newsDayText,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ]);
            }),
            if (newsDay == widget.substitutionPlan.substitutionNewsDays.last)
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  widget.substitutionPlan.lastChanged,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}

class SubstitutionsWidget extends StatefulWidget {
  const SubstitutionsWidget({
    Key? key,
    required this.substitutionPlan,
    required this.width,
    required this.substitutionDays,
    required this.data,
  }) : super(key: key);

  final SubstitutionPlanData substitutionPlan;
  final double width;
  final List<SubstitutionDay> substitutionDays;
  final SubstitutionData data;

  @override
  State<SubstitutionsWidget> createState() => _SubstitutionsWidgetState();
}

class _SubstitutionsWidgetState extends State<SubstitutionsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: widget.substitutionPlan.substitutionDays.map((substitutionDay) {
        final substitutions = substitutionDay.substitutions;
        final filteredSubstitutions =
            SubstitutionPlanService.filterSubstitutions(
                substitutions, widget.data);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  substitutionDay.day,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            if (filteredSubstitutions.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Center(
                    child: Text(
                      'Keine Vertretungen für diesen Tag',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            else
              ...filteredSubstitutions.map(
                (substitution) {
                  return Column(
                    children: <Widget>[
                      Card(
                        color: SubstitutionPlanUtils.getColorBySubstitutionType(
                            substitution.type),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              ListTile(
                                  leading: Text(
                                    substitution.hour,
                                    style: const TextStyle(
                                        fontSize: 28.0, color: Colors.white),
                                  ),
                                  title: Text(
                                    substitution.type,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Wrap(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          text: substitution.className,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: substitution
                                                            .subject.isEmpty ||
                                                        substitution
                                                            .className.isEmpty
                                                    ? ''
                                                    : ' – '),
                                            TextSpan(
                                                text: substitution.subject),
                                            TextSpan(
                                                text: substitution
                                                        .substitutingTeacher
                                                        .isEmpty
                                                    ? ''
                                                    : ' (${substitution.substitutingTeacher}'),
                                            TextSpan(
                                                text: substitution
                                                            .substitutingTeacher
                                                            .isNotEmpty &&
                                                        substitution
                                                            .substitutedTeacher
                                                            .isEmpty
                                                    ? ')'
                                                    : ''),
                                            TextSpan(
                                                text: substitution
                                                            .substitutingTeacher
                                                            .isNotEmpty &&
                                                        substitution
                                                            .substitutedTeacher
                                                            .isNotEmpty &&
                                                        substitution
                                                                .substitutingTeacher !=
                                                            substitution
                                                                .substitutedTeacher
                                                    ? ' statt '
                                                    : ''),
                                            TextSpan(
                                                text: substitution
                                                            .substitutingTeacher
                                                            .isEmpty &&
                                                        substitution
                                                            .substitutedTeacher
                                                            .isNotEmpty
                                                    ? ' ('
                                                    : ''),
                                            TextSpan(
                                                text: substitution
                                                            .substitutedTeacher ==
                                                        substitution
                                                            .substitutingTeacher
                                                    ? ''
                                                    : substitution
                                                        .substitutedTeacher,
                                                style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                )),
                                            TextSpan(
                                                text: substitution
                                                        .substitutedTeacher
                                                        .isNotEmpty
                                                    ? ')'
                                                    : ''),
                                            TextSpan(
                                                text: substitution.room.isEmpty
                                                    ? ''
                                                    : ' in ${substitution.room}'),
                                            TextSpan(
                                                text: substitution.note.isEmpty
                                                    ? ''
                                                    : ' – ${substitution.note}'),
                                            TextSpan(
                                                text: substitution
                                                        .newTime.isEmpty
                                                    ? ''
                                                    : ' – ${substitution.newTime}')
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            if (widget.substitutionDays.last == substitutionDay)
              Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(widget.substitutionPlan.lastChanged,
                      textAlign: TextAlign.center))
          ],
        );
      }).toList(),
    );
  }
}
