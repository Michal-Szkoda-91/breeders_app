import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/pairList_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../models/global_methods.dart';
import '../../parrots/screens/parrotsList.dart';
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
                      child: Column(
                        children: [
                          createSlidableCard(context, index, _parrotCount),
                        ],
                      ),
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
                  // color: Colors.red,
                ),
                child: createCard(
                    context, index, widget.activeRaceList[index], parrotCount),
              ),
            ),
            _globalMethods.arrowConteiner,
          ],
        ),
      ),
      secondaryActions: <Widget>[
        GestureDetector(
          onTap: () {
            _globalMethods.showDeletingDialog(
              context,
              widget.activeRaceList[index],
              "Czy chcesz usunąć wszystkie papugi z hodowli? Usunięte zostaną również pary wraz z danymi o inkubacji i potomstwu.\n\nOPERACJI NIE MOŻNA PÓZNIEJ COFNĄĆ!!!",
              _deleteRace,
              null,
            );
          },
          child: _globalMethods.createActionItem(context, Colors.red,
              MaterialCommunityIcons.delete, "Usuń hodowlę", 26),
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

  Widget createCard(
      BuildContext context, int index, String raceName, int parrotCount) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(
            left: 15,
            top: 15,
            bottom: 15,
          ),
          color: Colors.transparent,
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: Center(),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.49,
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
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: AutoSizeText(
                                "Ilość ptaków: ",
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Container(
                              width: 33,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  color: Theme.of(context).textSelectionColor,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),
                              child: Text(
                                parrotCount.toString(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToPairingList(raceName);
                      },
                      child: _globalMethods.createActionItem(
                          context,
                          Colors.pink[300],
                          MaterialCommunityIcons.heart_multiple,
                          "Parowanie",
                          5),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToParrotsList(raceName);
                      },
                      child: _globalMethods.createActionItem(
                        context,
                        Colors.blueAccent,
                        MaterialCommunityIcons.home_group,
                        "Hodowla",
                        5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CircleAvatar(
            radius: 44,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage(
                "assets/image/parrotsRace/${widget.activeRaceList[index]}.jpg",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteRace(String name) async {
    bool result = await _globalMethods.checkInternetConnection(context);

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
  }
}
