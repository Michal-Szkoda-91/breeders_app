import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'parrotDialogInformation/info_parrow_row.dart';
import '../models/parrot_model.dart';

class ParrotDialogInformation extends StatefulWidget {
  final String parrotRing;
  final String parrotRace;

  const ParrotDialogInformation({Key key, this.parrotRing, this.parrotRace})
      : super(key: key);
  @override
  _ParrotDialogInformationState createState() =>
      _ParrotDialogInformationState();
}

class _ParrotDialogInformationState extends State<ParrotDialogInformation> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  Parrot _createdParrot;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(firebaseUser.uid)
          .doc(widget.parrotRace)
          .collection("Birds")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            _createParrot(snapshot);
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoParrowRow(
                      title: "Kolor:",
                      content: _createdParrot.color,
                    ),
                    InfoParrowRow(
                      title: "Rozsczepienie:",
                      content: _createdParrot.fission,
                    ),
                    InfoParrowRow(
                      title: "Nr klatki:",
                      content: _createdParrot.cageNumber,
                    ),
                    InfoParrowRow(
                      title: "Notatki:",
                      content: _createdParrot.notes,
                    ),
                    InfoParrowRow(
                      title: "Nr partnera:",
                      content: _createdParrot.pairRingNumber,
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  void _createParrot(AsyncSnapshot<QuerySnapshot> snapshot) {
    snapshot.data.docs.forEach((val) {
      if (val.id == widget.parrotRing) {
        _createdParrot = Parrot(
          ringNumber: val.id,
          cageNumber: val.data()['Cage number'],
          color: val.data()['Colors'],
          fission: val.data()['Fission'],
          notes: val.data()['Notes'],
          pairRingNumber: val.data()['PairRingNumber'],
          race: widget.parrotRace,
          sex: val.data()['Sex'],
        );
      }
    });
  }
}
