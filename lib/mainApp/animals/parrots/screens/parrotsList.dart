import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../advertisement_banner/banner_page.dart';
import '../models/parrot_model.dart';
import '../widgets/create_parrot_card.dart';
import '../../../../globalWidgets/mainBackground.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../../services/auth.dart';

class ParrotsListScreen extends StatefulWidget {
  static const String routeName = "/ParrotsListScreen";

  final raceName;

  const ParrotsListScreen({this.raceName});

  @override
  _ParrotsListScreenState createState() => _ParrotsListScreenState();
}

class _ParrotsListScreenState extends State<ParrotsListScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();

  List<Parrot> _createdParrotList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: CustomDrawer(auth: _auth),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading:
              (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
          title: Text(widget.raceName),
        ),
        body: MainBackground(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(firebaseUser!.uid)
                .doc(widget.raceName)
                .collection("Birds")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Błąd danych');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                default:
                  _createParrotList(snapshot);
                  return Column(
                    children: [
                      _createdParrotList.length == 0
                          ? Text(
                              "Brak Papug",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor,
                              ),
                            )
                          : ParrotCard(createdParrotList: _createdParrotList),
                      const SizedBox(height: 8),
                      BannerPage(),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _createParrotList(AsyncSnapshot<QuerySnapshot> snapshot) {
    _createdParrotList = [];
    snapshot.data!.docs.forEach((val) {
      _createdParrotList.add(Parrot(
        ringNumber: val.id,
        cageNumber: val['Cage number'],
        color: val['Colors'],
        fission: val['Fission'],
        notes: val['Notes'],
        pairRingNumber: val['PairRingNumber'],
        race: widget.raceName,
        sex: val['Sex'],
      ));
    });
  }
}
