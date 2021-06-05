import 'dart:async';
import 'dart:io';

import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/main.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationEmailScreen extends StatefulWidget {
  static const String routeName = "/VerificationEmailScreen";

  VerificationEmailScreen({Key key}) : super(key: key);

  @override
  _VerificationEmailScreenState createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  final auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();

  User user;
  Timer timer;
  @override
  void initState() {
    checkEmail();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmail();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weryfikacja Email"),
      ),
      body: MainBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 40,
              ),
              child: Text(
                "Sprawdź pocztę i potwierdź utworzenie konta, wiadomość może być również w folderze SPAM",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textSelectionColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
            Divider(
              color: Theme.of(context).textSelectionColor,
            ),
            FlatButton.icon(
              label: Text(
                "Wyślij email ponownie",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textSelectionColor,
                ),
                textAlign: TextAlign.center,
              ),
              icon: Icon(
                Icons.email_outlined,
                color: Theme.of(context).textSelectionColor,
                size: 33,
              ),
              onPressed: _sendEmailAgain,
            ),
            Divider(
              color: Theme.of(context).textSelectionColor,
            ),
            FlatButton.icon(
              label: Text(
                "Ekran logowania",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textSelectionColor,
                ),
                textAlign: TextAlign.center,
              ),
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).textSelectionColor,
                size: 33,
              ),
              onPressed: _returnLoginScreen,
            ),
            Divider(
              color: Theme.of(context).textSelectionColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmail() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ParrotsRaceListScreen(),
        ),
      );
    } else
      return;
  }

  void _sendEmailAgain() async {
    user = auth.currentUser;
    await user.sendEmailVerification().then((_) {
      _globalMethods.showMaterialDialog(context, "Wysłano wiadomość ponownie");
    });
  }

  void _returnLoginScreen() async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: ((context) => MyApp()),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
