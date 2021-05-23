import 'package:flutter/material.dart';

class RegisterQuestion extends StatelessWidget {
  const RegisterQuestion({
    this.function,
  });

  final Function function;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Nie masz konta?',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 16,
            ),
          ),
          FlatButton(
            child: Text(
              'Załóż je tutaj',
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              function(1);
            },
          ),
        ],
      ),
    );
  }
}
