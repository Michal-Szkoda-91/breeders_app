import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                child: CircularProgressIndicator(),
              ),
            );
          default:
            _createParrot(snapshot);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createdInfoParrotRow(context, "Kolor:", _createdParrot.color),
                _createdInfoParrotRow(
                    context, "Rozsczepienie:", _createdParrot.fission),
                _createdInfoParrotRow(
                    context, "Nr klatki:", _createdParrot.cageNumber),
                _createdInfoParrotRow(
                    context, "Notatki:", _createdParrot.notes),
                _createdInfoParrotRow(
                    context, "Nr partnera:", _createdParrot.pairRingNumber),
              ],
            );
        }
      },
    );
  }

  Widget _createdInfoParrotRow(
      BuildContext context, String title, String contet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          style: TextStyle(
            color: Theme.of(context).hintColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        AutoSizeText(
          contet,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        Divider(
          color: Theme.of(context).textSelectionColor,
        )
      ],
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
