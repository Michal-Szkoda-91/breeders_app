import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:flutter/material.dart';

import '../../../../../models/global_methods.dart';

// ignore: must_be_immutable
class Deletebutton extends StatelessWidget {
  final String title;
  final Function function;
  final Color color;
  final IconData icon;
  final String name;
  final double padding;
  Deletebutton(
      {required this.title,
      required this.function,
      required this.color,
      required this.icon,
      required this.name,
      required this.padding});

  GlobalMethods _globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: padding,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: color,
        child: InkWell(
          splashColor: Colors.redAccent,
          onTap: () {
            _globalMethods.showDeletingDialog(
              function: function,
              title: title,
              text:
                  "Czy chcesz usunąć wszystkie papugi z hodowli? Usunięte zostaną również pary wraz z danymi o inkubacji i potomstwu.\n\nOPERACJI NIE MOŻNA PÓZNIEJ COFNĄĆ!!!",
              context: context,
              parrot: Parrot(
                  race: '',
                  ringNumber: 'brak',
                  color: '',
                  fission: '',
                  cageNumber: '',
                  sex: '',
                  notes: '',
                  picUrl: '',
                  pairRingNumber: ''),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Theme.of(context).textSelectionTheme.selectionColor,
              ),
              Container(
                child: AutoSizeText(
                  name,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
