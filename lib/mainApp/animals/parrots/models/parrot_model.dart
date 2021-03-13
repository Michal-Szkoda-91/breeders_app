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
  List<String> _raceList = [];

  List<Parrot> get getParrotList {
    return [..._parrotList];
  }

  List<String> get getRaceList {
    return [..._raceList];
  }

  Future<dynamic> createParrotCollection({
    String uid,
    Parrot parrot,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);
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
  }

//creating parrots list
  Future<dynamic> readParrotsList({String uid, String parrotRace}) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    _parrotList.clear();

    await collectionReference
        .doc("Hodowla Papug")
        .collection(parrotRace)
        .doc("Birds")
        .get()
        .then((data) => {
              data.data().forEach((ringNumber, val) {
                _parrotList.add(
                  Parrot(
                    race: parrotRace,
                    ringNumber: ringNumber,
                    color: val['Colors'],
                    cageNumber: val['Cage number'],
                    fission: val['Fission'],
                    notes: val['Notes'],
                    sex: val['Sex'],
                  ),
                );
              }),
              print("_________" + _parrotList.toString())
            });
    notifyListeners();
  }

  //read race collection
  Future<dynamic> readActiveParrotRace({String uid}) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);
    ParrotsRace parrotsRace = ParrotsRace();
    _raceList.clear();

    for (var i = 0; i < parrotsRace.parrotsRaceList.length; i++) {
      await collectionReference
          .doc("Hodowla Papug")
          .collection(parrotsRace.parrotsRaceList[i]['name'])
          .limit(1)
          .get()
          .then((val) {
        if (val.size > 0) {
          _raceList.add(parrotsRace.parrotsRaceList[i]['name']);
        }
      });
    }
    notifyListeners();
  }
}
