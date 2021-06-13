import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      color: Theme.of(context).primaryColor,
      icon: Icon(
        Icons.close,
        color: Theme.of(context).textSelectionColor,
        size: 30,
      ),
      label: Text(
        'Zamknij',
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: MediaQuery.of(context).size.width < 340 ? 10 : 16,
        ),
      ),
      onPressed: () {
        _showDialog(context);
      },
    );
  }

  //Dialog wyswietlany przy zamykaniu aplikacji
  _showDialog(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      builder: (ctx) => new AlertDialog(
        title: const Text(
          "Czy na pewno chcesz zamknąć aplikacje?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: AutoSizeText(
              'Zamknij',
            ),
            onPressed: () => exit(0),
          ),
          FlatButton(
            child: AutoSizeText(
              'Anuluj',
            ),
            onPressed: () {
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }
}
