import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/addPairParrot_screen.dart';

class CreatePairingParrotDropdownButton extends StatefulWidget {
  final String raceName;

  const CreatePairingParrotDropdownButton({Key key, this.raceName})
      : super(key: key);
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
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            new Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        url,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  name,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Icon(
                  Icons.add,
                  color: Theme.of(context).textSelectionColor,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).textSelectionColor,
            ),
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
