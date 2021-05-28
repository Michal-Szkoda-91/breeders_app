import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../globalWidgets/imageContainerParrot.dart';
import '../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  ScrollController _rrectController = ScrollController();

  bool _isLoading = false;

//temporary strings
  String email = '';
  String password = '';
  String passwordRepeated = '';
  String error = '';

  bool _passwordObscure = true;
  bool _passwordSecondObscure = true;

  //patterns for validation

  Pattern _passwordPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!?_@#\$&*~]).{8,20}$';

  String _hint =
      'Email:\nPrawidłowy format to, np. janek_kowalski@gmail.com\n\nHasło:\nMusi składać się z conajmniej 8 znaków, a także zawierać małą i dużą literę, cyfrę oraz znak specjalny. Maksymalna długość to 20 znaków. Oba hasła muszą być identyczne.';

  @override
  // ignore: must_call_super
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegExp _regExpPassword = RegExp(_passwordPattern);
    final node = FocusScope.of(context);
    return _isLoading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : DraggableScrollbar.rrect(
            controller: _rrectController,
            heightScrollThumb: 100,
            backgroundColor: Theme.of(context).accentColor,
            child: SingleChildScrollView(
              controller: _rrectController,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Utwórz konto',
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const ImageContainerParrot(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //
                          //******************************************************* */
                          //Email Form
                          TextFormField(
                            maxLength: 20,
                            style: customTextStyle(context),
                            cursorColor: Theme.of(context).textSelectionColor,
                            decoration: _createInputDecoration(
                              context,
                              'Email',
                              Icons.email,
                              false,
                              null,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
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
                            onEditingComplete: () => node.nextFocus(),
                          ),
                          const SizedBox(height: 10),
                          //
                          //******************************************************* */
                          //Password Form
                          TextFormField(
                            maxLength: 20,
                            style: customTextStyle(context),
                            cursorColor: Theme.of(context).textSelectionColor,
                            decoration: _createInputDecoration(
                              context,
                              'Hasło',
                              Icons.lock_outlined,
                              true,
                              1,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Wprowadź hasło';
                              } else if (!_regExpPassword.hasMatch(val)) {
                                return 'Nieprawidłowe hasło';
                              } else {
                                return null;
                              }
                            },
                            obscureText: _passwordObscure,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            onEditingComplete: () => node.nextFocus(),
                          ),
                          const SizedBox(height: 10),
                          //
                          //******************************************************* */
                          // Repeat Password Form
                          TextFormField(
                            maxLength: 20,
                            style: customTextStyle(context),
                            cursorColor: Theme.of(context).textSelectionColor,
                            decoration: _createInputDecoration(
                              context,
                              'Potwierdź hasło',
                              Icons.lock_outlined,
                              true,
                              2,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Potwierdź hasło';
                              } else if (!_regExpPassword.hasMatch(val)) {
                                return 'Nieprawidłowe hasło';
                              } else if (val != password) {
                                return 'Hasła muszą być identyczne';
                              } else {
                                return null;
                              }
                            },
                            obscureText: _passwordSecondObscure,
                            onChanged: (val) {
                              setState(() {
                                passwordRepeated = val;
                              });
                            },
                            //dodac tu fnkcje jak po klikniecu zaloguj
                            onEditingComplete: _createAccount,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(
                                child: const SizedBox(),
                              ),
                              FlatButton(
                                child: Text(
                                  'Utwórz konto',
                                  style: TextStyle(
                                    color: Theme.of(context).textSelectionColor,
                                  ),
                                ),
                                //confirm to registration
                                onPressed: _createAccount,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void _createAccount() async {
    if (!_formKey.currentState.validate()) {
      _showHint(_hint);
    } else if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result = await _auth.registerWithEmaAndPass(email, password);
      if (result.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        setState(() {
          _isLoading = false;
          error = 'Email jest już używany. Wybierz inny.';
        });
      } else if (result.toString() ==
          '[firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ Unable to resolve host "www.googleapis.com":No address associated with hostname ]') {
        setState(() {
          _isLoading = false;
          error = 'Sprawdź połączenie z internetem';
        });
      }
    }
  }

//Styl tekstu w inputach
  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
      fontSize: 16,
    );
  }

//wlasny model pola do wpisania textu
  InputDecoration _createInputDecoration(BuildContext context, String text,
      IconData icon, bool eyeIcon, int change) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      labelText: text,
      icon: Icon(
        icon,
        color: Theme.of(context).textSelectionColor,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      filled: true,
      suffix: eyeIcon
          ? GestureDetector(
              onTap: () {
                setState(() {
                  if (change == 1) {
                    _passwordObscure = !_passwordObscure;
                  } else if (change == 2) {
                    _passwordSecondObscure = !_passwordSecondObscure;
                  } else
                    return;
                });
              },
              child: Icon(
                Icons.remove_red_eye_outlined,
                size: 20,
                color: Theme.of(context).textSelectionColor,
              ),
            )
          : null,
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
          color: Theme.of(context).textSelectionColor,
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
          color: Theme.of(context).textSelectionColor,
        ),
      ),
    );
  }

  Future<void> _showHint(String hint) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).accentColor,
          title: const Text(
            'Błędne dane!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          content: Text(
            hint,
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
