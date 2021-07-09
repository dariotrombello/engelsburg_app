import 'package:engelsburg_app/constants/app_constants.dart';
import 'package:engelsburg_app/models/engelsburg_api/events.dart';
import 'package:engelsburg_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatelessWidget {
  EventsPage({Key? key}) : super(key: key);

  final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.events)),
      body: FutureBuilder<Events>(
        future: ApiService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final events = snapshot.data;
            return ListView.separated(
              itemBuilder: (context, index) {
                final event = events!.events[index];
                return ListTile(
                  title: Text(event.title.toString()),
                  subtitle: event.date == null
                      ? null
                      : Text(_dateFormat.format(event.date as DateTime)),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 0);
              },
              itemCount: events!.events.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
