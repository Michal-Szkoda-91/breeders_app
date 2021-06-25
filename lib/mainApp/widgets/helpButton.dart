import 'package:flutter/material.dart';

import '../../help/help_screen.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({required});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        Icons.help,
        color: Theme.of(context).textSelectionTheme.selectionColor,
        size: 30,
      ),
      label: Text(
        'Pomoc',
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, HelpScreen.routeName);
      },
    );
  }
}
