import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/global_methods.dart';
import 'parrot_model.dart';
import 'children_model.dart';

class ParrotPairing {
  final String id;
  final String race;
  final String maleRingNumber;
  final String femaleRingNumber;
  final String pairingData;
  final String showEggsDate;
  final String pairColor;
  final String isArchive;
  final String picUrl;

  ParrotPairing({
    required this.id,
    required this.race,
    required this.maleRingNumber,
    required this.femaleRingNumber,
    required this.pairingData,
    required this.showEggsDate,
    required this.pairColor,
    required this.isArchive,
    required this.picUrl,
  });
}

class ParrotPairDataHelper {
  GlobalMethods _globalMethods = GlobalMethods();

//
//
//
//**************** */
//
//
//
//**************** */
  Future<void> createPairCollection({
    required String uid,
    required ParrotPairing pair,
    required String race,
    required Parrot maleParrot,
    required Parrot femaleParrot,
    required BuildContext context,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);
    ParrotDataHelper parrotList = ParrotDataHelper();

    //create collection if not exist
    await collectionReference.doc(race).collection("Pairs").doc(pair.id).set({
      "Male Ring": "${pair.maleRingNumber}",
      "Female Ring": "${pair.femaleRingNumber}",
      "Race": "$race",
      "Pairing Data": "${pair.pairingData}",
      "Pair Color": "${pair.pairColor}",
      "Is Archive": "false",
      "Show Eggs Date": "brak",
      "Pic Url": "${pair.picUrl}",
    }, SetOptions(merge: true)).then((_) async {
      await parrotList
          .updatedParrotsStatus(uid, maleParrot, pair.femaleRingNumber)
          .then((value) async {
        await parrotList
            .updatedParrotsStatus(uid, femaleParrot, pair.maleRingNumber)
            .then((value) async {
          Navigator.of(context).pop();
          await _globalMethods.showMaterialDialog(context, "Utworzono parę");
          print("Created Pair");
        });
      });
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
  Future<void> createChild({
    required String uid,
    required String race,
    required String pairId,
    required Children child,
    required BuildContext context,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    await collectionReference
        .doc(race)
        .collection("Pairs")
        .doc(pairId)
        .collection("Child")
        .doc(child.ringNumber)
        .set({
      "Colors": "${child.color}",
      "Sex": "${child.gender}",
      "Born Date": "${child.broodDate}"
    }, SetOptions(merge: false)).then((_) {
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(context, "Utworzono potomka");
      print("parrot added");
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
  Future<void> deletePair(
      {required String uid,
      required String race,
      required String id,
      required Parrot femaleParrot,
      required Parrot maleParrot,
      required String picUrl,
      required BuildContext context}) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    ParrotDataHelper parrotList = ParrotDataHelper();

    await breedCollection
        .doc(race)
        .collection("Pairs")
        .doc(id)
        .collection("Child")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
      print("Pair deleted");
    }).catchError((err) {
      print("error occured $err");
    });

    await breedCollection
        .doc(race)
        .collection("Pairs")
        .doc(id)
        .delete()
        .then((_) {
      parrotList.updatedParrotsStatus(
        uid,
        maleParrot,
        "brak",
      );
      parrotList.updatedParrotsStatus(
        uid,
        femaleParrot,
        "brak",
      );
      _globalMethods.showMaterialDialog(context, "Usunięto wybraną parę papug");
      print("Pair deleted");
    }).catchError((err) {
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      print("error occured $err");
    });

    //Delete picture from storage
    try {
      final ref = FirebaseStorage.instanceFor().ref().child(picUrl);
      await ref.delete();
      print("pic deleted");
    } catch (e) {
      print("error occured $e");
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
  Future<void> moveToArchive(String uid, String race, String id,
      Parrot femaleParrot, Parrot maleParrot, BuildContext context) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    ParrotDataHelper parrotList = ParrotDataHelper();

    await breedCollection.doc(race).collection("Pairs").doc(id).update({
      "Is Archive": "true",
    }).then((_) {
      parrotList.updatedParrotsStatus(
        uid,
        maleParrot,
        "brak",
      );
      parrotList.updatedParrotsStatus(
        uid,
        femaleParrot,
        "brak",
      );
      _globalMethods.showMaterialDialog(context, "Przesunięto do archiwum");
      print("Pair updated");
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
  Future<void> editPair(
      {required String uid,
      required String race,
      required String id,
      required String pairingData,
      required String picUrl,
      required String color,
      required BuildContext context}) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);

    await breedCollection.doc(race).collection("Pairs").doc(id).update({
      "Pairing Data": "$pairingData",
      "Pair Color": "$color",
      "Pic Url": "$picUrl",
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
  Future<void> setEggIncubationTime(String uid, String race, String id,
      String date, BuildContext context) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    await breedCollection.doc(race).collection("Pairs").doc(id).update({
      "Show Eggs Date": "$date",
    }).then((_) {
      date != "brak"
          ? _globalMethods.showMaterialDialog(
              context, "Ustawiono datę rozpoczęcia inkubacji")
          : _globalMethods.showMaterialDialog(
              context, "Anulowanie odliczania czasu inkubacji");
      print("Pair update");
    }).catchError((err) {
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      print("error occured $err");
    });
  }
}
