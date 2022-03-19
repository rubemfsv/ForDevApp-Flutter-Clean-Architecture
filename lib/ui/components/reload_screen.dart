import 'package:flutter/material.dart';
import '../helpers/i18n/i18n.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  ReloadScreen({@required this.error, @required this.reload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(error,
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        RaisedButton(
          child: Text(R.translations.reloadButtonText),
          onPressed: reload,
        ),
      ]),
    );
  }
}
