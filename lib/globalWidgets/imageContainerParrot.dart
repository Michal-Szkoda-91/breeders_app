import 'package:flutter/material.dart';

class ImageContainerParrot extends StatelessWidget {
  const ImageContainerParrot({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(
          "assets/parrot.jpg",
          fit: BoxFit.cover,
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
