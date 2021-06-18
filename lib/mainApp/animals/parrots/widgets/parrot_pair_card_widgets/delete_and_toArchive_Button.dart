import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../screens/editPair_screen.dart';
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
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: FittedBox(
            child: FlatButton.icon(
              padding: const EdgeInsets.all(5.0),
              label: Text(
                "Usuń",
                style: TextStyle(
                  color: Colors.red,
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
                      widget.pairList[widget.index].picUrl,
                    );
                  },
                  null,
                );
              },
            ),
          ),
        ),
        widget.pairList[widget.index].isArchive == "false"
            ? Container(
                width: MediaQuery.of(context).size.width * 0.33,
                child: FittedBox(
                  child: FlatButton.icon(
                    padding: const EdgeInsets.all(5.0),
                    label: Text(
                      "Archiwum",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    icon: const Icon(
                      MaterialCommunityIcons.archive,
                      color: Colors.blueGrey,
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
                            widget.pairList[widget.index].maleRingNumber,
                          );
                        },
                        null,
                      );
                    },
                  ),
                ),
              )
            : Container(),
        widget.pairList[widget.index].isArchive == "false"
            ? Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: FittedBox(
                  child: FlatButton.icon(
                    padding: const EdgeInsets.all(5.0),
                    label: Text(
                      "Edytuj",
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                    icon: const Icon(
                      MaterialCommunityIcons.circle_edit_outline,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      _editPair();
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void _editPair() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPairScreen(
          raceName: widget.pairList[widget.index].race,
          pairColor: widget.pairList[widget.index].pairColor,
          pairID: widget.pairList[widget.index].id,
          pairingData: widget.pairList[widget.index].pairingData,
          picUrl: widget.pairList[widget.index].picUrl,
        ),
      ),
    );
  }
}
