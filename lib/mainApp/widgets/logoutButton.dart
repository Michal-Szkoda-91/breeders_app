import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../main.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key key,
    @required AuthService auth,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        color: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.logout,
          color: Theme.of(context).textSelectionColor,
          size: 30,
        ),
        label: Text(
          'Wyloguj',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        onPressed: () async {
          _showDialog(context);
        });
  }

  //Dialog wyswietlany przy zamykaniu aplikacji
  _showDialog(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      builder: (_) => new AlertDialog(
        title: const Text(
          "Czy na pewno chcesz wylogować się z aplikacji?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Wyloguj',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                dialogContext,
                MaterialPageRoute(
                  builder: ((context) => MyApp()),
                ),
                (Route<dynamic> route) => false,
              );
            },
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
