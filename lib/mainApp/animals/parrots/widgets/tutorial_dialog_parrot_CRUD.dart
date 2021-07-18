import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrotsList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            Container(
              alignment: Alignment.center,
              width: size.width * 0.9,
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Samouczek",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              color: Theme.of(context).primaryColor,
              height: size.height * 0.4,
              width: size.width * 0.9,
              child: Text('obraz nr $_screenNumber'),
            ),
            const SizedBox(height: 5.0),
            Container(
              color: Theme.of(context).primaryColor,
              height: size.height * 0.25,
              width: size.width * 0.9,
              child: Text('Tekst nr $_screenNumber'),
            ),
            const SizedBox(height: 5.0),
            DotsContainer(
              screenNumber: _screenNumber,
            ),
            const SizedBox(height: 5.0),
            Container(
              width: size.width * 0.9,
              color: Theme.of(context).primaryColor,
              child: TextButton.icon(
                onPressed: () async {
                  final SharedPreferences prefs = await _prefs;
                  prefs.setBool('show_Tutorial', true);
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ParrotsRaceListScreen()),
                      (route) => false);
                },
                icon: Icon(Icons.close),
                label: Text("Pomiń"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switfScreen(DragEndDetails detail) {
    if (detail.primaryVelocity! > 0 && _screenNumber > 1) {
      print("________________ w lewo");
      setState(() {
        _screenNumber--;
      });
    } else if (detail.primaryVelocity! < 0 && _screenNumber < 5) {
      print("________________ w prawo");
      setState(() {
        _screenNumber++;
      });
    }
  }
}

class DotsContainer extends StatelessWidget {
  const DotsContainer({
    required this.screenNumber,
  });

  final int screenNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 7,
                    child: CircleAvatar(
                      backgroundColor: i + 1 == screenNumber
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).backgroundColor,
                      radius: 4,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
