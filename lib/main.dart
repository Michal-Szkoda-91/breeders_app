import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'mainApp/animals/parrots/screens/parrotsList.dart';
import 'mainApp/models/breedings_model.dart';
import 'fireInitialization/initWidget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = "/Wrapper";
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BreedingsList(),
        ),
        ChangeNotifierProvider(
          create: (_) => ParrotsList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikacja Hodowcy',
        theme: ThemeData(
          primaryColor: Colors.blue[900],
          accentColor: Colors.blue[300],
          textSelectionColor: Colors.white,
          backgroundColor: Colors.blueAccent[200],
          buttonColor: Colors.blue[200],
          hintColor: Colors.grey[500],
        ),
        home: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/background.jpg",
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
        },
      ),
    );
  }
}
