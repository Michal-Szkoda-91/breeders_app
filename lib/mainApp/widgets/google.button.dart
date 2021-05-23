import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key key,
    @required this.function,
  }) : super(key: key);

  final Function function;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width.toString());
    return RaisedButton(
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      splashColor: Theme.of(context).accentColor,
      color: Theme.of(context).primaryColor,
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
                'Zaloguj się przez Google',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
