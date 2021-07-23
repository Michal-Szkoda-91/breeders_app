import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

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
        'Samouczek',
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
      ),
      onPressed: () async {
        await showAnimatedDialog(
          context: context,
          builder: (ctx) => SafeArea(
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              content: TutorialParrotCrud(),
            ),
          ),
          animationType: DialogTransitionType.fadeScale,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 1400),
        );
      },
    );
  }
}
