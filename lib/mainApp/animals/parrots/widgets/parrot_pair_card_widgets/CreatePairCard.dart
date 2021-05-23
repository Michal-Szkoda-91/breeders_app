import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';

import 'package:flutter/material.dart';

import '../add_child_button.dart';
import '../children_list.dart';
import '../egg_expansionTile.dart';
import 'createInfoRow.dart';
import 'createInfoRowParrot.dart';
import 'delete_and_toArchive_Button.dart';
import 'pairCircularContainer.dart';

class CreatePairCard extends StatelessWidget {
  final int index;
  final List<ParrotPairing> pairList;
  final String race;
  final Function delete;
  final Function toArchive;

  CreatePairCard({
    Key key,
    this.index,
    this.pairList,
    this.race,
    this.delete,
    this.toArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(
            left: 15,
            right: 10,
            top: 80,
            bottom: 15,
          ),
          color: pairList[index].isArchive == "false"
              ? Colors.transparent
              : Colors.grey[700],
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateInfoRow(
                  title: "Data utworzenia: ",
                  content: pairList[index].pairingData,
                ),
                const SizedBox(height: 3),
                CreateInfoRow(
                  title: "Kolor:",
                  content: pairList[index].pairColor,
                ),
                const SizedBox(height: 3),
                CreateInfoRowParrot(
                  race: race,
                  title: "Samica(0,1): ",
                  content: pairList[index].femaleRingNumber,
                ),
                const SizedBox(height: 3),
                CreateInfoRowParrot(
                  race: race,
                  title: "Samiec(1,0): ",
                  content: pairList[index].maleRingNumber,
                ),
                Divider(
                  color: Theme.of(context).textSelectionColor,
                ),
                DeleteAndArchiveButtons(
                  index: index,
                  pairList: pairList,
                  delete: delete,
                  toArchive: toArchive,
                ),
                pairList[index].isArchive == "false"
                    ? Divider(
                        color: Theme.of(context).textSelectionColor,
                      )
                    : Center(),
                pairList[index].isArchive == "false"
                    ? EggExpansionTile(
                        pairList[index].showEggsDate,
                        race,
                        pairList[index].id,
                        false,
                      )
                    : Center(),
                Divider(
                  color: Theme.of(context).textSelectionColor,
                ),
                pairList[index].isArchive == "false"
                    ? AddPairChildButton(
                        pair: pairList[index],
                        raceName: race,
                      )
                    : SizedBox(
                        height: 1,
                      ),
                const SizedBox(
                  height: 3,
                ),
                ChildrenList(
                  pairId: pairList[index].id,
                  raceName: race,
                ),
              ],
            ),
          ),
        ),
        pairList[index].picUrl == "brak"
            ? PairCircleAvatar(
                picUrl: pairList[index].picUrl,
                isAssets: true,
                size: 60,
              )
            : PairCircleAvatar(
                picUrl: pairList[index].picUrl,
                isAssets: false,
                size: 60,
              ),
      ],
    );
  }
}
