import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrotsList.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/verification_screen.dart';
import '../globalWidgets/mainBackground.dart';
import '../mainApp/widgets/custom_drawer.dart';
import '../main.dart';

class PolitycyPrivacyScreen extends StatelessWidget {
  static const String routeName = "/PolitycyPrivacyScreen";

  const PolitycyPrivacyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Polityka prywatnosci"),
      ),
      body: MainBackground(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Anuluj",
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                  onPressed: () {
                    _returnLoginScreen(context);
                  },
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Wyrażam zgodę",
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                  onPressed: () {
                    _goToVerificationScreen(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _returnLoginScreen(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: ((context) => MyApp()),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _goToVerificationScreen(BuildContext context) async {
    User loggedUser;
    final auth = FirebaseAuth.instance;
    loggedUser = auth.currentUser;

    loggedUser.emailVerified
        ? Navigator.of(context).pushNamedAndRemoveUntil(
            ParrotsRaceListScreen.routeName,
            (Route<dynamic> route) => false,
          )
        : Navigator.pushNamed(
            context,
            VerificationEmailScreen.routeName,
          );
  }
}