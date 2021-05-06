import 'package:flutter/material.dart';

class ImageContainerChinchila extends StatelessWidget {
  const ImageContainerChinchila({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(
          "assets/image/parrot.jpg",
          fit: BoxFit.cover,
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
