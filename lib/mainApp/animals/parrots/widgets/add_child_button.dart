import 'package:flutter/material.dart';

import 'package:breeders_app/models/global_methods.dart';
import '../models/pairing_model.dart';
import '../../parrots/models/parrot_model.dart';
import '../screens/addParrot_screen.dart';

class AddPairChildButton extends StatefulWidget {
  final String raceName;
  final ParrotPairing pair;

  const AddPairChildButton({required this.pair, required this.raceName});
  @override
  _AddPairChildButtonState createState() => _AddPairChildButtonState();
}

class _AddPairChildButtonState extends State<AddPairChildButton> {
  GlobalMethods _globalMethods = GlobalMethods();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Container(
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black45,
          ),
          child: TextButton.icon(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
            onPressed: () {
              Navigator.of(context).push(
                _globalMethods.createRoute(
                  AddParrotScreen(
                    pair: widget.pair,
                    parrotMap: {
                      "url": "assets/image/parrot.jpg",
                      "name": "Dodaj Potomka",
                      "icubationTime": "21"
                    },
                    race: widget.raceName,
                    addFromChild: false,
                    parrot: Parrot(
                      race: '',
                      ringNumber: 'brak',
                      color: '',
                      fission: '',
                      cageNumber: '',
                      sex: '',
                      notes: '',
                      pairRingNumber: '',
                    ),
                    data: '',
                  ),
                ),
              );
            },
            label: Text(
              "Dodaj Potomstwo",
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
