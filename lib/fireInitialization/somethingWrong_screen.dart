import 'package:flutter/material.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Błąd"),
        ),
        body: Center(
          child: Text(
            "Błąd ładowania aplikacji!\nSpróbuj ponownie poźniej",
          ),
        ),
      ),
    );
  }
}
