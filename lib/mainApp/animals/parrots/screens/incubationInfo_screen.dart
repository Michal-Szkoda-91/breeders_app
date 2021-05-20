import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncubationInformationScreen extends StatefulWidget {
  static const String routeName = "/IncubationInformationScreen";

  @override
  _IncubationInformationScreenState createState() =>
      _IncubationInformationScreenState();
}

class _IncubationInformationScreenState
    extends State<IncubationInformationScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 30,
          child: AutoSizeText(
            'Aktywne Inkubacje',
            maxLines: 1,
          ),
        ),
      ),
      body: MainBackground(
        child: Center(
          child: Text("hej"),
        ),
      ),
    );
  }
}
