import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/models/global_methods.dart';
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
  GlobalMethods _globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PullToRevealTopItemList(
        startRevealed: true,
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
          child: Row(
            children: [
              Expanded(child: createCard(context, index)),
              _globalMethods.arrowConteiner,
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        GestureDetector(
          //Delete all breeds
          onTap: () => _globalMethods.showDeletingDialog(
              context,
              widget.breedingsList[index].name,
              "Czy chcesz usunąć całą hodowlę wraz ze wszystkimi zwierzętami? \nNie można tego cofnąć",
              _deleteBreeds,
              null),
          child: _globalMethods.createActionItem(context, Colors.red,
              MaterialCommunityIcons.delete, "Usuń hodowlę", 14),
        ),
      ],
    );
  }

  Card createCard(BuildContext context, int index) {
    return Card(
      color: Colors.transparent,
      shadowColor: Theme.of(context).cardColor,
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

  Future<void> _deleteBreeds(String name) async {
    final dataProvider = Provider.of<BreedingsList>(context, listen: false);
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    Navigator.of(context).pop();

    await dataProvider.deleteBreeds(_firebaseUser.uid, name).then((_) {
      _globalMethods.showInSnackBar('Usunięto hodowlę.', context);
    }).catchError((error) {
      _globalMethods.showInSnackBar('Operacja nieudana.', context);
    });
  }
}
