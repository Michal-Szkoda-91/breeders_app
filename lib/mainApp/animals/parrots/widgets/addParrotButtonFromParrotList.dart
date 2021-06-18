import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/parrotsRace_list.dart';
import '../screens/addParrot_screen.dart';

class AddParrotFromInsideParrotList extends StatefulWidget {
  final String race;

  AddParrotFromInsideParrotList({Key key, this.race}) : super(key: key);

  @override
  _AddParrotFromInsideParrotListState createState() =>
      _AddParrotFromInsideParrotListState();
}

class _AddParrotFromInsideParrotListState
    extends State<AddParrotFromInsideParrotList> {
  final ParrotsRace _parrotsRace = new ParrotsRace();

  Map raceMap;

  @override
  Widget build(BuildContext context) {
    raceMap = _parrotsRace.parrotsRaceList
        .firstWhere((element) => element["name"] == widget.race);

    return Material(
      borderRadius: BorderRadius.all(
        const Radius.circular(8),
      ),
      color: Theme.of(context).backgroundColor,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddParrotScreen(
                parrotMap: raceMap,
                parrot: null,
                addFromChild: false,
              ),
            ),
          );
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.72,
          child: new Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(raceMap["url"]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AutoSizeText(
                  "Dodaj Papugę",
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                  ),
                ),
              ),
              Icon(
                Icons.add,
                color: Theme.of(context).textSelectionColor,
                size: 30,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
