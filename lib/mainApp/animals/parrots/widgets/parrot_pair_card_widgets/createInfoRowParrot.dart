import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../parrotDialogInformation.dart';

class CreateInfoRowParrot extends StatelessWidget {
  const CreateInfoRowParrot({
    Key key,
    @required this.title,
    @required this.content,
    this.race,
  }) : super(key: key);

  final String title;
  final String content;
  final String race;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: MediaQuery.of(context).size.width > 330 ? 14 : 10,
          ),
          softWrap: true,
        ),
        InkWell(
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                backgroundColor: Theme.of(context).backgroundColor,
                scrollable: true,
                title: new Text(
                  content,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                  ),
                ),
                content: ParrotDialogInformation(
                  parrotRace: race,
                  parrotRing: content,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          },
          child: Container(
            alignment: Alignment.center,
            height: 60,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black45,
            ),
            padding: const EdgeInsets.all(10.0),
            child: AutoSizeText(
              content,
              maxLines: 2,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
