import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../../services/auth.dart';
import '../../main.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    required this.auth,
  });

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        icon: Icon(
          Icons.logout,
          color: Theme.of(context).textSelectionTheme.selectionColor,
          size: 30,
        ),
        label: Text(
          'Wyloguj',
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
            fontSize: MediaQuery.of(context).size.width < 340 ? 10 : 16,
          ),
        ),
        onPressed: () async {
          _showDialog(context);
        });
  }

  //Dialog wyswietlany przy wylogowywani aplikacji
  _showDialog(BuildContext dialogContext) {
    showAnimatedDialog(
      context: dialogContext,
      builder: (ctx) => new AlertDialog(
        title: const Text(
          "Czy na pewno chcesz wylogować się z aplikacji?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).backgroundColor,
            ),
            child: AutoSizeText(
              'Wyloguj',
              style: TextStyle(
                color:
                    Theme.of(dialogContext).textSelectionTheme.selectionColor,
              ),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await auth.signOut();
              Navigator.pushAndRemoveUntil(
                dialogContext,
                MaterialPageRoute(
                  builder: ((context) => MyApp()),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).backgroundColor,
            ),
            child: AutoSizeText(
              'Anuluj',
              style: TextStyle(
                color:
                    Theme.of(dialogContext).textSelectionTheme.selectionColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
            },
          )
        ],
      ),
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 2),
    );
  }
}
