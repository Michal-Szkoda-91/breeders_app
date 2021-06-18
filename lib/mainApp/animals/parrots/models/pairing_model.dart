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
    this.id,
    this.race,
    this.maleRingNumber,
    this.femaleRingNumber,
    this.pairingData,
    this.showEggsDate,
    this.pairColor,
    this.isArchive,
    this.picUrl,
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
    String uid,
    ParrotPairing pair,
    String race,
    Parrot maleParrot,
    Parrot femaleParrot,
    BuildContext context,
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
    }, SetOptions(merge: true)).then((_) {
      parrotList.updatedParrotsStatus(
          parrot: maleParrot, uid: uid, pairRingNumber: pair.femaleRingNumber);
      parrotList.updatedParrotsStatus(
          parrot: femaleParrot, uid: uid, pairRingNumber: pair.maleRingNumber);
      _globalMethods.showMaterialDialog(context, "Utworzono parę");
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
    String uid,
    String race,
    String pairId,
    Children child,
    BuildContext context,
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
      String uid,
      String race,
      String id,
      Parrot femaleParrot,
      Parrot maleParrot,
      String picUrl,
      BuildContext context) async {
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
          parrot: maleParrot, uid: uid, pairRingNumber: "brak");
      parrotList.updatedParrotsStatus(
          parrot: femaleParrot, uid: uid, pairRingNumber: "brak");
      _globalMethods.showMaterialDialog(context, "Usunięto wybraną parę papug");
      print("Pair deleted");
    }).catchError((err) {
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      print("error occured $err");
    });

    //Delete picture from storage
    try {
      final ref = FirebaseStorage.instance.ref().child(picUrl);
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
          parrot: maleParrot, uid: uid, pairRingNumber: "brak");
      parrotList.updatedParrotsStatus(
          parrot: femaleParrot, uid: uid, pairRingNumber: "brak");
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
      {String uid,
      String race,
      String id,
      String pairingData,
      String picUrl,
      String color,
      BuildContext context}) async {
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
