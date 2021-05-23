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
        Container(
          child: AutoSizeText(
            title,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context).hintColor,
            ),
            softWrap: true,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: AutoSizeText(
            content,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
