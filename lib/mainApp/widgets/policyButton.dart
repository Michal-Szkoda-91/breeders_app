import 'package:flutter/material.dart';

import '../../privacy_policy/dialog_policy.dart';

class PolicyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        Icons.policy,
        color: Theme.of(context).textSelectionTheme.selectionColor,
        size: 30,
      ),
      label: Text(
        'Polityka Prywatności',
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return PolicyDialog(
              mdFileName: 'privacy_policy.md',
            );
          },
        );
      },
    );
  }
}
