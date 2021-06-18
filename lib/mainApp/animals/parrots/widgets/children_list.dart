import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../models/parrotsRace_list.dart';
import '../screens/addParrot_screen.dart';
import '../models/children_model.dart';

class ChildrenList extends StatefulWidget {
  final String raceName;
  final String pairId;

  const ChildrenList({this.raceName, this.pairId});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<Children> _childrenList = [];
  int _childrenCount = 0;
  Map raceMap;
  final ParrotsRace _parrotsRace = new ParrotsRace();

  @override
  Widget build(BuildContext context) {
    _childrenList = [];
    _childrenCount = 0;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(firebaseUser.uid)
          .doc(widget.raceName)
          .collection("Pairs")
          .doc(widget.pairId)
          .collection("Child")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Błąd danych');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: const CircularProgressIndicator(),
              ),
            );

          default:
            _createChildList(snapshot);
            return _childrenCount == 0
                ? _createdNoChildRow(context)
                : _createdChildExpansionTile(context);
        }
      },
    );
  }

  ExpansionTile _createdChildExpansionTile(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(
            "Ilość potomków:",
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 16,
            ),
          ),
          Spacer(),
          Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).textSelectionColor,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(20),
              ),
            ),
            child: Text(
              _childrenCount.toString(),
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      children: [
        _createChildDetailTable(),
      ],
    );
  }

  Container _createTitleRow(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: const Border(
          right: const BorderSide(color: Colors.black, width: 2.0),
          bottom: const BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
      height: 30,
      width: 110,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 14,
        ),
      ),
    );
  }

  Container _createContentRow(BuildContext context, String title) {
    return Container(
      decoration: const BoxDecoration(
        border: const Border(
          right: const BorderSide(color: Colors.black, width: 1.0),
          bottom: const BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 40,
      width: 110,
      alignment: Alignment.center,
      child: AutoSizeText(
        title,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Column _createChildDetailTable() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 415,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 30),
                    _createTitleRow(context, "Nr obrączki"),
                    _createTitleRow(context, "Kolor"),
                    _createTitleRow(context, "Data ur."),
                    const SizedBox(width: 55),
                  ],
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _childrenCount,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 390,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _genderIcon(context, index),
                          _createContentRow(
                              context, _childrenList[index].ringNumber),
                          _createContentRow(
                              context, _childrenList[index].color),
                          _createContentRow(
                              context, _childrenList[index].broodDate),
                          _createAddParrotButton(
                            _childrenList[index].ringNumber,
                            _childrenList[index].color,
                            _childrenList[index].gender,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _createAddParrotButton(
      String ringNumber, String color, String gender) {
    return Container(
      width: 55,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).textSelectionColor,
        ),
        onPressed: () {
          raceMap = _parrotsRace.parrotsRaceList
              .firstWhere((element) => element["name"] == widget.raceName);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddParrotScreen(
                parrotMap: raceMap,
                parrot: new Parrot(
                  ringNumber: ringNumber,
                  color: color,
                  cageNumber: "brak",
                  fission: "brak",
                  notes: "brak",
                  pairRingNumber: "brak",
                  race: widget.raceName,
                  sex: gender,
                ),
                addFromChild: true,
              ),
            ),
          );
        },
      ),
    );
  }

  Container _genderIcon(BuildContext context, int index) {
    Color colorBackground = Colors.greenAccent;
    Color colorIcon = Colors.green[700];
    IconData icon = MaterialCommunityIcons.help;

    if (_childrenList[index].gender == "Samiec") {
      colorBackground = Colors.blue[300];
      colorIcon = Colors.blue[700];
      icon = MaterialCommunityIcons.gender_male;
    } else if (_childrenList[index].gender == "Samica") {
      colorBackground = Colors.pink[300];
      colorIcon = Colors.pink[700];
      icon = MaterialCommunityIcons.gender_female;
    }

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorBackground,
        border: Border.all(
          color: Theme.of(context).textSelectionColor,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(25),
        ),
      ),
      child: Icon(
        icon,
        color: colorIcon,
        size: 12,
      ),
    );
  }

  Row _createdNoChildRow(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Text(
          "Brak potomstwa",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _createChildList(AsyncSnapshot<QuerySnapshot> snapshot) {
    snapshot.data.docs.forEach((val) {
      _childrenList.add(
        new Children(
          ringNumber: val.id,
          broodDate: val.data()['Born Date'],
          color: val.data()['Colors'],
          gender: val.data()['Sex'],
        ),
      );
      _childrenCount++;
    });
    _childrenList.sort((a, b) => b.broodDate.compareTo(a.broodDate));
  }
}
