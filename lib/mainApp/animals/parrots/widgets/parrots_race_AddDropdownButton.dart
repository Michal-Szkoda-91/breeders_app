import 'package:breeders_app/mainApp/animals/parrots/models/parrotsRace_list.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateParrotsDropdownButton extends StatefulWidget {
  @override
  _CreateParrotsDropdownButtonState createState() =>
      _CreateParrotsDropdownButtonState();
}

class _CreateParrotsDropdownButtonState
    extends State<CreateParrotsDropdownButton> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  ParrotsRace _parrotsRace = new ParrotsRace();

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _parrotsRace.parrotsRaceList[0],
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
      items: _parrotsRace.parrotsRaceList.map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipOval(
                  child: Image.asset(
                    value['url'],
                    width: 45,
                    height: 45,
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
      onChanged: (value) {
        if (value['name'] != 'Dodaj Papugę') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddParrotScreen(parrotMap: value),
            ),
          );
        } else {
          return;
        }
      },
    );
  }
}
