import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../parrotDialogInformation.dart';
import '../../models/parrot_model.dart';

class ParrotRingButton extends StatelessWidget {
  final int index;
  final List<Parrot> createdParrotList;
  final String title;

  const ParrotRingButton({
    Key key,
    this.index,
    this.createdParrotList,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              scrollable: true,
              title: new Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                child: ParrotDialogInformation(
                  parrotRace: createdParrotList[index].race,
                  parrotRing: title,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: AutoSizeText(
            title,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
        ),
      ),
    );
  }
}
