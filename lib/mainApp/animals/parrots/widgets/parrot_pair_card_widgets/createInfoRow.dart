import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CreateInfoRow extends StatelessWidget {
  final String title;
  final String content;

  const CreateInfoRow({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
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
          const SizedBox(width: 5),
          Expanded(
            child: AutoSizeText(content,
                maxLines: 2,
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
