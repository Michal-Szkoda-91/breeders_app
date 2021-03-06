import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../models/parrot_model.dart';
import 'Parrot_Ring_Button.dart';

class TableContentRow extends StatelessWidget {
  const TableContentRow({
    required this.title,
    required this.width,
    required this.index,
    required this.isPair,
    required this.createdParrotList,
  });

  final String title;
  final double width;
  final int index;
  final bool isPair;
  final List<Parrot> createdParrotList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0),
      decoration: const BoxDecoration(
        border: const Border(
          right: const BorderSide(color: Colors.black, width: 1.0),
          bottom: const BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 60,
      width: width,
      alignment: Alignment.center,
      child: createdParrotList[index].pairRingNumber == "brak" && isPair
          ? AutoSizeText(
              title,
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )
          : ParrotRingButton(
              createdParrotList: createdParrotList,
              index: index,
              title: title,
            ),
    );
  }
}
