import 'package:breeders_app/mainApp/animals/parrots/models/children_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ParrotPairing {
  final String id;
  final String maleRingNumber;
  final String femaleRingNumber;
  final String pairingData;
  final List<Children> childrenList;

  ParrotPairing({
    this.id,
    this.maleRingNumber,
    this.femaleRingNumber,
    this.pairingData,
    this.childrenList,
  });
}

class ParrotPairingList with ChangeNotifier {
  List<ParrotPairing> _parrotPairingList = [];

  List<ParrotPairing> get getParringParrotList {
    return [..._parrotPairingList];
  }

  Future<void> createPairCollection({
    String uid,
    ParrotPairing pair,
    String race,
    Parrot maleParrot,
    Parrot femaleParrot,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);
    ParrotsList parrotList = ParrotsList();

    //create collection if not exist
    await collectionReference.doc(race).collection("Pairs").doc(pair.id).set({
      "Male Ring": "${pair.maleRingNumber}",
      "Female Ring": "${pair.femaleRingNumber}",
      "Pairing Data": "${pair.pairingData}",
      "Children": "${pair.childrenList}",
    }, SetOptions(merge: true)).then((_) {
      parrotList.updateParrot(
          parrot: maleParrot, uid: uid, pairRingNumber: pair.femaleRingNumber);
      parrotList.updateParrot(
          parrot: femaleParrot, uid: uid, pairRingNumber: pair.maleRingNumber);
      _parrotPairingList.add(pair);
      notifyListeners();
    });
  }
}
