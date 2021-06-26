import 'package:flutter/material.dart';

class ImageContainerParrot extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(
          "assets/image/parrot.jpg",
          fit: BoxFit.cover,
          height: 122,
          width: 122,
        ),
      ),
    );
  }
}
