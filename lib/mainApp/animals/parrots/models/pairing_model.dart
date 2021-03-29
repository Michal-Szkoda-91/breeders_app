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

  Future<dynamic> createPairCollection({
    String uid,
    ParrotPairing pair,
    String race,
    Parrot maleParrot,
    Parrot femaleParrot,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(uid);

    //create collection if not exist
    await collectionReference
        .doc('Hodowla Papug')
        .collection(race)
        .doc("Pairs")
        .set({
      "${pair.id}": {
        "Male Ring": "${pair.maleRingNumber}",
        "Female Ring": "${pair.femaleRingNumber}",
        "Pairing Data": "${pair.pairingData}",
        "Children": "${pair.childrenList}",
      },
    }, SetOptions(merge: true));

    //add pair to parrot
    await collectionReference
        .doc('Hodowla Papug')
        .collection(race)
        .doc("Birds")
        .update({
      "${pair.maleRingNumber}": {
        "Race Name": "${maleParrot.race}",
        "Colors": "${maleParrot.color}",
        "Fission": "${maleParrot.fission}",
        "Sex": "${maleParrot.sex}",
        "Cage number": "${maleParrot.cageNumber}",
        "Notes": "${maleParrot.notes}",
        "PairRingNumber": "${pair.femaleRingNumber}",
      },
    });
    await collectionReference
        .doc('Hodowla Papug')
        .collection(race)
        .doc("Birds")
        .update({
      "${pair.femaleRingNumber}": {
        "Race Name": "${femaleParrot.race}",
        "Colors": "${femaleParrot.color}",
        "Fission": "${femaleParrot.fission}",
        "Sex": "${femaleParrot.sex}",
        "Cage number": "${femaleParrot.cageNumber}",
        "Notes": "${femaleParrot.notes}",
        "PairRingNumber": "${pair.maleRingNumber}",
      },
    });
  }
}
