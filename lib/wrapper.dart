import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/authenticate.dart';
import 'models/user.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserLogged>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return ParrotsRaceListScreen();
    }
  }
}
