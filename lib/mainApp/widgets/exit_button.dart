import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      icon: Icon(
        Icons.close,
        color: Theme.of(context).textSelectionTheme.selectionColor,
        size: 30,
      ),
      label: Text(
        'Zamknij',
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
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
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).backgroundColor,
            ),
            child: AutoSizeText(
              'Zamknij',
            ),
            onPressed: () => exit(0),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).backgroundColor,
            ),
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
