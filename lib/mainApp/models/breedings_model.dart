import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BreedingsModel {
  final String name;
  final String pictureUrl;
  final Map<String, dynamic> animals;

  BreedingsModel({this.animals, this.name, this.pictureUrl});
}

class BreedingsList with ChangeNotifier {
  List<BreedingsModel> _breedingsList = [];

  List<BreedingsModel> get getBreedingsList {
    return [..._breedingsList];
  }

//create firebase documents
  Future<dynamic> createBreedsCollection(
      {String uid, String name, String pictureUrl}) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);
    breedCollection.doc(name).set(
      {
        "pictureUrl": pictureUrl,
        "Zwierzęta": {},
      },
    );
    loadBreeds(uid);
  }

  Future<void> loadBreeds(String uid) async {
    final CollectionReference breedCollection =
        FirebaseFirestore.instance.collection(uid);

    _breedingsList.clear();

    await breedCollection
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                _breedingsList.add(
                  BreedingsModel(
                    name: doc.id,
                    pictureUrl: doc["pictureUrl"],
                    animals: (doc.data()["Zwierzęta"]),
                  ),
                );
              }),
              notifyListeners(),
            })
        .catchError((error) {});
  }
}
