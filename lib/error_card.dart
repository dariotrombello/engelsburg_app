import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.error,
              size: 64.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Ein Fehler ist beim Laden der Seite aufgetreten',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
