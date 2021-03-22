import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_reveal/pull_to_reveal.dart';

import '../models/swapInformation_model.dart';
import '../../parrots/screens/parrotsList.dart';
import '../models/parrot_model.dart';
import 'parrots_race_AddDropdownButton.dart';

class CreateParrotRaceListTile extends StatefulWidget {
  const CreateParrotRaceListTile({
    this.activeRaceList,
  });

  final List<String> activeRaceList;

  @override
  _CreateParrotRaceListTileState createState() =>
      _CreateParrotRaceListTileState();
}

class _CreateParrotRaceListTileState extends State<CreateParrotRaceListTile> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<Parrot> _parrotList = [];

  int _countingParrot(String raceName, List<Parrot> parrotList) {
    int count = 0;
    parrotList.forEach((parrot) {
      if (parrot.race == raceName) {
        count++;
      }
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<ParrotsList>(context);
    _parrotList = dataProvider.getParrotList;
    return Expanded(
      child: PullToRevealTopItemList(
        revealableHeight: 65,
        itemCount: widget.activeRaceList.length,
        itemBuilder: (context, index) {
          return createSlidableCard(context, index);
        },
        revealableBuilder: (BuildContext context, RevealableToggler opener,
            RevealableToggler closer, BoxConstraints constraints) {
          return Column(
            children: [
              CreateParrotsDropdownButton(),
            ],
          );
        },
      ),
    );
  }

  Slidable createSlidableCard(BuildContext context, int index) {
    final dataProvider = Provider.of<SwapInformationModel>(context);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.30,
      closeOnScroll: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            dataProvider.changeSize();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: createCard(context, index),
          ),
        ),
      ),
      actions: <Widget>[
        _createActionItem(context, Colors.pink[300],
            MaterialCommunityIcons.heart_multiple, "Parowanie"),
        GestureDetector(
          onTap: () {
            _navigateToParrotsList(widget.activeRaceList[index]);
          },
          child: _createActionItem(context, Colors.indigo,
              MaterialCommunityIcons.home_group, "Hodowla"),
        ),
      ],
      secondaryActions: <Widget>[
        GestureDetector(
          onTap: () {
            _showDeletingDialog(widget.activeRaceList[index]);
          },
          child: _createActionItem(context, Colors.red,
              MaterialCommunityIcons.delete, "Usuń hodowlę"),
        ),
      ],
    );
  }

  void _navigateToParrotsList(String raceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParrotsListScreen(
          raceName: raceName,
        ),
      ),
    );
  }

  Card createCard(BuildContext context, int index) {
    return Card(
      elevation: 20,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 37,
                backgroundImage: AssetImage(
                  "assets/image/parrotsRace/${widget.activeRaceList[index]}.jpg",
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: AutoSizeText(
                    widget.activeRaceList[index],
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: AutoSizeText(
                        "Ilość ptaków: ",
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          color: Theme.of(context).textSelectionColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        _countingParrot(
                                widget.activeRaceList[index], _parrotList)
                            .toString(),
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
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _createActionItem(
    BuildContext context,
    Color color,
    IconData icon,
    String name,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Theme.of(context).textSelectionColor,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              child: AutoSizeText(
                name,
                maxLines: 2,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeletingDialog(String name) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            // "Uwaga!",
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          content: Text(
            "Czy chcesz usunąć wszystkie papugi z hodowli: $name? \nNie można tego cofnąć.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Usuń",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                _deleteRace(name);
              },
            ),
            TextButton(
              child: Text(
                "Anuluj",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRace(String name) async {
    final dataProvider = Provider.of<ParrotsList>(context, listen: false);
    final _firebaseUser = FirebaseAuth.instance.currentUser;

    await dataProvider.deleteRaceList(_firebaseUser.uid, name).then((_) {
      showInSnackBar('Usunięto hodowlę.', context);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ParrotsRaceListScreen(
            name: "Hodowla Papug",
          ),
        ),
      );
    }).catchError((error) {
      showInSnackBar('Operacja nieudana.', context);
    });
  }

  void showInSnackBar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  }
}
