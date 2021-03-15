import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrotsList.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/parrot_model.dart';

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
    return ListView.builder(
      padding: EdgeInsets.all(
        20,
      ),
      itemCount: widget.activeRaceList.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.30,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: createCard(context, index),
            ),
          ),
          actions: <Widget>[
            _createActionItem(
              context,
              Colors.pink[300],
              MaterialCommunityIcons.heart_multiple,
              "Parowanie",
            ),
            GestureDetector(
              onTap: () {
                _navigateToParrotsList(widget.activeRaceList[index]);
              },
              child: _createActionItem(
                context,
                Colors.indigo,
                MaterialCommunityIcons.home_group,
                "Hodowla",
              ),
            ),
          ],
          secondaryActions: <Widget>[
            _createActionItem(
              context,
              Colors.red,
              MaterialCommunityIcons.delete,
              "Usuń hodowlę",
            ),
          ],
        );
      },
    );
  }

  void _navigateToParrotsList(String raceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParrotsListScreen(
                raceName: raceName,
              )),
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
                  "assets/parrotsRace/${widget.activeRaceList[index]}.jpg",
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
                  width: MediaQuery.of(context).size.width * 0.40,
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
                      width: MediaQuery.of(context).size.width * 0.30,
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
}
