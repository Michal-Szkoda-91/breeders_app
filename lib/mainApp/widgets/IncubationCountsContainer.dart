import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IncubationCountsContainer extends StatelessWidget {
  const IncubationCountsContainer({
    Key key,
    @required int incubationTimes,
  })  : _incubationTimes = incubationTimes,
        super(key: key);

  final int _incubationTimes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black45,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AutoSizeText(
                "Aktywnych inkubacji:",
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
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
                  color: Theme.of(context).textSelectionColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              child: Text(
                _incubationTimes.toString(),
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
