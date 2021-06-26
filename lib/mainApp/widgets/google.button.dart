import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    required this.function,
  });

  final Function function;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Theme.of(context).accentColor,
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        function();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/image/google_logo.png',
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AutoSizeText(
                'Logowanie Google',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
