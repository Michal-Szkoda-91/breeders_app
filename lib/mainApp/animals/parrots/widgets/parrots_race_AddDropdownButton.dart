import 'package:auto_size_text/auto_size_text.dart';
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
    return Expanded(
      child: DropdownButton(
        value: _parrotsRace.parrotsRaceList[0],
        itemHeight: 50,
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
                  child: CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                          value['url'],
                        ),
                      )),
                ),
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
        onChanged: (value) {
          if (value['name'] != 'Dodaj Papugę') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddParrotScreen(
                  parrotMap: value,
                  parrot: null,
                ),
              ),
            );
          } else {
            return;
          }
        },
      ),
    );
  }
}
