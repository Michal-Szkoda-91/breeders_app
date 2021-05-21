import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/egg_expansionTile.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/parrot_pair_card_widgets/createInfoRow.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/parrot_pair_card_widgets/createInfoRowParrot.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/parrot_pair_card_widgets/pairCircularContainer.dart';
import 'package:flutter/material.dart';

class IncubationList extends StatelessWidget {
  final List<ParrotPairing> parrotList;

  const IncubationList({this.parrotList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: parrotList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.transparent,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 5),
                  parrotList[index].picUrl == "brak"
                      ? PairCircleAvatar(
                          picUrl: parrotList[index].picUrl,
                          isAssets: true,
                          size: 40,
                        )
                      : PairCircleAvatar(
                          picUrl: parrotList[index].picUrl,
                          isAssets: false,
                          size: 30,
                        ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CreateInfoRow(
                            title: "Data utworzenia pary: ",
                            content: parrotList[index].pairingData,
                          ),
                          const SizedBox(height: 6),
                          CreateInfoRow(
                            title: "Kolor Pary: ",
                            content: parrotList[index].pairColor,
                          ),
                          const SizedBox(height: 6),
                          CreateInfoRowParrot(
                            race: parrotList[index].race,
                            title: "Samica(0,1): ",
                            content: parrotList[index].femaleRingNumber,
                          ),
                          const SizedBox(height: 6),
                          CreateInfoRowParrot(
                            race: parrotList[index].race,
                            title: "Samiec(1,0): ",
                            content: parrotList[index].maleRingNumber,
                          ),
                          Divider(
                            color: Theme.of(context).textSelectionColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              EggExpansionTile(
                parrotList[index].showEggsDate,
                parrotList[index].race,
                parrotList[index].id,
              ),
            ],
          ),
        );
      },
    );
  }
}
