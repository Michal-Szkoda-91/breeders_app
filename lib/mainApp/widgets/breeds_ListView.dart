import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_reveal/pull_to_reveal.dart';

import '../animals/parrots/screens/parrot_race_list_screen.dart';
import '../models/breedings_model.dart';
import 'create_breeds_dropdownButton.dart';

class BreedsListView extends StatefulWidget {
  final List<BreedingsModel> breedingsList;

  const BreedsListView(this.breedingsList);

  @override
  _BreedsListViewState createState() => _BreedsListViewState();
}

class _BreedsListViewState extends State<BreedsListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PullToRevealTopItemList(
        itemCount: widget.breedingsList.length,
        itemBuilder: (context, index) {
          return createSlidableCard(context, index);
        },
        revealableHeight: 70,
        revealableBuilder: (BuildContext context, RevealableToggler opener,
            RevealableToggler closer, BoxConstraints constraints) {
          return CreateBreedsDropdownButton();
        },
      ),
    );
  }

  Slidable createSlidableCard(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.30,
      closeOnScroll: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParrotsRaceListScreen(
                  name: widget.breedingsList[index].name,
                ),
              ),
            );
          },
          child: createCard(context, index),
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParrotsRaceListScreen(
                  name: widget.breedingsList[index].name,
                ),
              ),
            );
          },
          child: _createActionItem(context, Colors.indigo,
              MaterialCommunityIcons.home_group, "Moja Hodowla"),
        ),
      ],
      secondaryActions: <Widget>[
        GestureDetector(
          //Delete all breeds
          onTap: () => _showDeletingDialog(widget.breedingsList[index].name),
          child: _createActionItem(context, Colors.red,
              MaterialCommunityIcons.delete, "Usuń hodowlę"),
        ),
      ],
    );
  }

  Card createCard(BuildContext context, int index) {
    return Card(
      elevation: 20,
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  widget.breedingsList[index].pictureUrl,
                ),
                radius: 45,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: AutoSizeText(
                widget.breedingsList[index].name,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 14),
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
            "Czy chcesz usunąć całą hodowlę? \nNie można tego cofnąć.",
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
                _deleteBreeds(name);
                Navigator.of(context).pop();
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

  Future<void> _deleteBreeds(String name) async {
    final dataProvider = Provider.of<BreedingsList>(context, listen: false);
    final _firebaseUser = FirebaseAuth.instance.currentUser;

    await dataProvider.deleteBreeds(_firebaseUser.uid, name).then((_) {
      showInSnackBar('Usunięto hodowlę.', context);
    }).catchError((error) {
      showInSnackBar('Operacja nieudana.', context);
    });
  }

  void showInSnackBar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  }
}
