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
        .catchError((error) {});
  }
}
