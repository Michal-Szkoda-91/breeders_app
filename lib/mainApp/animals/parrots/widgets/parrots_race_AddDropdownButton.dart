import 'package:breeders_app/mainApp/animals/parrots/widgets/addParrot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateParrotsDropdownButton extends StatelessWidget {
  final List<Map> _parrotsRaceList = [
    {"url": 'assets/parrotsRace/parrot_Icon.jpg', 'name': 'Dodaj Papugę'},
    {"url": 'assets/parrotsRace/aleksandretta.jpg', 'name': 'Aleksandretta'},
    {"url": 'assets/parrotsRace/lorysa.jpg', 'name': 'Lorysa'},
    {"url": 'assets/parrotsRace/nimfa.jpg', 'name': 'Nimfa'},
    {"url": 'assets/parrotsRace/rozella.jpg', 'name': 'Rozella'},
  ];

  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _parrotsRaceList[0],
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
      items: _parrotsRaceList.map((value) {
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
              builder: (context) => AddParrotScreen(
                name: value['name'],
              ),
            ),
          );
        } else {
          return;
        }
      },
    );
  }
}
