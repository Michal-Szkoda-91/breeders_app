import 'package:flutter/material.dart';
import 'dart:io';

import '../mainApp/animals/parrots/models/parrot_model.dart';

class GlobalMethods {
  //arrow container
  var arrowConteiner = Container(
      width: 6, child: Icon(Icons.arrow_back_ios_rounded, color: Colors.red));

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
                "OK",
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

  Future<bool> checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Navigator.of(context).pop();
        return true;
      }
    } on SocketException catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
