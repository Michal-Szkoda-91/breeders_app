import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  Future<void> createPairCollection({
    String uid,
    ParrotPairing pair,
    String race,
    Parrot maleParrot,
    Parrot femaleParrot,
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
      parrotList.updateParrot(
          parrot: maleParrot, uid: uid, pairRingNumber: pair.femaleRingNumber);
      parrotList.updateParrot(
          parrot: femaleParrot, uid: uid, pairRingNumber: pair.maleRingNumber);
    }).catchError((err) {
      print("error occured $err");
    });
  }

  Future<void> createChild(
      {String uid, String race, String pairId, Children child}) async {
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
      print("parrot added");
    }).catchError((err) {
      print("error occured $err");
    });
  }

  Future<void> deletePair(String uid, String race, String id,
      Parrot femaleParrot, Parrot maleParrot, String picUrl) async {
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
      parrotList.updateParrot(
          parrot: maleParrot, uid: uid, pairRingNumber: "brak");
      parrotList.updateParrot(
          parrot: femaleParrot, uid: uid, pairRingNumber: "brak");
      print("Pair deleted");
    }).catchError((err) {
      print("error occured $err");
    });

    //Delete picture from storage
    try {
      final ref = FirebaseStorage.instance.ref().child(picUrl);
      await ref.delete();
      print("Pair deleted");
    } catch (e) {
      print("error occured $e");
    }
  }

  Future<void> moveToArchive(String uid, String race, String id,
      Parrot femaleParrot, Parrot maleParrot) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    ParrotDataHelper parrotList = ParrotDataHelper();

    await breedCollection.doc(race).collection("Pairs").doc(id).update({
      "Is Archive": "true",
    }).then((_) {
      parrotList.updateParrot(
          parrot: maleParrot, uid: uid, pairRingNumber: "brak");
      parrotList.updateParrot(
          parrot: femaleParrot, uid: uid, pairRingNumber: "brak");
      print("Pair updated");
    }).catchError((err) {
      print("error occured $err");
    });
  }

  Future<void> setEggIncubationTime(
      String uid, String race, String id, String date) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    await breedCollection.doc(race).collection("Pairs").doc(id).update({
      "Show Eggs Date": "$date",
    }).then((_) {
      print("Pair update");
    }).catchError((err) {
      print("error occured $err");
    });
  }
}
