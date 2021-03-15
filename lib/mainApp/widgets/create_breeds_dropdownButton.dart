import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/models/breedings_model.dart';
import 'package:breeders_app/mainApp/models/breeds_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateBreedsDropdownButton extends StatelessWidget {
  final BreedList _breedList = BreedList();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<BreedingsList>(context);
    providerData.getBreedingsList;
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
      items: _breedList.breedsList.map((value) {
        return DropdownMenuItem(
          //create new breeds
          onTap: () {
            _createBreed(value, providerData, context);
          },
          child: new Row(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        value['url'],
                      ),
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: AutoSizeText(
                  value['name'],
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 20,
                  ),
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
          uid: firebaseUser.uid,
        );
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
