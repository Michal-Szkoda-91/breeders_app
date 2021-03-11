import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:breeders_app/globalWidgets/mainBackground.dart';
import '../animals/parrots/widgets/parrots_race_AddDropdownButton.dart';
import '../widgets/custom_drawer.dart';
import '../../services/auth.dart';

class RaceListScreen extends StatefulWidget {
  static const String routeName = "/RaceListScreen";

  final String name;

  RaceListScreen({Key key, this.name}) : super(key: key);

  @override
  _RaceListScreenState createState() => _RaceListScreenState();
}

class _RaceListScreenState extends State<RaceListScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: MainBackground(
        child: Column(
          children: [
            //switch do zmiany papug
            CreateParrotsDropdownButton(),
          ],
        ),
      ),
    );
  }
}
