import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncubationInformationScreen extends StatefulWidget {
  static const String routeName = "/IncubationInformationScreen";

  final List<ParrotPairing> pairList;

  const IncubationInformationScreen({this.pairList});

  @override
  _IncubationInformationScreenState createState() =>
      _IncubationInformationScreenState();
}

class _IncubationInformationScreenState
    extends State<IncubationInformationScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();
  List<String> raceList = [];

  void _createRaceList() {
    widget.pairList.forEach((pair) {
      if (!raceList.contains(pair.race)) {
        raceList.add(pair.race);
      }
    });
  }

  int _cauntPair(List<ParrotPairing> pairList, String race) {
    int count = 0;
    pairList.forEach((element) {
      if (element.race == race) count++;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    _createRaceList();
    raceList.forEach((el) {
      print(el);
    });
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 30,
          child: AutoSizeText(
            'Aktywne Inkubacje',
            maxLines: 1,
          ),
        ),
      ),
      body: MainBackground(
        child: ListView.builder(
          itemCount: raceList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Card(
                color: Colors.black12,
                child: ExpansionTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        raceList[index],
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textSelectionColor,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Oczekujących inkubacji",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).hintColor),
                          ),
                          Spacer(),
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
                              _cauntPair(widget.pairList, raceList[index])
                                  .toString(),
                              style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  children: [
                    Column(
                      children: [],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
