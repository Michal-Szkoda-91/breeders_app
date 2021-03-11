import 'package:flutter/material.dart';

import '../../globalWidgets/imageContainerChinchila.dart';
import '../../services/auth.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
    @required AuthService auth,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            const ImageContainerChinchila(),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "Moja Hodowla",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textSelectionColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              thickness: 2,
            ),
            FlatButton.icon(
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
              },
            )
          ],
        ),
      ),
    );
  }
}
