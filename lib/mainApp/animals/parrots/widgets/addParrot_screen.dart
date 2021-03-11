import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';

class AddParrotScreen extends StatefulWidget {
  static const String routeName = "/AddParrotScreen";

  final String name;

  AddParrotScreen({Key key, this.name}) : super(key: key);

  @override
  _RaceListScreenState createState() => _RaceListScreenState();
}

class _RaceListScreenState extends State<AddParrotScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Dodawanie Papugi"),
      ),
      body: MainBackground(
        child: Column(
          children: [
            Text(widget.name),
          ],
        ),
      ),
    );
  }
}
