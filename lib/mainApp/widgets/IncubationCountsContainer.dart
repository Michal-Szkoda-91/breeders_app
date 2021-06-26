import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IncubationCountsContainer extends StatelessWidget {
  const IncubationCountsContainer({
    required this.incubationTimes,
  });

  final int incubationTimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: AutoSizeText(
              "Aktywnych inkubacji:",
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
              ),
            ),
          ),
          Container(
            width: 33,
            height: 33,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).canvasColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Text(
              incubationTimes.toString(),
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
