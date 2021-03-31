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
  final String pairRingNumber;

  Parrot({
    this.race,
    this.ringNumber,
    this.color,
    this.fission,
    this.cageNumber,
    this.sex,
    this.notes,
    this.pairRingNumber,
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

    await collectionReference
        .doc(parrot.race)
        .collection("Birds")
        .doc(parrot.ringNumber)
        .set({
      "Race Name": "${parrot.race}",
      "Colors": "${parrot.color}",
      "Fission": "${parrot.fission}",
      "Sex": "${parrot.sex}",
      "Cage number": "${parrot.cageNumber}",
      "Notes": "${parrot.notes}",
      "PairRingNumber": "brak",
    }, SetOptions(merge: true)).then((_) {
      _parrotList.add(
        Parrot(
          race: parrot.race,
          ringNumber: parrot.ringNumber,
          color: parrot.color,
          cageNumber: parrot.cageNumber,
          fission: parrot.fission,
          notes: parrot.notes,
          sex: parrot.sex,
          pairRingNumber: "brak",
        ),
      );
      notifyListeners();
    });
  }

  Future<dynamic> updateParrot({
    String uid,
    Parrot parrot,
    String pairRingNumber,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    await collectionReference
        .doc(parrot.race)
        .collection("Birds")
        .doc(parrot.ringNumber)
        .update({
      "Race Name": "${parrot.race}",
      "Colors": "${parrot.color}",
      "Fission": "${parrot.fission}",
      "Sex": "${parrot.sex}",
      "Cage number": "${parrot.cageNumber}",
      "Notes": "${parrot.notes}",
      "PairRingNumber": pairRingNumber,
    }).then((_) {
      //Tutaj dodaj lokalna podmianke papugi, nie bedzie trzeba sie cofac po zmianie ;)
      _parrotList.removeWhere((p) => p.ringNumber == parrot.ringNumber);
      _parrotList.add(parrot);
      notifyListeners();
    });
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
          .doc(parrotsRace.parrotsNameList[i])
          .collection("Birds")
          .get();
      if (snapshot.docs.length != 0) {
        //creating parrot
        snapshot.docs.forEach((val) {
          _parrotList.add(
            Parrot(
              race: val.data()['Race Name'],
              ringNumber: val.id,
              color: val.data()['Colors'],
              cageNumber: val.data()['Cage number'],
              fission: val.data()['Fission'],
              notes: val.data()['Notes'],
              sex: val.data()['Sex'],
              pairRingNumber: val.data()['PairRingNumber'],
            ),
          );
        });
      }
    }
    notifyListeners();
  }

  Future<void> deleteRaceList(String uid, String raceName) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);
    await collectionReference
        .doc(raceName)
        .collection("Birds")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete().then((_) {
          snapshot.docs.forEach((val) {
            _parrotList.removeWhere((parrot) => parrot.ringNumber == val.id);
            notifyListeners();
          });
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> deleteParrot(String uid, Parrot parrotToDelete) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);

    await breedCollection
        .doc(parrotToDelete.race)
        .collection("Birds")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((val) {
        if (val.id == parrotToDelete.ringNumber) {
          val.reference.delete().then((_) {
            _parrotList.removeWhere(
                (parrot) => parrot.ringNumber == parrotToDelete.ringNumber);
            notifyListeners();
          });
        }
      });
    }).catchError((err) {
      print(err);
    });
  }
}
