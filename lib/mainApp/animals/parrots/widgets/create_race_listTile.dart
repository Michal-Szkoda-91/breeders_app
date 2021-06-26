import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/painting.dart';
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
    required this.activeRaceList,
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
  late int _parrotCount;
  List<String> parrotRingList = [''];
  List<Parrot> parrotList = [];
  bool _isLoading = false;

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
                  .collection(firebaseUser!.uid)
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
                    return _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: createSlidableCard(
                                context, index, _parrotCount),
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
    snapshot.data!.docs.forEach((val) {
      _parrotCount++;
      parrotList.add(Parrot(
        ringNumber: val.id,
        cageNumber: val['Cage number'],
        color: val['Colors'],
        fission: val['Fission'],
        notes: val['Notes'],
        pairRingNumber: val['PairRingNumber'],
        race: val['Race Name'],
        sex: val['Sex'],
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
          icon: Icons.delete,
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
    setState(() {
      _isLoading = true;
    });
    await _globalMethods.checkInternetConnection(context).then((result) async {
      if (!result) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
      } else {
        Navigator.of(context).pop();
        await _parrotDataHelper.deleteRaceList(
            firebaseUser!.uid, name, context);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
