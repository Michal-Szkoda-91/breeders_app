import 'package:flutter/material.dart';

class IncubationCancelButton extends StatelessWidget {
  const IncubationCancelButton({
    required this.setEggsDate,
  });

  final Function setEggsDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black45,
      ),
      child: TextButton.icon(
        icon: Icon(
          Icons.cancel,
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
        onPressed: () {
          setEggsDate("brak");
        },
        label: Text(
          "Anuluj Inkubację",
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
