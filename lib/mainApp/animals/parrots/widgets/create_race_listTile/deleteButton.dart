import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Deletebutton extends StatelessWidget {
  final String title;
  final Function function;
  final Color color;
  final IconData icon;
  final String name;
  final double padding;
  Deletebutton(
      {Key key,
      this.title,
      this.function,
      this.color,
      this.icon,
      this.name,
      this.padding})
      : super(key: key);

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
              context,
              title,
              "Czy chcesz usunąć wszystkie papugi z hodowli? Usunięte zostaną również pary wraz z danymi o inkubacji i potomstwu.\n\nOPERACJI NIE MOŻNA PÓZNIEJ COFNĄĆ!!!",
              function,
              null,
            );
          },
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
      ),
    );
  }
}
