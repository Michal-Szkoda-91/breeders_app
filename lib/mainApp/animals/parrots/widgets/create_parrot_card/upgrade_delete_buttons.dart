import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:flutter/material.dart';

import '../../models/parrot_model.dart';
import '../../screens/addParrot_screen.dart';
import '../../../../../models/global_methods.dart';

class DeleteUpgradeButtons extends StatelessWidget {
  final Function delete;
  final int index;
  final List<Parrot> createdParrotList;
  final String raceName;

  DeleteUpgradeButtons({
    required this.delete,
    required this.index,
    required this.createdParrotList,
    required this.raceName,
  });

  final GlobalMethods _globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              _globalMethods.showDeletingDialog(
                context: context,
                function: delete,
                title: createdParrotList[index].ringNumber,
                text: "Napewno usunąć tę papugę z hodowli?",
                parrot: createdParrotList[index],
              );
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 30,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                _globalMethods.createRoute(
                  AddParrotScreen(
                    parrotMap: {
                      "url": "assets/image/parrotsRace/$raceName.jpg",
                      "name": "Edytuj Papugę",
                      "icubationTime": "21"
                    },
                    parrot: createdParrotList[index],
                    addFromChild: false,
                    pair: ParrotPairing(
                      femaleRingNumber: '',
                      id: '',
                      isArchive: '',
                      maleRingNumber: '',
                      pairColor: '',
                      pairingData: '',
                      picUrl: '',
                      race: '',
                      showEggsDate: '',
                    ),
                    race: '',
                    data: '',
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.edit,
              color: Colors.lightBlueAccent,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
