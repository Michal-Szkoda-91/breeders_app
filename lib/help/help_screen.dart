import 'package:flutter/material.dart';

import '../globalWidgets/mainBackground.dart';
import 'HelpMenuFlatButton.dart';
import 'menuDialogs/archiveDialog.dart';
import 'menuDialogs/delete_races.dart';
import 'menuDialogs/addparrotDialog.dart';
import 'menuDialogs/addPairDialog.dart';
import 'menuDialogs/inkubation_children_Dialog.dart';

class HelpScreen extends StatelessWidget {
  static const String routeName = "/HelpScreen";

  HelpScreen({Key key}) : super(key: key);

  final AddParrotDialog _addParrotDialog = AddParrotDialog();
  final DeleteRaces _deleteRaces = DeleteRaces();
  final AddPairDialog _addPairDialog = AddPairDialog();
  final InkubationChildrenDialog _inkubationChildrenDialog =
      InkubationChildrenDialog();
  final ArchiveDialog _archiveDialog = ArchiveDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Pomoc"),
      ),
      body: MainBackground(
        child: Column(
          children: [
            const SizedBox(height: 15),
            HelpMenuFlatButton(
              title: "1.  Dodawanie / Edycja / Usuwanie Papug",
              function: _addParrotDialog.showMaterialDialog,
            ),
            HelpMenuFlatButton(
              title: "2.  Usuwanie całej rasy",
              function: _deleteRaces.showMaterialDialog,
            ),
            HelpMenuFlatButton(
              title: "3.  Dodawanie / Usuwanie Par",
              function: _addPairDialog.showMaterialDialog,
            ),
            HelpMenuFlatButton(
              title: "4.  Inkubacja / Potomowstwo",
              function: _inkubationChildrenDialog.showMaterialDialog,
            ),
            HelpMenuFlatButton(
              title: "5.  Archiwum Par",
              function: _archiveDialog.showMaterialDialog,
            ),
          ],
        ),
      ),
    );
  }
}
