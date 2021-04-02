import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:flutter/material.dart';

class GlobalMethods {
  //arrow container
  var arrowConteiner = Container(
      width: 6, child: Icon(Icons.arrow_back_ios_rounded, color: Colors.red));

  //Create icon in sliders
  Widget createActionItem(
    BuildContext context,
    Color color,
    IconData icon,
    String name,
    double padding,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Theme.of(context).textSelectionColor,
            ),
            Container(
              child: AutoSizeText(
                name,
                maxLines: 2,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDeletingDialog(BuildContext context, String title,
      String text, Function function, Parrot parrot) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Usuń",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                if (parrot == null) {
                  await function(title);
                } else {
                  await function(title, parrot);
                }
              },
            ),
            TextButton(
              child: Text(
                "Anuluj",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showMaterialDialog(BuildContext context, String text) async {
    double padding = MediaQuery.of(context).size.height * 0.4;
    await showDialog(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(top: padding),
        child: new AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text(
            "Informacja",
            style: TextStyle(color: Theme.of(context).textSelectionColor),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).textSelectionColor),
          ),
        ),
      ),
    );
  }
}
