import 'package:engelsburg_app/src/events/events_service.dart';
import 'package:flutter/material.dart';

import '../error_card.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView>
    with AutomaticKeepAliveClientMixin<EventsView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<List<String>>(
      future: EventsService.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.separated(
              key: const PageStorageKey('events_view_list_view'),
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text(snapshot.data![index].toString().substring(0, 10)),
                  subtitle:
                      Text(snapshot.data![index].toString().substring(12)),
                );
              });
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Icon(
                    Icons.watch_later,
                    size: 64.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Aktuell keine Termine',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const ErrorCard();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
