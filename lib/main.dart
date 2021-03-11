import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mainApp/animals/parrots/widgets/addParrot_screen.dart';
import 'mainApp/screens/race_list_screen.dart';
import 'mainApp/models/breedings_model.dart';
import 'fireInitialization/initWidget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BreedingsList(),
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
          RaceListScreen.routeName: (ctx) => RaceListScreen(),
          AddParrotScreen.routeName: (ctx) => AddParrotScreen(),
        },
      ),
    );
  }
}
