import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ContentColumn extends StatelessWidget {
  final String showEggDate;
  final int daysToBorn;
  final String bornTimeString;

  const ContentColumn(
      {Key key, this.showEggDate, this.daysToBorn, this.bornTimeString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: AutoSizeText(
                showEggDate == "brak" ? "Brak jajek" : "Dni do wylęgu:",
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
            ),
            const Spacer(),
            showEggDate != "brak"
                ? Container(
                    width: 33,
                    height: 33,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: daysToBorn <= 6 && daysToBorn > 3
                          ? Colors.orange
                          : daysToBorn <= 3
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                      border: Border.all(
                        color: Theme.of(context).textSelectionColor,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      daysToBorn < 0 ? "-" : daysToBorn.toString(),
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                : const Center(),
          ],
        ),
        const SizedBox(height: 5),
        showEggDate != "brak"
            ? Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: AutoSizeText(
                      "Start inkubacji: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize:
                            MediaQuery.of(context).size.width < 330 ? 10 : 14,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    showEggDate,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize:
                          MediaQuery.of(context).size.width < 330 ? 10 : 14,
                    ),
                  ),
                ],
              )
            : const Center(),
        showEggDate != "brak"
            ? Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: AutoSizeText(
                      "data wylęgu: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize:
                            MediaQuery.of(context).size.width < 330 ? 10 : 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    bornTimeString,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize:
                          MediaQuery.of(context).size.width < 330 ? 10 : 14,
                    ),
                  ),
                ],
              )
            : const Center(),
      ],
    );
  }
}