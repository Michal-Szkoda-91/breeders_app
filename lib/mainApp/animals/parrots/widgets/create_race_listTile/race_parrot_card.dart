import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'action_button.dart';

class RaceParrotCard extends StatelessWidget {
  const RaceParrotCard(
      {Key key,
      @required this.index,
      @required this.raceName,
      @required this.parrotCount,
      @required this.activeRace,
      this.navToBreed,
      this.navToPair})
      : super(key: key);

  final int index;
  final String raceName;
  final int parrotCount;
  final String activeRace;
  final Function navToBreed;
  final Function navToPair;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
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
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 20,
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
                                color: Theme.of(context).textSelectionColor,
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
                                  color: Theme.of(context).textSelectionColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),
                              child: Text(
                                parrotCount.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
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
                      color: Colors.pink[300],
                      icon: MaterialCommunityIcons.heart_multiple,
                      name: "Parowanie",
                      padding: 5,
                      function: navToPair,
                      raceName: raceName,
                    ),
                    ActionButton(
                      color: Colors.blueAccent,
                      icon: MaterialCommunityIcons.home_group,
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
