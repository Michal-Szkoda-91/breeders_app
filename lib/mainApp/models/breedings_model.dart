import 'package:breeders_app/mainApp/animals/parrots/models/parrotsRace_list.dart';
import 'package:breeders_app/mainApp/models/breeds_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BreedingsModel {
  final String name;
  final String pictureUrl;

  BreedingsModel({this.name, this.pictureUrl});
}

class BreedingsList with ChangeNotifier {
  List<BreedingsModel> _breedingsList = [];

  List<BreedingsModel> get getBreedingsList {
    return [..._breedingsList];
  }

//create firebase documents
  Future<dynamic> createBreedsCollection({String uid, String name}) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    await breedCollection.doc(name).set(
      {},
    );
    loadBreeds(uid);
  }

  Future<void> loadBreeds(String uid) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);

    _breedingsList.clear();
    BreedList breedList = BreedList();

    await breedCollection
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                for (var i = 0; i < breedList.breedsList.length; i++) {
                  if (doc.id == breedList.breedsList[i]['name']) {
                    _breedingsList.add(
                      BreedingsModel(
                        name: doc.id,
                        pictureUrl: breedList.breedsList[i]['url'],
                      ),
                    );
                  }
                }
                notifyListeners();
              }),
            })
        .catchError((error) {
      print(error);
    });
  }

  Future deleteBreeds(String uid, String docToDelete) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);

    //Deleting all collection inside document
    ParrotsRace parrotsRace = ParrotsRace();
    for (var i = 0; i < parrotsRace.parrotsNameList.length; i++) {
      //checking if document exist
      var snapshot = await breedCollection
          .doc("Hodowla Papug")
          .collection(parrotsRace.parrotsNameList[i])
          .get();
      if (snapshot.docs.length != 0) {
        await breedCollection
            .doc(docToDelete)
            .collection(parrotsRace.parrotsNameList[i])
            .doc("Birds")
            .delete();
      }
    }

    await breedCollection.doc(docToDelete).delete().then((_) {
      _breedingsList.forEach((breeds) {
        if (breeds.name == docToDelete) {
          _breedingsList.remove(breeds);
          notifyListeners();
        }
      });
    }).catchError((error) {
      print(error);
    });
  }
}
