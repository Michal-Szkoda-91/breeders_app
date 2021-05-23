import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:flutter/material.dart';

class NotConnected extends StatelessWidget {
  const NotConnected({
    Key key,
  }) : super(key: key);

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
                color: Theme.of(context).textSelectionColor,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          FlatButton(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Odśwież",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
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
