import 'package:flutter/material.dart';

class MainBackground extends StatelessWidget {
  final Widget child;

  const MainBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
            "assets/image/background.jpg",
          ),
          fit: BoxFit.fill,
        ),
      ),
      // alignment: Alignment.center,
      child: child,
    );
  }
}
