import 'package:flutter/material.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Błąd"),
        ),
        body: Center(
          child: const Text(
            "Błąd ładowania aplikacji!\nSpróbuj ponownie poźniej",
          ),
        ),
      ),
    );
  }
}
