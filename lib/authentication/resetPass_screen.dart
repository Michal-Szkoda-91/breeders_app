import 'package:breeders_app/models/global_methods.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../globalWidgets/mainBackground.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = "/ResetPasswordScreen";

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Hasła"),
      ),
      body: MainBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                Text(
                  "Wpisz adres Email na którym chesz ustawić nowę hasło, następnie wybierz RESET i sprawdź skrzynkę email",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    style: customTextStyle(context),
                    cursorColor:
                        Theme.of(context).textSelectionTheme.selectionColor,
                    decoration: _createInputDecoration(
                      context,
                      'Email',
                      Icons.email,
                      false,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Wprowadź email';
                      } else if (!EmailValidator.validate(val)) {
                        return 'Nieprawidłowy email';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    onEditingComplete: () => _resetPass(email, context),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Anuluj",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Reset Hasła",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor,
                        ),
                      ),
                      onPressed: () {
                        _resetPass(email, context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
      await _authReset.sendPasswordResetEmail(email: email).then((value) {
        globalMethods.showMaterialDialog(context,
            "Wysłano wiadomość resetującą hasło. Pamiętaj, że nowe musi odpowiadać wymaganiaom postawionym w aplikacji tzn. Zawierać conajmniej jedną małą i dużą literę oraz cyfrę.");
      }).catchError((err) {
        globalMethods.showMaterialDialog(context,
            "Przepraszamy, nie udało się wysłać wiadomośći email! Sprawdź poprawność danych i spróbuj ponownie.");
      });
    }
  }

  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionTheme.selectionColor,
      fontSize: 14,
    );
  }

  //wlasny model pola do wpisania textu
  InputDecoration _createInputDecoration(
      BuildContext context, String text, IconData icon, bool eyeIcon) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 14),
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      labelText: text,
      icon: Icon(
        icon,
        color: Theme.of(context).textSelectionTheme.selectionColor,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      filled: true,
      fillColor: Theme.of(context).primaryColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(30.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(30.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).canvasColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(30.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(30.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
