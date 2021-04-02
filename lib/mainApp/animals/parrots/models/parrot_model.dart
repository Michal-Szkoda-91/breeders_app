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

class ParrotDataHelper {
  Future<dynamic> createParrotCollection({
    String uid,
    Parrot parrot,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    await collectionReference.doc(parrot.race).set({
      "Race Name": "${parrot.race}",
    });

    final snapShot = await collectionReference
        .doc(parrot.race)
        .collection("Birds")
        .doc(parrot.ringNumber)
        .get();

    if (snapShot == null || !snapShot.exists) {
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
      }, SetOptions(merge: false)).then((_) {
        print("parrot added");
      }).catchError((err) {
        print("error occured $err");
      });
    }
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
      print("parrot edited");
    }).catchError((err) {
      print("error occured $err");
    });
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
          print("Delete completed");
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
            print("Delete completed");
          });
        }
      });
    }).catchError((err) {
      print(err);
    });
  }
}
