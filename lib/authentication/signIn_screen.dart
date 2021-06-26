import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../mainApp/widgets/google.button.dart';
import '../mainApp/widgets/registraction_question.dart';
import '../mainApp/widgets/reset_password.dart';
import '../globalWidgets/imageContainerParrot.dart';
import '../services/auth.dart';

class SignInScreen extends StatefulWidget {
  final Function changePage;

  const SignInScreen({required this.changePage});
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  ScrollController _rrectController = ScrollController();

  late bool _isLoading;
  @protected
  void initState() {
    super.initState();
    _isLoading = false;
  }

  String email = '';
  String password = '';
  String error = '';

  bool _passwordObscure = true;

  Pattern _passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,20}$';

  final double _sizedBoxHeight = 10.0;

  @override
  Widget build(BuildContext context) {
    RegExp _regExpPassword = RegExp(_passwordPattern.toString());
    final node = FocusScope.of(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DraggableScrollbar.rrect(
            controller: _rrectController,
            heightScrollThumb: 100,
            backgroundColor: Theme.of(context).accentColor,
            child: ListView.builder(
              controller: _rrectController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: _sizedBoxHeight),
                    Text(
                      'Zaloguj się',
                      style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    ImageContainerParrot(),
                    SizedBox(height: _sizedBoxHeight),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //
                            //******************************************************* */
                            //Email Form
                            TextFormField(
                              style: customTextStyle(context),
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionColor,
                              decoration: _createInputDecoration(
                                context,
                                'Email',
                                Icons.email,
                                false,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              onEditingComplete: () => node.nextFocus(),
                            ),
                            SizedBox(height: _sizedBoxHeight),
                            //
                            //******************************************************* */
                            //Password Form
                            TextFormField(
                              maxLength: 20,
                              style: customTextStyle(context),
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionColor,
                              decoration: _createInputDecoration(
                                context,
                                'Hasło',
                                Icons.lock_outlined,
                                true,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                if (val!.isEmpty) {
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Text(
                                    'Zaloguj się',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionColor,
                                    ),
                                  ),
                                  onPressed: confirmSignIn,
                                ),
                              ],
                            ),

                            SizedBox(height: _sizedBoxHeight),
                            GoogleButton(function: _googleSingIn),
                            const SizedBox(height: 45),
                            RegisterQuestion(function: widget.changePage),
                            ResetPassword(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _auth.singInWithEmailAndPass(email, password, context).then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
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
                color: Theme.of(context).textSelectionTheme.selectionColor,
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
