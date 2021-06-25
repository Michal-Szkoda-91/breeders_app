import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/addPairParrot_screen.dart';

class CreatePairingParrotDropdownButton extends StatefulWidget {
  final String raceName;

  const CreatePairingParrotDropdownButton({required this.raceName});
  @override
  _CreatePairingParrotDropdownButtonState createState() =>
      _CreatePairingParrotDropdownButtonState();
}

class _CreatePairingParrotDropdownButtonState
    extends State<CreatePairingParrotDropdownButton> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  String url = 'assets/image/parrotsRace/parrot_Icon.jpg';
  String name = 'Utwórz Parę';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToAddPairParrotScreen(widget.raceName);
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.72,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: new Row(
          children: [
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(
                  url,
                ),
              ),
            ),
            const SizedBox(width: 10),
            AutoSizeText(
              name,
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontSize: MediaQuery.of(context).size.width > 350 ? 18 : 14,
              ),
            ),
            const Expanded(
              child: const SizedBox(),
            ),
            Icon(
              Icons.add,
              color: Theme.of(context).textSelectionTheme.selectionColor,
              size: 30,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  void _navigateToAddPairParrotScreen(String raceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPairScreen(
          raceName: raceName,
        ),
      ),
    );
  }
}
