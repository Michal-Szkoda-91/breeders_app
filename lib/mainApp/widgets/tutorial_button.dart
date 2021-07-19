import 'package:flutter/material.dart';

import '../animals/parrots/widgets/tutorial_dialog_parrot_CRUD.dart';

class TutorialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        Icons.book,
        color: Theme.of(context).textSelectionTheme.selectionColor,
        size: 30,
      ),
      label: Text(
        'Samouczuek',
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return TutorialParrotCrud();
          },
        );
      },
    );
  }
}
