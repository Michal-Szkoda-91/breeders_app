import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'action_button.dart';

class RaceParrotCard extends StatelessWidget {
  const RaceParrotCard(
      {required this.index,
      required this.raceName,
      required this.parrotCount,
      required this.activeRace,
      required this.navToBreed,
      required this.navToPair});

  final int index;
  final String raceName;
  final int parrotCount;
  final String activeRace;
  final Function navToBreed;
  final Function navToPair;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
          color: Colors.transparent,
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: const Center(),
                    ),
                    const SizedBox(width: 7.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          activeRace,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              "Ilość ptaków: ",
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor,
                              ),
                            ),
                            const SizedBox(width: 7.0),
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
                                parrotCount.toString(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(
                      color: Colors.pink.shade300,
                      icon: Icons.favorite_border_sharp,
                      name: "Parowanie",
                      padding: 5,
                      function: navToPair,
                      raceName: raceName,
                    ),
                    ActionButton(
                      color: Colors.blueAccent,
                      icon: Icons.home,
                      name: "Hodowla",
                      padding: 5,
                      function: navToBreed,
                      raceName: raceName,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CircleAvatar(
            radius: 44,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage(
                "assets/image/parrotsRace/$raceName.jpg",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
