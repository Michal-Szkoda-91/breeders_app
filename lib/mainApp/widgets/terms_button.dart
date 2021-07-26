import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../../privacy_policy/dialog_policy.dart';

class TermsButton extends StatelessWidget {
  const TermsButton({required});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        Icons.my_library_books,
        color: Theme.of(context).textSelectionTheme.selectionColor,
        size: 30,
      ),
      label: Text(
        'Zasady i Regulamin',
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
      ),
      onPressed: () async {
        showAnimatedDialog(
          context: context,
          builder: (context) {
            return PolicyDialog(
              mdFileName: 'terms_and_condition.md',
            );
          },
          animationType: DialogTransitionType.scale,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 800),
        );
      },
    );
  }
}
