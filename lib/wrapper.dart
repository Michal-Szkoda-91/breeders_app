import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'authentication/authenticate.dart';
import 'models/user.dart';

import 'authentication/verification_screen.dart';
import 'mainApp/animals/parrots/screens/parrot_race_list_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  User loggedUser;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    loggedUser = auth.currentUser;
    final user = Provider.of<UserLogged>(context);
    if (user == null) {
      return FutureBuilder(
        // Initialize FlutterFire:
        future: _initGoogleMobileAds(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center();
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Authenticate();
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return Center();
        },
      );
    } else {
      return loggedUser.emailVerified
          ? ParrotsRaceListScreen()
          : VerificationEmailScreen();
    }
  }
}
