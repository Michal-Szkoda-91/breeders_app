import 'package:breeders_app/mainApp/widgets/google.button.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../globalWidgets/imageContainerParrot.dart';
import '../services/auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  ScrollController _rrectController = ScrollController();

  bool _isLoading;
  @protected
  void initState() {
    super.initState();
    _isLoading = false;
  }

  String email = '';
  String password = '';
  String error = '';

  bool _passwordObscure = true;

  Pattern _passwordPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!?_@#\$&*~]).{8,20}$';

  final double _sizedBoxHeight = 10.0;

  @override
  Widget build(BuildContext context) {
    RegExp _regExpPassword = RegExp(_passwordPattern);
    final node = FocusScope.of(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DraggableScrollbar.rrect(
            controller: _rrectController,
            heightScrollThumb: 100,
            backgroundColor: Theme.of(context).accentColor,
            child: SingleChildScrollView(
              controller: _rrectController,
              child: Column(
                children: [
                  SizedBox(height: _sizedBoxHeight),
                  Text(
                    'Zaloguj się',
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: _sizedBoxHeight),
                  const ImageContainerParrot(),
                  SizedBox(height: _sizedBoxHeight),
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
                          SizedBox(height: _sizedBoxHeight),
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
                            onEditingComplete: confirmSignIn,
                          ),
                          SizedBox(height: _sizedBoxHeight),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(),
                              ),
                              FlatButton(
                                child: Text(
                                  'Zaloguj się',
                                  style: TextStyle(
                                    color: Theme.of(context).textSelectionColor,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: confirmSignIn,
                              ),
                            ],
                          ),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: _sizedBoxHeight),
                          GoogleButton(function: _googleSingIn),
                          SizedBox(height: _sizedBoxHeight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _googleSingIn() async {
    setState(() {
      _isLoading = true;
    });
    dynamic result = await _auth.singInWithGoogle();
    if (result == null) {
      setState(() {
        _isLoading = false;
      });
    } else {
      return;
    }
  }

  void confirmSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result = await _auth.singInWithEmailAndPass(email, password);
      if (result.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        setState(() {
          _isLoading = false;
          error = 'Użytkownik nie istnieje, sprawdź email.';
        });
      } else if (result.toString() ==
          '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
        setState(() {
          _isLoading = false;
          error = 'Nieprawidłowe hasło.';
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

  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
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
                  _passwordObscure = !_passwordObscure;
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
}
