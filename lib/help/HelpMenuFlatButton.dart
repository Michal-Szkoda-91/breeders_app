import 'package:flutter/material.dart';

class HelpMenuFlatButton extends StatelessWidget {
  final Function function;
  final String title;

  const HelpMenuFlatButton  ({required this.function, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black12,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {
            await function(context);
          }),
    );
  }
}
