import 'package:breeders_app/models/global_methods.dart';
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
        GlobalMethods _globalMethods = GlobalMethods();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          _globalMethods.createRoute(
            HelpScreen(),
          ),
        );
      },
    );
  }
}
