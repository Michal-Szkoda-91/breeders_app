import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  final String email;

  const ResetPassword({Key key, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AutoSizeText(
            'Zapomniane hasło?',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              // fontSize: 16,
            ),
          ),
          FlatButton(
            child: Text(
              'Zresetuj je!',
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                // fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _resetPass(email, context);
            },
          ),
        ],
      ),
    );
  }

  void _resetPass(String email, BuildContext context) async {
    GlobalMethods globalMethods = GlobalMethods();
    if (email.isEmpty) {
      globalMethods.showMaterialDialog(context, "Uzupełnij Email");
    } else if (!EmailValidator.validate(email)) {
      globalMethods.showMaterialDialog(context, "Email jest nie prawidłowy");
    } else {
      final _authReset = FirebaseAuth.instance;
      await _authReset.sendPasswordResetEmail(email: email);
      globalMethods.showMaterialDialog(context,
          "Wysłano wiadomość resetującą hasło. Pamiętaj, że nowe musi odpowiadać wymaganiaom postawionym w aplikacji");
    }
  }
}
