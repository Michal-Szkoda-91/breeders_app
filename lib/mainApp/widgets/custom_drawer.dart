import 'package:flutter/material.dart';

import '../../globalWidgets/imageContainerChinchila.dart';
import '../../services/auth.dart';
import 'incubation_drawer_info.dart';
import 'helpButton.dart';
import 'logoutButton.dart';
import 'policyButton.dart';
import 'exit_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
    @required AuthService auth,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width.toString());
    return Container(
      width: MediaQuery.of(context).size.width < 340
          ? MediaQuery.of(context).size.width * 0.85
          : MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
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
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              IncubationInformation(),
              const SizedBox(height: 10),
              const Divider(thickness: 2),
              Spacer(),
              const Divider(thickness: 2),
              HelpButton(),
              PolicyButton(),
              const Divider(thickness: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LogoutButton(auth: _auth),
                    ExitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
