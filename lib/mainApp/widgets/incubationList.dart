import 'package:flutter/material.dart';

import '../animals/parrots/models/pairing_model.dart';
import '../animals/parrots/widgets/egg_expansionTile.dart';
import '../animals/parrots/widgets/parrot_pair_card_widgets/createInfoRow.dart';
import '../animals/parrots/widgets/parrot_pair_card_widgets/createInfoRowParrot.dart';
import '../animals/parrots/widgets/parrot_pair_card_widgets/pairCircularContainer.dart';

class IncubationList extends StatelessWidget {
  final List<ParrotPairing> parrotList;

  const IncubationList({required this.parrotList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: parrotList.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(0),
          color: Colors.transparent,
          child: Column(
            children: [
              const SizedBox(height: 5),
              Divider(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                thickness: 2,
              ),
              parrotList[index].picUrl == "brak"
                  ? PairCircleAvatar(
                      picUrl: parrotList[index].picUrl,
                      isAssets: true,
                      size: 30,
                    )
                  : PairCircleAvatar(
                      picUrl: parrotList[index].picUrl,
                      isAssets: false,
                      size: 30,
                    ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CreateInfoRow(
                      title: "Data utworzenia: ",
                      content: parrotList[index].pairingData,
                    ),
                    const SizedBox(height: 6),
                    CreateInfoRow(
                      title: "Kolor: ",
                      content: parrotList[index].pairColor,
                    ),
                    const SizedBox(height: 6),
                    CreateInfoRowParrot(
                      race: parrotList[index].race,
                      title: "Samica(0,1):",
                      content: parrotList[index].femaleRingNumber,
                    ),
                    const SizedBox(height: 6),
                    CreateInfoRowParrot(
                      race: parrotList[index].race,
                      title: "Samiec(1,0):",
                      content: parrotList[index].maleRingNumber,
                    ),
                  ],
                ),
              ),
              EggExpansionTile(
                parrotList[index].showEggsDate,
                parrotList[index].race,
                parrotList[index].id,
                true,
              ),
            ],
          ),
        );
      },
    );
  }
}
