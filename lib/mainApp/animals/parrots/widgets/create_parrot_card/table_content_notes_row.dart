import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class TableContentNotesRow extends StatelessWidget {
  const TableContentNotesRow({
    required this.title,
    required this.width,
  });

  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        border: const Border(
          right: const BorderSide(color: Colors.black, width: 1.0),
          bottom: const BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 60,
      width: width,
      alignment: Alignment.center,
      child: title.length > 25
          ? GestureDetector(
              onTap: () async {
                return _showInfo(context, title);
              },
              child: Text(
                title.substring(0, 20) + "... ->",
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Future _showInfo(BuildContext context, String title) {
    return showAnimatedDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text(
            title,
            style: new TextStyle(
              fontSize: 14,
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 2),
    );
  }
}
