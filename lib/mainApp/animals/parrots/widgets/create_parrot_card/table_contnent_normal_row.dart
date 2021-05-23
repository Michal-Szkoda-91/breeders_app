import 'package:flutter/material.dart';

class TableContentNormalRow extends StatelessWidget {
  const TableContentNormalRow({
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
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
