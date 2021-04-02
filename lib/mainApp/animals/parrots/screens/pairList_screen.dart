import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/pairingParrot_AddDropdownButton.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PairListScreen extends StatefulWidget {
  static const String routeName = "/ParringListScreen";

  final raceName;

  const PairListScreen({this.raceName});

  @override
  _PairListScreenState createState() => _PairListScreenState();
}

class _PairListScreenState extends State<PairListScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;
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
            'Pary: ${widget.raceName}',
            maxLines: 1,
          ),
        ),
      ),
      body: MainBackground(
        child: Column(
          children: [
            CreatePairingParrotDropdownButton(
              raceName: widget.raceName,
            ),
          ],
        ),
      ),
    );
  }
}
