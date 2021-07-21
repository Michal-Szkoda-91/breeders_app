import 'package:flutter/material.dart';

class TutorialPicContainer extends StatefulWidget {
  const TutorialPicContainer({
    required this.screenNumber,
  });

  final int screenNumber;

  @override
  _TutorialPicContainerState createState() => _TutorialPicContainerState();
}

class _TutorialPicContainerState extends State<TutorialPicContainer> {
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
      image = images[widget.screenNumber - 1];
      title = titles[widget.screenNumber - 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadImage();
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: size.height * 0.05,
          width: size.width * 0.9,
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: size.height * 0.55,
          width: size.width * 0.9,
          child: Image.asset(image.assetName),
        ),
      ],
    );
  }
}
