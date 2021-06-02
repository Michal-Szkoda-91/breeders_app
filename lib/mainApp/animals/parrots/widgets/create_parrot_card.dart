import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:breeders_app/models/global_methods.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';

import 'addParrotButtonFromParrotList.dart';
import 'create_parrot_card/genderIcon.dart';
import 'create_parrot_card/table_content_notes_row.dart';
import 'create_parrot_card/table_content_row.dart';
import 'create_parrot_card/table_contnent_normal_row.dart';
import 'create_parrot_card/table_title_row.dart';
import 'create_parrot_card/upgrade_delete_buttons.dart';

class ParrotCard extends StatefulWidget {
  const ParrotCard({
    Key key,
    @required List<Parrot> createdParrotList,
  })  : _createdParrotList = createdParrotList,
        super(key: key);

  final List<Parrot> _createdParrotList;

  @override
  _ParrotCardState createState() => _ParrotCardState();
}

class _ParrotCardState extends State<ParrotCard> {
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotDataHelper _parrotHelper = ParrotDataHelper();
  ScrollController _rrectController = ScrollController();

  _sortingBy(int index) {
    switch (index) {
      case 1:
        setState(() {
          widget._createdParrotList
              .sort((a, b) => a.ringNumber.compareTo(b.ringNumber));
        });
        break;
      case 2:
        setState(() {
          widget._createdParrotList.sort((a, b) => a.color.compareTo(b.color));
        });
        break;
      case 3:
        setState(() {
          widget._createdParrotList
              .sort((a, b) => a.fission.compareTo(b.fission));
        });
        break;
      case 4:
        setState(() {
          widget._createdParrotList
              .sort((a, b) => a.cageNumber.compareTo(b.cageNumber));
        });
        break;
      case 5:
        setState(() {
          widget._createdParrotList
              .sort((a, b) => a.pairRingNumber.compareTo(b.pairRingNumber));
        });
        break;
      case 6:
        setState(() {
          widget._createdParrotList.sort((a, b) => a.sex.compareTo(b.sex));
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DraggableScrollbar.rrect(
        controller: _rrectController,
        heightScrollThumb: 100,
        backgroundColor: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            controller: _rrectController,
            child: Column(
              children: [
                AddParrotFromInsideParrotList(
                    race: widget._createdParrotList[0].race),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 1030,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 130),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TableTitleRow(
                                    context: context,
                                    title: "",
                                    width: 50.0,
                                    sortedIndex: 6,
                                    sorting: _sortingBy,
                                  ),
                                  TableTitleRow(
                                    context: context,
                                    title: "Para",
                                    width: 100.0,
                                    sortedIndex: 5,
                                    sorting: _sortingBy,
                                  ),
                                  TableTitleRow(
                                    context: context,
                                    title: "Kolor",
                                    width: 150.0,
                                    sortedIndex: 2,
                                    sorting: _sortingBy,
                                  ),
                                  TableTitleRow(
                                    context: context,
                                    title: "Rozszczepienie",
                                    width: 200.0,
                                    sortedIndex: 3,
                                    sorting: _sortingBy,
                                  ),
                                  TableTitleRow(
                                    context: context,
                                    title: "Nr klatki",
                                    width: 150.0,
                                    sortedIndex: 4,
                                    sorting: _sortingBy,
                                  ),
                                  TableTitleRow(
                                    context: context,
                                    title: "Notatki",
                                    width: 150.0,
                                    sortedIndex: 0,
                                    sorting: _sortingBy,
                                  ),
                                  const SizedBox(width: 100),
                                ],
                              ),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget._createdParrotList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 130),
                                      width: 1030,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GenderIcon(
                                            index: index,
                                            createdParrotList:
                                                widget._createdParrotList,
                                          ),
                                          TableContentRow(
                                              createdParrotList:
                                                  widget._createdParrotList,
                                              title: widget
                                                  ._createdParrotList[index]
                                                  .pairRingNumber,
                                              width: 100.0,
                                              index: index,
                                              isPair: true),
                                          TableContentNormalRow(
                                            title: widget
                                                ._createdParrotList[index]
                                                .color,
                                            width: 150.0,
                                          ),
                                          TableContentNotesRow(
                                            title: widget
                                                ._createdParrotList[index]
                                                .fission,
                                            width: 200.0,
                                          ),
                                          TableContentNormalRow(
                                            title: widget
                                                ._createdParrotList[index]
                                                .cageNumber,
                                            width: 150.0,
                                          ),
                                          TableContentNotesRow(
                                            title: widget
                                                ._createdParrotList[index]
                                                .notes,
                                            width: 150.0,
                                          ),
                                          DeleteUpgradeButtons(
                                            index: index,
                                            createdParrotList:
                                                widget._createdParrotList,
                                            delete: _deleteParrot,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 130,
                      color: Theme.of(context).backgroundColor,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TableTitleRow(
                                context: context,
                                title: "Nr",
                                width: 30.0,
                                sortedIndex: 0,
                                sorting: _sortingBy,
                              ),
                              TableTitleRow(
                                context: context,
                                title: "Obrączka",
                                width: 100.0,
                                sortedIndex: 1,
                                sorting: _sortingBy,
                              ),
                            ],
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget._createdParrotList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 260,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TableContentNormalRow(
                                      title: (index + 1).toString(),
                                      width: 30.0,
                                    ),
                                    TableContentRow(
                                      createdParrotList:
                                          widget._createdParrotList,
                                      title: widget
                                          ._createdParrotList[index].ringNumber,
                                      width: 100.0,
                                      index: index,
                                      isPair: false,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteParrot(String ring, Parrot parrot) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await _globalMethods.checkInternetConnection(context);

    if (!result) {
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(
          context, "brak połączenia z internetem.");
    } else {
      Navigator.of(context).pop();
      await _parrotHelper
          .deleteParrot(
        _firebaseUser.uid,
        parrot,
      )
          .then(
        (_) {
          _globalMethods.showMaterialDialog(context,
              "Usunięto papugę o numerze obrączki ${parrot.ringNumber}");
        },
      ).catchError((error) {
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      });
    }
  }
}
