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
      icon: Icon(
        Icons.logout,
        color: Theme.of(context).textSelectionColor,
        size: 30,
      ),
      label: Text(
        'Wyloguj',
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        await _auth.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: ((context) => MyApp()),
          ),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
