import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../models/pairing_model.dart';
import '../../../../../models/global_methods.dart';

class DeleteAndArchiveButtons extends StatefulWidget {
  final int index;
  final List<ParrotPairing> pairList;
  final Function delete;
  final Function toArchive;

  DeleteAndArchiveButtons({
    @required this.index,
    this.pairList,
    this.delete,
    this.toArchive,
  });

  @override
  _DeleteAndArchiveButtonsState createState() =>
      _DeleteAndArchiveButtonsState();
}

class _DeleteAndArchiveButtonsState extends State<DeleteAndArchiveButtons> {
  GlobalMethods _globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton.icon(
          padding: const EdgeInsets.all(5.0),
          label: Text(
            "Usuń Parę",
            style: TextStyle(
              color: Colors.red,
              fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
            ),
          ),
          icon: const Icon(
            MaterialCommunityIcons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            _globalMethods.showDeletingDialog(
              context,
              "Usuń parę",
              "Napewno usunąć wybraną parę z hodowli?",
              (_) {
                widget.delete(
                    widget.pairList[widget.index].id,
                    widget.pairList[widget.index].femaleRingNumber,
                    widget.pairList[widget.index].maleRingNumber,
                    widget.pairList[widget.index].picUrl);
              },
              null,
            );
          },
        ),
        widget.pairList[widget.index].isArchive == "false"
            ? FlatButton.icon(
                padding: const EdgeInsets.all(5.0),
                label: Text(
                  "Do Archiwum",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
                  ),
                ),
                icon: const Icon(
                  MaterialCommunityIcons.archive,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _globalMethods.showDeletingDialog(
                    context,
                    "Przenieś do archiwum",
                    "Napewno ustawić wybraną parę jako nie aktywną? \nNie można cofnąć operacji",
                    (_) {
                      widget.toArchive(
                          widget.pairList[widget.index].id,
                          widget.pairList[widget.index].femaleRingNumber,
                          widget.pairList[widget.index].maleRingNumber);
                    },
                    null,
                  );
                },
              )
            : const Center(),
      ],
    );
  }
}
