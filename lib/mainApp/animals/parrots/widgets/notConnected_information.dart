import 'package:flutter/material.dart';

import '../screens/parrot_race_list_screen.dart';

class NotConnected extends StatelessWidget {
  const NotConnected({required});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 100,
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              "Brak połączenia z internetem, Połącz i spróbuj ponownie wczytać dane",
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Odśwież",
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 24,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParrotsRaceListScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
