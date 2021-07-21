import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/parrot_race_list_screen.dart';
import 'tutorial_widgets/dots_container.dart';
import 'tutorial_widgets/tutorial_text_container.dart';

class TutorialParrotCrud extends StatefulWidget {
  @override
  _TutorialParrotCrudState createState() => _TutorialParrotCrudState();
}

class _TutorialParrotCrudState extends State<TutorialParrotCrud> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<int> list = [1, 2, 3, 4, 5, 6, 7];
  int _screenNumber = 0;
  AssetImage image = AssetImage("assets/tutorial/add_parrot.gif");
  String title = 'Dodaj papugę';

  var images = [
    AssetImage("assets/tutorial/add_parrot.gif"),
    AssetImage("assets/tutorial/edit_parrot.gif"),
    AssetImage('assets/tutorial/add_pair.gif'),
    AssetImage('assets/tutorial/edit_pair.gif'),
    AssetImage('assets/tutorial/incubation.gif'),
    AssetImage('assets/tutorial/archive.gif'),
    AssetImage('assets/tutorial/children.gif'),
  ];

  var titles = [
    'Dodaj Papugę',
    'Edytuj / Usuń Papugę',
    'Dodaj Parę',
    'Edytuj / Usuń Parę',
    'Inkubacja',
    'Archiwum Par',
    'Potomstwo',
  ];

  void _loadImage() {
    image.evict();
    setState(() {
      image = images[_screenNumber];
      title = titles[_screenNumber];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          color: Theme.of(context).backgroundColor,
          height: size.height * 0.75,
          width: size.width * 0.95,
          padding: EdgeInsets.zero,
          child: CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (i, rason) {
                setState(
                  () {
                    _screenNumber = i;
                  },
                );
                _loadImage();
              },
              height: size.height * 0.75,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
            ),
            items: list.map(
              (e) {
                return Column(
                  children: [
                    const SizedBox(height: 5.0),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: size.height * 0.05,
                          width: size.width * 0.9,
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: size.height * 0.55,
                          width: size.width * 0.9,
                          child: Image.asset(image.assetName),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    TutorialTextContainer(screenNumber: e),
                  ],
                );
              },
            ).toList(),
          ),
        ),
        DotsContainer(screenNumber: _screenNumber + 1),
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
    );
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
