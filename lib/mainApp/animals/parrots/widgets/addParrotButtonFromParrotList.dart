import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:flutter/material.dart';

import '../models/parrotsRace_list.dart';
import '../screens/addParrot_screen.dart';

class AddParrotFromInsideParrotList extends StatefulWidget {
  final String race;

  AddParrotFromInsideParrotList({required this.race});

  @override
  _AddParrotFromInsideParrotListState createState() =>
      _AddParrotFromInsideParrotListState();
}

class _AddParrotFromInsideParrotListState
    extends State<AddParrotFromInsideParrotList> {
  final ParrotsRace _parrotsRace = new ParrotsRace();

  late Map raceMap;

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
                addFromChild: false,
                pair: ParrotPairing(
                  id: '',
                  race: '',
                  maleRingNumber: '',
                  femaleRingNumber: '',
                  pairingData: '',
                  showEggsDate: '',
                  pairColor: '',
                  isArchive: '',
                  picUrl: '',
                ),
                race: '',
                parrot: Parrot(
                  race: '',
                  ringNumber: '',
                  color: '',
                  fission: '',
                  cageNumber: '',
                  sex: '',
                  notes: '',
                  pairRingNumber: '',
                ),
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
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                  ),
                ),
              ),
              Icon(
                Icons.add,
                color: Theme.of(context).textSelectionTheme.selectionColor,
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
