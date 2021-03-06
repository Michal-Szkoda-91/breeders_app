import 'package:flutter/material.dart';

class TableContentNormalRow extends StatelessWidget {
  const TableContentNormalRow({
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
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textSelectionTheme.selectionColor,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
