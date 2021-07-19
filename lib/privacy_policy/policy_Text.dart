import 'package:breeders_app/privacy_policy/dialog_policy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyText extends StatelessWidget {
  const PolicyText({required});

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
                showAnimatedDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'terms_and_condition.md',
                    );
                  },
                  animationType: DialogTransitionType.scale,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 2),
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
                showAnimatedDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'privacy_policy.md',
                    );
                  },
                  animationType: DialogTransitionType.scale,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 2),
                );
              },
          ),
          TextSpan(
            text: "\nDostępnych również",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: "\nNa stronie",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch("https://hodowla-papug-polityka.000webhostapp.com/");
              },
          ),
        ],
      ),
    );
  }
}
