import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'dart:io';

import '../mainApp/animals/parrots/models/parrot_model.dart';

class GlobalMethods {
  //arrow container
  var arrowConteiner = Container(
      width: 6, child: Icon(Icons.arrow_back_ios_rounded, color: Colors.red));

  Future<void> showDeletingDialog(
      {required BuildContext context,
      required String title,
      required String text,
      required Function function,
      required Parrot parrot}) async {
    return showAnimatedDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                if (parrot.ringNumber == 'brak') {
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
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 2),
    );
  }

  showMaterialDialog(BuildContext context, String text) async {
    return showAnimatedDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text(
            "Informacja",
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.linear,
      duration: Duration(seconds: 1),
    );
  }

  Future<bool> checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
