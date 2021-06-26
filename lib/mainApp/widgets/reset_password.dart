import 'package:flutter/material.dart';

import '../../authentication/resetPass_screen.dart';

class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Zapomniane hasło?',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: MediaQuery.of(context).size.width < 340 ? 10 : 16,
            ),
          ),
          TextButton(
            child: Text(
              'Zresetuj je!',
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width < 340 ? 10 : 16,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                ResetPasswordScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
