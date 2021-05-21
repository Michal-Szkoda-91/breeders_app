import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CreateInfoRow extends StatelessWidget {
  final String title;
  final String content;

  const CreateInfoRow({Key key, this.title, this.content}) : super(key: key);

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
        AutoSizeText(
          content,
          maxLines: 3,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
