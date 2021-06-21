import 'package:breeders_app/privacy_policy/dialog_policy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PolicyText extends StatelessWidget {
  const PolicyText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Tworząc konto, akceptujesz moje\n",
        style: TextStyle(
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: "Zasady i Warunki Korzystania",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.5,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'terms_and_condition.md',
                    );
                  },
                );
              },
          ),
          TextSpan(
            text: "\noraz ",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: "Politykę prywatności",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'privacy_policy.md',
                    );
                  },
                );
              },
          ),
        ],
      ),
    );
  }
}
