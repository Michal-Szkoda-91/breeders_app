import 'dart:async';
import 'dart:io';

import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/main.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
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
        actions: [
          FlatButton(
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => _showDialog(context),
          ),
        ],
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
              child: CircularProgressIndicator(),
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () async {
                await auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => MyApp()),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            )
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

//Dialog wyswietlany przy zamykaniu aplikacji
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: const Text("Czy na pewno chcesz zamknąć aplikacje?"),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Zamknij',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () => exit(0),
          ),
          FlatButton(
            child: const Text(
              'Anuluj',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
