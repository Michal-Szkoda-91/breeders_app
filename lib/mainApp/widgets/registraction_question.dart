import 'package:flutter/material.dart';

class RegisterQuestion extends StatelessWidget {
  const RegisterQuestion({
    required this.function,
  });

  final Function function;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Nie masz konta?',
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
            fontSize: MediaQuery.of(context).size.width < 340 ? 10 : 16,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          child: Text(
            'Załóż je tutaj',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width < 340 ? 10 : 16,
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
