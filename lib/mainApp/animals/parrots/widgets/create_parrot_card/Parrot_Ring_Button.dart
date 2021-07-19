import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../parrotDialogInformation.dart';
import '../../models/parrot_model.dart';

class ParrotRingButton extends StatelessWidget {
  final int index;
  final List<Parrot> createdParrotList;
  final String title;

  const ParrotRingButton({
    required this.index,
    required this.createdParrotList,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          showAnimatedDialog(
            context: context,
            builder: (ctx) => new AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              scrollable: true,
              title: new Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
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
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
            animationType: DialogTransitionType.scale,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 2),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: AutoSizeText(
            title,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
        ),
      ),
    );
  }
}
