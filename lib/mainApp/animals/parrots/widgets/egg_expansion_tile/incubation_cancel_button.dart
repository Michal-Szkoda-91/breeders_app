import 'package:flutter/material.dart';

class IncubationCancelButton extends StatelessWidget {
  const IncubationCancelButton({
    Key key,
    @required this.setEggsDate,
  }) : super(key: key);

  final Function setEggsDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black45,
      ),
      child: FlatButton.icon(
        icon: Icon(
          Icons.cancel,
          color: Theme.of(context).textSelectionColor,
        ),
        onPressed: () {
          setEggsDate("brak");
        },
        label: Text(
          "Anuluj Inkubację",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
