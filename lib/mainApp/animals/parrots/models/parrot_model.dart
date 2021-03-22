import 'package:breeders_app/mainApp/animals/parrots/models/parrotsRace_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Parrot {
  final String race;
  final String ringNumber;
  final String color;
  final String fission;
  final String cageNumber;
  final String sex;
  final String notes;

  Parrot({
    this.race,
    this.ringNumber,
    this.color,
    this.fission,
    this.cageNumber,
    this.sex,
    this.notes,
  });
}

class ParrotsList with ChangeNotifier {
  List<Parrot> _parrotList = [];

  List<Parrot> get getParrotList {
    return [..._parrotList];
  }

  Future<dynamic> createParrotCollection({
    String uid,
    Parrot parrot,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    await collectionReference.doc('Hodowla Papug').set({"exist": "true"});
    //create collection if not exist
    await collectionReference
        .doc('Hodowla Papug')
        .collection(parrot.race)
        .doc("Birds")
        .set({
      "${parrot.ringNumber}": {
        "Race Name": "${parrot.race}",
        "Colors": "${parrot.color}",
        "Fission": "${parrot.fission}",
        "Sex": "${parrot.sex}",
        "Cage number": "${parrot.cageNumber}",
        "Notes": "${parrot.notes}",
      },
    }, SetOptions(merge: true));
    readParrotsList(uid: uid);
  }

//creating parrots list
  Future<void> readParrotsList({String uid}) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    _parrotList.clear();
    ParrotsRace parrotsRace = ParrotsRace();
    for (var i = 0; i < parrotsRace.parrotsNameList.length; i++) {
      //checking if document exist
      var snapshot = await collectionReference
          .doc("Hodowla Papug")
          .collection(parrotsRace.parrotsNameList[i])
          .get();
      if (snapshot.docs.length != 0) {
        //creating parrot
        await collectionReference
            .doc("Hodowla Papug")
            .collection(parrotsRace.parrotsNameList[i])
            .doc("Birds")
            .get()
            .then((querySnapshot) {
          querySnapshot.data().forEach((name, val) {
            if (name != null) {
              _parrotList.add(
                Parrot(
                  race: val['Race Name'],
                  ringNumber: name,
                  color: val['Colors'],
                  cageNumber: val['Cage number'],
                  fission: val['Fission'],
                  notes: val['Notes'],
                  sex: val['Sex'],
                ),
              );
            }
          });
        });
      }
    }
    notifyListeners();
  }

  Future<void> deleteRaceList(String uid, String raceName) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    await breedCollection
        .doc("Hodowla Papug")
        .collection(raceName)
        .doc("Birds")
        .delete()
        .then((success) {
      print("succes");
    }).catchError((err) {
      print(err);
    });
  }
}
