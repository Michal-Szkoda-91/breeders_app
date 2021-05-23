import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InfoParrowRow extends StatelessWidget {
  const InfoParrowRow({
    Key key,
    @required this.title,
    @required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          style: TextStyle(
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 10),
        AutoSizeText(
          content,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        Divider(
          color: Theme.of(context).textSelectionColor,
        )
      ],
    );
  }
}
