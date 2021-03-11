import 'package:breeders_app/mainApp/models/breedings_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateBreedsDropdownButton extends StatelessWidget {
  final List<Map> _breedsList = [
    {"url": 'assets/animal_Icon.jpg', 'name': 'Załóż Hodowlę'},
    {"url": 'assets/parrot.jpg', 'name': 'Hodowla Papug'},
    {"url": 'assets/chinchila.jpg', 'name': 'Hodowla Szynszyli'},
    {"url": 'assets/horse.jpg', 'name': 'Hodowla Koni'},
  ];

  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<BreedingsList>(context);
    return DropdownButton(
      itemHeight: 70,
      isExpanded: true,
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).textSelectionColor,
        ),
      ),
      dropdownColor: Theme.of(context).backgroundColor,
      items: _breedsList.map((value) {
        return DropdownMenuItem(
          //create new breeds
          onTap: () {
            _createBreed(value, providerData, context);
          },
          child: new Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipOval(
                  child: Image.asset(
                    value['url'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                value['name'],
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }

  void _createBreed(
      dynamic value, BreedingsList providerData, BuildContext context) {
    String name = value['name'].toString().split(" ")[1];
    if (value['name'] == 'Załóż Hodowlę') {
      return;
    } else {
      try {
        providerData.createBreedsCollection(
            name: value['name'],
            pictureUrl: value['url'],
            uid: firebaseUser.uid);

        showInSnackBar('Utworzono Hodowlę $name', context);
      } catch (e) {
        showInSnackBar('Nie udało się utworzyć hodowli', context);
      }
    }
  }

  void showInSnackBar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  }
}
