import 'package:flutter/material.dart';

import '../globalWidgets/mainBackground.dart';

class HelpScreen extends StatelessWidget {
  static const String routeName = "/HelpScreen";

  const HelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Pomoc"),
      ),
      body: MainBackground(
        child: Center(),
      ),
    );
  }
}
