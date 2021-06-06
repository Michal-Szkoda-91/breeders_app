import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RegisterQuestion extends StatelessWidget {
  const RegisterQuestion({
    this.function,
  });

  final Function function;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AutoSizeText(
          'Nie masz konta?',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        FlatButton(
          child: Text(
            'Załóż je tutaj',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            function(1);
          },
        ),
      ],
    );
  }
}
