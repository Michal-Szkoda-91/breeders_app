import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/authenticate.dart';
import 'mainApp/home_screen.dart';
import 'models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserLogged>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
