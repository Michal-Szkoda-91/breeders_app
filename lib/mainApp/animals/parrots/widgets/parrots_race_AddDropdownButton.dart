import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/parrotsRace_list.dart';
import '../screens/addParrot_screen.dart';

class CreateParrotsDropdownButton extends StatefulWidget {
  final List<String> parrotRingList;

  const CreateParrotsDropdownButton({Key key, this.parrotRingList})
      : super(key: key);
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _parrotsRace.parrotsRaceList[0],
          itemHeight: 60,
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.add,
              size: 30,
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          dropdownColor: Theme.of(context).backgroundColor,
          items: _parrotsRace.parrotsRaceList.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: new Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              value['url'],
                            ),
                          )),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: value['lac'] != "brak"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: AutoSizeText(
                                    value['name'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).textSelectionColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: AutoSizeText(
                                    value['lac'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      // fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: AutoSizeText(
                                value['name'],
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            if (value['name'] != 'Dodaj Papugę') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParrotScreen(
                    parrotMap: value,
                    parrot: null,
                    addFromChild: false,
                  ),
                ),
              );
            } else {
              return;
            }
          },
        ),
      ),
    );
  }
}
