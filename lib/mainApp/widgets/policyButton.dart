import 'package:flutter/material.dart';

import '../../privacy_policy/dialog_policy.dart';

class PolicyButton extends StatelessWidget {
  const PolicyButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(
        Icons.policy,
        color: Theme.of(context).textSelectionColor,
        size: 30,
      ),
      label: Text(
        'Polityka Prywatności',
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
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
