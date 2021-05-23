import 'package:flutter/material.dart';

class TableContentNotesRow extends StatelessWidget {
  const TableContentNotesRow({
    Key key,
    @required this.title,
    @required this.width,
  }) : super(key: key);

  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 60,
      width: width,
      alignment: Alignment.center,
      child: title.length > 25
          ? GestureDetector(
              onTap: () {
                return _showInfo(context, title);
              },
              child: Text(
                title.substring(0, 20) + "... ->",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Future<void> _showInfo(BuildContext context, String title) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text(
            title,
            style: new TextStyle(
              fontSize: 14,
              color: Theme.of(context).textSelectionColor,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
