import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import '../privacy_politicy/policy_model.dart';
import '../authentication/verification_screen.dart';
import '../globalWidgets/mainBackground.dart';
import '../main.dart';

class PolitycyPrivacyScreen extends StatelessWidget {
  static const String routeName = "/PolitycyPrivacyScreen";

  const PolitycyPrivacyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PolicyModel policyModel = PolicyModel();
    ScrollController _rrectController = ScrollController();

    return Scaffold(
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
              color: Theme.of(context).textSelectionColor,
              child: DraggableScrollbar.rrect(
                controller: _rrectController,
                heightScrollThumb: 100,
                backgroundColor: Theme.of(context).accentColor,
                child: SingleChildScrollView(
                  controller: _rrectController,
                  child: Html(
                    data: policyModel.policy,
                    onLinkTap: (url) {
                      launch(url);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Rezygnuję",
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
