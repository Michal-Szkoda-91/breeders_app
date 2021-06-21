import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../privacy_policy/dialog_policy.dart';

class TermsButton extends StatelessWidget {
  const TermsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(
        MaterialCommunityIcons.book_open_variant,
        color: Theme.of(context).textSelectionColor,
        size: 30,
      ),
      label: Text(
        'Zasady i Regulamin',
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
        ),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return PolicyDialog(
              mdFileName: 'terms_and_condition.md',
            );
          },
        );
      },
    );
  }
}
