import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/global_methods.dart';
import '../../parrots/models/pairing_model.dart';
import '../../parrots/models/parrot_model.dart';
import '../models/parrotsRace_list.dart';
import '../screens/addParrot_screen.dart';
import '../models/children_model.dart';

class ChildrenList extends StatefulWidget {
  final String raceName;
  final String pairId;
  final ParrotPairing pair;

  const ChildrenList({
    required this.raceName,
    required this.pairId,
    required this.pair,
  });

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<Children> _childrenList = [];
  int _childrenCount = 0;
  late Map raceMap;
  final ParrotsRace _parrotsRace = new ParrotsRace();
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _childrenCount = 0;
    _childrenList = [];
  }

  @override
  Widget build(BuildContext context) {
    _childrenList = [];
    _childrenCount = 0;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(firebaseUser!.uid)
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
            return _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _childrenCount == 0
                    ? _createdNoChildRow(context)
                    : _createdChildExpansionTile(context);
        }
      },
    );
  }

  ExpansionTile _createdChildExpansionTile(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Row(
        children: [
          Text(
            "Ilość potomków:",
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
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
                color: Theme.of(context).canvasColor,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(20),
              ),
            ),
            child: Text(
              _childrenCount.toString(),
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
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
          color: Theme.of(context).textSelectionTheme.selectionColor,
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
          color: Theme.of(context).textSelectionTheme.selectionColor,
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
            width: 515,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 30),
                    _createTitleRow(context, "Nr obrączki"),
                    _createTitleRow(context, "Kolor"),
                    _createTitleRow(context, "Data ur."),
                    const SizedBox(width: 155),
                  ],
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _childrenCount,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 490,
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
                          _createEditChild(_childrenList[index]),
                          _createdDeleteChildButton(
                            context,
                            _childrenList[index].ringNumber,
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

  IconButton _createdDeleteChildButton(BuildContext ctx, String ringNumber) {
    return IconButton(
      onPressed: () {
        _deleteChild(ringNumber);
      },
      icon: Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  IconButton _createEditChild(Children child) {
    return IconButton(
      onPressed: () async {
        Navigator.of(context)
            .push(
              _globalMethods.createRoute(
                AddParrotScreen(
                  pair: widget.pair,
                  parrotMap: {
                    "url": "assets/image/parrot.jpg",
                    "name": "Edytuj Dane",
                    "icubationTime": "21"
                  },
                  race: widget.raceName,
                  addFromChild: false,
                  parrot: Parrot(
                    race: widget.raceName,
                    ringNumber: child.ringNumber,
                    color: child.color,
                    fission: '',
                    cageNumber: '',
                    sex: child.gender,
                    notes: '',
                    picUrl: '',
                    pairRingNumber: '',
                  ),
                  data: child.broodDate,
                ),
              ),
            )
            .then((value) => setState(() {}));
      },
      icon: Icon(
        Icons.edit,
        color: Colors.indigoAccent,
      ),
    );
  }

  Container _createAddParrotButton(
      String ringNumber, String color, String gender) {
    return Container(
      width: 55,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
        onPressed: () {
          raceMap = _parrotsRace.parrotsRaceList
              .firstWhere((element) => element["name"] == widget.raceName);
          Navigator.of(context).push(_globalMethods.createRoute(
            AddParrotScreen(
              parrotMap: raceMap,
              parrot: new Parrot(
                ringNumber: ringNumber,
                color: color,
                cageNumber: "brak",
                fission: "brak",
                notes: "brak",
                pairRingNumber: "brak",
                race: widget.raceName,
                picUrl: '',
                sex: gender,
              ),
              addFromChild: true,
              pair: ParrotPairing(
                  id: '',
                  race: '',
                  maleRingNumber: '',
                  femaleRingNumber: '',
                  pairingData: '',
                  showEggsDate: '',
                  pairColor: '',
                  isArchive: '',
                  picUrl: ''),
              race: '',
              data: '',
            ),
          ));
        },
      ),
    );
  }

  Container _genderIcon(BuildContext context, int index) {
    Color colorBackground = Colors.greenAccent;
    Color colorIcon = Colors.green.shade700;
    IconData icon = Icons.help;

    if (_childrenList[index].gender == "Samiec") {
      colorBackground = Colors.blue.shade300;
      colorIcon = Colors.blue.shade700;
      icon = Icons.male;
    } else if (_childrenList[index].gender == "Samica") {
      colorBackground = Colors.pink.shade300;
      colorIcon = Colors.pink.shade700;
      icon = Icons.female;
    }

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorBackground,
        border: Border.all(
          color: Theme.of(context).canvasColor,
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
            color: Theme.of(context).textSelectionTheme.selectionColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _createChildList(AsyncSnapshot<QuerySnapshot> snapshot) {
    snapshot.data!.docs.forEach((val) {
      _childrenList.add(
        new Children(
          ringNumber: val.id,
          broodDate: val['Born Date'],
          color: val['Colors'],
          gender: val['Sex'],
        ),
      );
      _childrenCount++;
    });
    _childrenList.sort((a, b) => b.broodDate.compareTo(a.broodDate));
  }

  Future<void> _deleteChild(
    String ringNumber,
  ) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoading = true;
    });
    await _globalMethods.checkInternetConnection(context).then(
      (result) async {
        if (!result) {
          _globalMethods.showMaterialDialog(
              context, "Brak połączenia z internetem.");
          return;
        } else {
          _parrotPairDataHelper
              .deleteChild(
            context: context,
            uid: _firebaseUser!.uid,
            race: widget.raceName,
            pairId: widget.pairId,
            childID: ringNumber,
          )
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      },
    );
  }
}
