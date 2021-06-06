import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screens/pairList_screen.dart';
import '../widgets/create_race_listTile/deleteButton.dart';
import '../../../../models/global_methods.dart';
import '../../parrots/screens/parrotsList.dart';
import '../models/parrot_model.dart';
import 'create_race_listTile/race_parrot_card.dart';

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
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotDataHelper _parrotDataHelper = ParrotDataHelper();
  ScrollController _rrectController = ScrollController();
  int _parrotCount;
  List<String> parrotRingList = [''];
  List<Parrot> parrotList = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DraggableScrollbar.rrect(
        controller: _rrectController,
        heightScrollThumb: 100,
        backgroundColor: Theme.of(context).accentColor,
        child: ListView.builder(
          itemCount: widget.activeRaceList.length,
          controller: _rrectController,
          itemBuilder: (context, index) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(firebaseUser.uid)
                  .doc(widget.activeRaceList[index])
                  .collection("Birds")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Błąd danych');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    _countParrot(snapshot);
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: createSlidableCard(context, index, _parrotCount),
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _countParrot(AsyncSnapshot<QuerySnapshot> snapshot) {
    _parrotCount = 0;
    snapshot.data.docs.forEach((val) {
      _parrotCount++;
      parrotList.add(Parrot(
        ringNumber: val.id,
        cageNumber: val.data()['Cage number'],
        color: val.data()['Colors'],
        fission: val.data()['Fission'],
        notes: val.data()['Notes'],
        pairRingNumber: val.data()['PairRingNumber'],
        race: val.data()['Race Name'],
        sex: val.data()['Sex'],
      ));
    });
  }

  Slidable createSlidableCard(
      BuildContext context, int index, int parrotCount) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.35,
      closeOnScroll: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RaceParrotCard(
                  index: index,
                  raceName: widget.activeRaceList[index],
                  parrotCount: parrotCount,
                  activeRace: widget.activeRaceList[index],
                  navToBreed: _navigateToParrotsList,
                  navToPair: _navigateToPairingList,
                ),
              ),
            ),
            _globalMethods.arrowConteiner,
          ],
        ),
      ),
      secondaryActions: <Widget>[
        Deletebutton(
          function: _deleteRace,
          title: widget.activeRaceList[index],
          color: Colors.red,
          icon: MaterialCommunityIcons.delete,
          name: "Usuń hodowlę",
          padding: 25.0,
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

  void _navigateToPairingList(String raceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PairListScreen(
          raceName: raceName,
          parrotList: parrotList,
        ),
      ),
    );
  }

  Future<void> _deleteRace(String name) async {
    await _globalMethods.checkInternetConnection(context).then((result) async {
      if (!result) {
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
      } else {
        Navigator.of(context).pop();
        await _parrotDataHelper.deleteRaceList(firebaseUser.uid, name).then(
          (_) {
            _globalMethods.showMaterialDialog(context,
                "Usunięto wszystkie papugi z rasy $name wraz ze wszystkimi parami i danymi.");
          },
        ).catchError((error) {
          _globalMethods.showMaterialDialog(context,
              "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
        });
      }
    });
  }
}
