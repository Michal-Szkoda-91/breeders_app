import 'package:flutter/material.dart';

import '../../globalWidgets/imageContainerChinchila.dart';
import '../../services/auth.dart';
import 'incubation_drawer_info.dart';
import 'logoutButton.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
    @required AuthService auth,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const ImageContainerParrotSmall(),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Moja Hodowla Papug",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textSelectionColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 10),
              IncubationInformation(),
              const SizedBox(height: 10),
              const Divider(
                thickness: 2,
              ),
              LogoutButton(auth: _auth),
            ],
          ),
        ),
      ),
    );
  }
}
