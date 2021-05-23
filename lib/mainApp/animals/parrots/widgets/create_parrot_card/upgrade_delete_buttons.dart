import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DeleteUpgradeButtons extends StatelessWidget {
  final Function delete;
  final int index;
  final List<Parrot> createdParrotList;

  DeleteUpgradeButtons(
      {Key key, this.delete, this.index, this.createdParrotList})
      : super(key: key);

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
                context,
                createdParrotList[index].ringNumber,
                "Napewno usunąć tę papugę z hodowli?",
                delete,
                createdParrotList[index],
              );
            },
            child: Icon(
              Icons.delete,
              color: Colors.red,
              size: 30,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParrotScreen(
                    parrotMap: {
                      "url": "assets/image/parrot.jpg",
                      "name": "Edytuj Papugę",
                      "icubationTime": "21"
                    },
                    parrot: createdParrotList[index],
                  ),
                ),
              );
            },
            child: Icon(
              MaterialCommunityIcons.circle_edit_outline,
              color: Colors.lightBlueAccent,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
