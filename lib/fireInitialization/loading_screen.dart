import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ładowanie"),
        ),
        body: Center(
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
