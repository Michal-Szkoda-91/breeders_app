import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'mainApp/animals/parrots/screens/editPair_screen.dart';
import 'authentication/resetPass_screen.dart';
import 'authentication/verification_screen.dart';
import 'mainApp/animals/parrots/screens/addPairParrot_screen.dart';
import 'mainApp/animals/parrots/screens/incubationInfo_screen.dart';
import 'mainApp/animals/parrots/screens/pairList_screen.dart';
import 'mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'mainApp/animals/parrots/screens/parrotsList.dart';
import 'fireInitialization/initWidget.dart';
import 'help/help_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = "/Wrapper";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('pl')],
      debugShowCheckedModeBanner: false,
      title: 'Aplikacja Hodowcy',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue[300],
        textSelectionColor: Colors.white,
        backgroundColor: Colors.blueAccent[200],
        buttonColor: Colors.blue[200],
        hintColor: Colors.grey[400],
        cardColor: Colors.black,
      ),
      home: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: const DecorationImage(
              image: const AssetImage(
                "assets/image/background.jpg",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: InitWidget(),
        ),
      ),
      routes: {
        MyApp.routeName: (ctx) => MyApp(),
        ParrotsRaceListScreen.routeName: (ctx) => ParrotsRaceListScreen(),
        AddParrotScreen.routeName: (ctx) => AddParrotScreen(),
        ParrotsListScreen.routeName: (ctx) => ParrotsListScreen(),
        AddPairScreen.routeName: (ctx) => AddPairScreen(),
        PairListScreen.routeName: (ctx) => PairListScreen(),
        IncubationInformationScreen.routeName: (ctx) =>
            IncubationInformationScreen(),
        VerificationEmailScreen.routeName: (ctx) => VerificationEmailScreen(),
        HelpScreen.routeName: (ctx) => HelpScreen(),
        ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
        EditPairScreen.routeName: (ctx) => EditPairScreen(),
      },
    );
  }
}
