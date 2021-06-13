import 'package:flutter/material.dart';

import '../../help/help_screen.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(
        Icons.help,
        color: Theme.of(context).textSelectionColor,
        size: 30,
      ),
      label: Text(
        'Pomoc',
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
        ),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, HelpScreen.routeName);
      },
    );
  }
}
