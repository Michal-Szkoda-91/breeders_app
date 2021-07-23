import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'fireInitialization/initWidget.dart';
import 'authentication/resetPass_screen.dart';


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
        brightness: Brightness.dark,
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue[300],
        backgroundColor: Colors.blueAccent[200],
        buttonColor: Colors.blue[200],
        hintColor: Colors.grey[400],
        cardColor: Colors.black,
        canvasColor: Colors.white,
        textSelectionTheme:
            TextSelectionThemeData(selectionColor: Colors.white),
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
        ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
      },
    );
  }
}
