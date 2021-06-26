import 'package:flutter/material.dart';

import '../../models/pairing_model.dart';
import '../add_child_button.dart';
import '../children_list.dart';
import '../egg_expansionTile.dart';
import 'createInfoRow.dart';
import 'createInfoRowParrot.dart';
import 'delete_and_toArchive_Button.dart';
import 'pairCircularContainer.dart';

class CreatePairCard extends StatefulWidget {
  final int index;
  final List<ParrotPairing> pairList;
  final String race;
  final Function delete;
  final Function toArchive;

  CreatePairCard({
    required this.index,
    required this.pairList,
    required this.race,
    required this.delete,
    required this.toArchive,
  });

  @override
  _CreatePairCardState createState() => _CreatePairCardState();
}

class _CreatePairCardState extends State<CreatePairCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin:
              const EdgeInsets.only(left: 15, right: 10, top: 80, bottom: 15),
          color: widget.pairList[widget.index].isArchive == "false"
              ? Colors.transparent
              : Colors.grey[700],
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 40.0, 5.0, 10.0),
            child: ExpansionTile(
              onExpansionChanged: (_) {
                if (mounted) {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              },
              title: _isExpanded
                  ? Center()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Samiec(1.0) - ${widget.pairList[widget.index].maleRingNumber}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                          ),
                        ),
                        Text(
                          "Samica(0.1) - ${widget.pairList[widget.index].femaleRingNumber}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                          ),
                        ),
                        Text(
                          "Kolor - ${widget.pairList[widget.index].pairColor}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                          ),
                        ),
                        Text(
                          "Data parowania - ${widget.pairList[widget.index].pairingData}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                          ),
                        ),
                      ],
                    ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CreateInfoRow(
                      title: "Data utworzenia: ",
                      content: widget.pairList[widget.index].pairingData,
                    ),
                    const SizedBox(height: 3),
                    CreateInfoRow(
                      title: "Kolor:",
                      content: widget.pairList[widget.index].pairColor,
                    ),
                    const SizedBox(height: 3),
                    CreateInfoRowParrot(
                      race: widget.race,
                      title: "Samica(0,1): ",
                      content: widget.pairList[widget.index].femaleRingNumber,
                    ),
                    const SizedBox(height: 3),
                    CreateInfoRowParrot(
                      race: widget.race,
                      title: "Samiec(1,0): ",
                      content: widget.pairList[widget.index].maleRingNumber,
                    ),
                    Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                    ),
                    DeleteAndArchiveButtons(
                      index: widget.index,
                      pairList: widget.pairList,
                      delete: widget.delete,
                      toArchive: widget.toArchive,
                    ),
                    widget.pairList[widget.index].isArchive == "false"
                        ? Divider(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor)
                        : const Center(),
                    widget.pairList[widget.index].isArchive == "false"
                        ? EggExpansionTile(
                            widget.pairList[widget.index].showEggsDate,
                            widget.race,
                            widget.pairList[widget.index].id,
                            false,
                          )
                        : Center(),
                    Divider(
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor),
                    widget.pairList[widget.index].isArchive == "false"
                        ? AddPairChildButton(
                            pair: widget.pairList[widget.index],
                            raceName: widget.race,
                          )
                        : const SizedBox(height: 1),
                    const SizedBox(height: 3),
                    ChildrenList(
                      pairId: widget.pairList[widget.index].id,
                      raceName: widget.race,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        widget.pairList[widget.index].picUrl == "brak"
            ? PairCircleAvatar(
                picUrl: widget.pairList[widget.index].picUrl,
                isAssets: true,
                size: 60,
              )
            : PairCircleAvatar(
                picUrl: widget.pairList[widget.index].picUrl,
                isAssets: false,
                size: 60,
              ),
      ],
    );
  }
}
