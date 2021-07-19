import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/parrot_race_list_screen.dart';
import 'tutorial_widgets/dots_container.dart';
import 'tutorial_widgets/tutorial_pic_container.dart';
import 'tutorial_widgets/tutorial_text_container.dart';

class TutorialParrotCrud extends StatefulWidget {
  @override
  _TutorialParrotCrudState createState() => _TutorialParrotCrudState();
}

class _TutorialParrotCrudState extends State<TutorialParrotCrud> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _screenNumber = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onHorizontalDragEnd: _switfScreen,
      child: Container(
        height: size.height * 0.85,
        width: size.width * 0.95,
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            TutorialPicContainer(screenNumber: _screenNumber),
            const SizedBox(height: 5.0),
            TutorialTextContainer(screenNumber: _screenNumber),
            DotsContainer(screenNumber: _screenNumber),
            Container(
              width: size.width * 0.9,
              color: Theme.of(context).primaryColor,
              child: TextButton.icon(
                onPressed: _closeDialog,
                icon: Icon(Icons.close),
                label: Text("Pomiń samouczek"),
              ),
            ),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  void _switfScreen(DragEndDetails detail) {
    if (detail.primaryVelocity! > 0 && _screenNumber > 1) {
      setState(() {
        _screenNumber--;
      });
    } else if (detail.primaryVelocity! < 0 && _screenNumber < 7) {
      setState(() {
        _screenNumber++;
      });
    }
  }

  _closeDialog() async {
    final SharedPreferences prefs = await _prefs;
    bool? firstTime = prefs.getBool('show_Tutorial');
    if (firstTime == null) {
      prefs.setBool('show_Tutorial', true);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ParrotsRaceListScreen()),
          (route) => false);
    } else {
      Navigator.pop(context);
    }
  }
}
