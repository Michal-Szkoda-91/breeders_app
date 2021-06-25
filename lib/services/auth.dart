import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/global_methods.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GlobalMethods _globalMethods = GlobalMethods();

  //user create
  UserLogged? _userFromFirebaseUser(User? user) {
    return user != null ? UserLogged(uid: user.uid) : null;
  }

  //servers listen
  Stream<UserLogged?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sing in with Google

  Future singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register user
  Future registerWithEmaAndPass(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user!.sendEmailVerification();
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _globalMethods.showMaterialDialog(
            context, "Istnieje już konto dla wybranego adresu Email.");
      }
    } catch (e) {}
  }

  //login user
  Future singInWithEmailAndPass(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _globalMethods.showMaterialDialog(
            context, "Użytkownik nie istnieje, załóż konto");
      }
    } catch (e) {
      _globalMethods.showMaterialDialog(
          context, "Wystąpił błąd, spróbuj ponownie");
    }
  }

  //sing out user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString);
      return null;
    }
  }
}
