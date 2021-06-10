import 'dart:io';

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
        ),
      ),
      onPressed: () async {
        _showDialog(context);
      },
    );
  }

  //Dialog wyswietlany przy zamykaniu aplikacji
  _showDialog(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      builder: (_) => new AlertDialog(
        title: const Text(
          "Czy na pewno chcesz zamknąć aplikacje?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Zamknij',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () => exit(0),
          ),
          FlatButton(
            child: const Text(
              'Anuluj',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          )
        ],
      ),
    );
  }
}
