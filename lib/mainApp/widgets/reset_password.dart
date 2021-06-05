import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            'Zapomniane hasło?',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              // fontSize: 16,
            ),
          ),
          Text(
            'Zresetuj je!',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              // fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
