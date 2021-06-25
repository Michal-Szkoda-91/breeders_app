import 'package:flutter/material.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParrotScreen(
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
