import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../advertisement_banner/banner_page.dart';
import '../../../../globalWidgets/mainBackground.dart';
import '../models/pairing_model.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../widgets/incubationList.dart';

class IncubationInformationScreen extends StatefulWidget {
  static const String routeName = "/IncubationInformationScreen";

  final List<ParrotPairing> pairList;

  const IncubationInformationScreen({required this.pairList});

  @override
  _IncubationInformationScreenState createState() =>
      _IncubationInformationScreenState();
}

class _IncubationInformationScreenState
    extends State<IncubationInformationScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();
  List<String> raceList = [];
  ScrollController _rrectController = ScrollController();

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

  List<ParrotPairing> _createRacePairList(
      List<ParrotPairing> allparrots, String race) {
    List<ParrotPairing> createdList = [];
    allparrots.forEach(
      (element) {
        if (element.race == race) {
          createdList.add(element);
        }
      },
    );
    return createdList;
  }

  @override
  Widget build(BuildContext context) {
    _createRaceList();

    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading:
            (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        title: Container(
          width: MediaQuery.of(context).size.width * 30,
          child: AutoSizeText(
            'Aktywne Inkubacje',
            maxLines: 1,
          ),
        ),
      ),
      body: MainBackground(
        child: Column(
          children: [
            BannerPage(),
            const SizedBox(height: 8),
            Expanded(
              child: DraggableScrollbar.rrect(
                controller: _rrectController,
                heightScrollThumb: 100,
                backgroundColor: Theme.of(context).accentColor,
                child: ListView.builder(
                  controller: _rrectController,
                  itemCount: raceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Card(
                        color: Colors.black12,
                        child: ExpansionTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                raceList[index],
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionColor,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: AutoSizeText(
                                        "Oczekujących inkubacji:",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 33,
                                    height: 33,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      border: Border.all(
                                        color: Theme.of(context).canvasColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        const Radius.circular(18),
                                      ),
                                    ),
                                    child: Text(
                                      _cauntPair(
                                        widget.pairList,
                                        raceList[index],
                                      ).toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                          children: [
                            IncubationList(
                              parrotList: _createRacePairList(
                                widget.pairList,
                                widget.pairList[index].race,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
