import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'authentication/authenticate.dart';
import 'models/user.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';

class Wrapper extends StatelessWidget {
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
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
      return ParrotsRaceListScreen();
    }
  }
}
