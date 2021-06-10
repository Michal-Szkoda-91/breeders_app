import 'package:flutter/material.dart';

import '../../privacy_politicy/politycy_privacy_screen.dart';

class PolicyButton extends StatelessWidget {
  const PolicyButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      color: Theme.of(context).primaryColor,
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
        Navigator.pushNamed(context, PolitycyPrivacyScreen.routeName);
      },
    );
  }
}
