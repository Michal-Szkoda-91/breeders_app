import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'package:flutter/material.dart';

class AddPairChildButton extends StatefulWidget {
  final String raceName;
  final ParrotPairing pair;

  const AddPairChildButton({this.pair, this.raceName});
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black45,
          ),
          child: FlatButton.icon(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).textSelectionColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParrotScreen(
                    pair: widget.pair,
                    parrot: null,
                    parrotMap: {
                      "url": "assets/image/parrot.jpg",
                      "name": "Dodaj Potomka",
                      "icubationTime": "21"
                    },
                    race: widget.raceName,
                  ),
                ),
              );
            },
            label: Text(
              "Dodaj Potomstwo",
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
