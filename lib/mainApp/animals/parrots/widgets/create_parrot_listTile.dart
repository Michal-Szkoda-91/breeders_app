import 'package:flutter_icons/flutter_icons.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/choise_parrot_cross_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CreateParrotListTile extends StatefulWidget {
  const CreateParrotListTile({
    this.activeRaceList,
  });

  final List<String> activeRaceList;

  @override
  _CreateParrotListTileState createState() => _CreateParrotListTileState();
}

class _CreateParrotListTileState extends State<CreateParrotListTile> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(
        20,
      ),
      itemCount: widget.activeRaceList.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Card(
                elevation: 20,
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/parrotsRace/${widget.activeRaceList[index]}.jpg",
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.activeRaceList[index],
                        style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Theme.of(context).textSelectionColor,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChoiseParrotCrossScreen(
                                raceName: widget.activeRaceList[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            _createActionItem(
              context,
              Colors.pink[300],
              MaterialCommunityIcons.heart_multiple,
              "Parowanie",
            ),
            _createActionItem(
              context,
              Colors.indigo,
              MaterialCommunityIcons.home_group,
              "Hodowla",
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

  Padding _createActionItem(
      BuildContext context, Color color, IconData icon, String name) {
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
            Text(
              name,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
