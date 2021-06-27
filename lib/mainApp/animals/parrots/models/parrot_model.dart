import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/global_methods.dart';

class Parrot {
  final String race;
  late final String ringNumber;
  final String color;
  final String fission;
  final String cageNumber;
  final String sex;
  final String notes;
  final String pairRingNumber;

  Parrot({
    required this.race,
    required this.ringNumber,
    required this.color,
    required this.fission,
    required this.cageNumber,
    required this.sex,
    required this.notes,
    required this.pairRingNumber,
  });
}

class ParrotDataHelper {
  GlobalMethods _globalMethods = GlobalMethods();
//
//
//
//**************** */
//
//
//
//**************** */
  Future<dynamic> createParrotCollection({
    required String uid,
    required Parrot parrot,
    required BuildContext context,
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

    if (!snapShot.exists) {
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
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(context, "Dodano Papugę");
        print("parrot added");
      }).catchError((err) {
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
        print("error occured $err");
      });
    }
  }

//
//
//
//**************** */
//
//
//
//**************** */
  Future<dynamic> updateParrot({
    required String uid,
    required Parrot parrot,
    required String pairRingNumber,
    required BuildContext context,
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
      "PairRingNumber": pairRingNumber,
    }).then((_) {
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(context, "Edytowano dane");
      print("parrot edited");
    }).catchError((err) {
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      print("error occured $err");
    });
  }

  //
//
//
//**************** */
//
//
//
//**************** */
  Future<dynamic> updatedParrotsStatus(
    String uid,
    Parrot parrot,
    String pairRingNumber,
  ) async {
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

//
//
//
//**************** */
//
//
//
//**************** */
  Future<void> deleteRaceList(
      String uid, String raceName, BuildContext context) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);
    //delete all birds in collection
    await collectionReference
        .doc(raceName)
        .collection("Birds")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }

      print("Delete completed");
    }).catchError((err) {
      print(err);
    });
    //delete all children in collection
    await collectionReference
        .doc(raceName)
        .collection("Pairs")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.collection("Child").get().then((snap) {
          for (DocumentSnapshot doc in snap.docs) {
            doc.reference.delete();
          }
        });
      }

      print("Delete completed");
    }).catchError((err) {
      print(err);
    });

//delete all pairs
    await collectionReference
        .doc(raceName)
        .collection("Pairs")
        .get()
        .then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
        //Delete picture from storage
        try {
          final ref = FirebaseStorage.instanceFor().ref().child(doc['Pic Url']);
          await ref.delete();
          print("pic deleted");
        } catch (e) {
          print("error occured $e");
        }
      }
      print("Delete completed");
    }).catchError((err) {
      print(err);
    });
//delete all document
    await collectionReference.doc(raceName).delete().then((_) {
      _globalMethods.showMaterialDialog(context,
          "Usunięto wszystkie papugi z rasy $raceName wraz ze wszystkimi parami i danymi.");
      print("collection of parrots deleted");
    }).catchError((err) {
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      print("error occured $err");
    });
  }

//
//
//
//**************** */
//
//
//
//**************** */
  Future<void> deleteParrot({
    required String uid,
    required Parrot parrotToDelete,
    required BuildContext context,
    required bool showDialog,
  }) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);

    if (parrotToDelete.pairRingNumber != "brak") {
      await breedCollection
          .doc(parrotToDelete.race)
          .collection("Pairs")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          if (doc.id.contains(parrotToDelete.ringNumber)) {
            doc.reference.delete();
          }
        }
      });
      await breedCollection
          .doc(parrotToDelete.race)
          .collection("Birds")
          .doc(parrotToDelete.pairRingNumber)
          .update({
        "PairRingNumber": "brak",
      });
    }
    await breedCollection
        .doc(parrotToDelete.race)
        .collection("Birds")
        .doc(parrotToDelete.ringNumber)
        .delete()
        .then((_) {
      if (showDialog) {
        _globalMethods.showMaterialDialog(context,
            "Usunięto papugę o numerze obrączki ${parrotToDelete.ringNumber}");
      }
    }).catchError((err) {
      if (showDialog) {
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      }
      print("error occured $err");
    });
  }
}
