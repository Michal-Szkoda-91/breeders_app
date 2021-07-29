import 'package:diacritic/diacritic.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/global_methods.dart';
import '../models/parrot_model.dart';
import 'addParrotButtonFromParrotList.dart';
import 'create_parrot_card/genderIcon.dart';
import 'create_parrot_card/table_content_notes_row.dart';
import 'create_parrot_card/table_content_row.dart';
import 'create_parrot_card/table_contnent_normal_row.dart';
import 'create_parrot_card/table_title_row.dart';
import 'create_parrot_card/upgrade_delete_buttons.dart';

class ParrotCard extends StatefulWidget {
  const ParrotCard({
    required this.createdParrotList,
  });

  final List<Parrot> createdParrotList;

  @override
  _ParrotCardState createState() => _ParrotCardState();
}

class _ParrotCardState extends State<ParrotCard> {
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotDataHelper _parrotHelper = ParrotDataHelper();
  ScrollController _rrectController = ScrollController();
  bool _isLoading = false;

  _sortingBy(int index) {
    switch (index) {
      case 1:
        if (mounted) {
          setState(() {
            widget.createdParrotList.sort((a, b) =>
                removeDiacritics(a.ringNumber)
                    .compareTo(removeDiacritics(b.ringNumber)));
          });
        }
        break;
      case 2:
        if (mounted) {
          setState(() {
            widget.createdParrotList.sort((a, b) =>
                removeDiacritics(a.color).compareTo(removeDiacritics(b.color)));
          });
        }
        break;
      case 3:
        if (mounted) {
          setState(() {
            widget.createdParrotList.sort((a, b) => removeDiacritics(a.fission)
                .compareTo(removeDiacritics(b.fission)));
          });
        }
        break;
      case 4:
        if (mounted) {
          setState(() {
            widget.createdParrotList.sort((a, b) =>
                removeDiacritics(a.cageNumber)
                    .compareTo(removeDiacritics(b.cageNumber)));
          });
        }
        break;
      case 5:
        if (mounted) {
          setState(() {
            widget.createdParrotList.sort((a, b) =>
                removeDiacritics(a.pairRingNumber)
                    .compareTo(removeDiacritics(b.pairRingNumber)));
          });
        }
        break;
      case 6:
        if (mounted) {
          setState(() {
            widget.createdParrotList.sort((a, b) => a.sex.compareTo(b.sex));
          });
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: DraggableScrollbar.rrect(
              controller: _rrectController,
              heightScrollThumb: 100,
              backgroundColor: Theme.of(context).accentColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(6.0),
                controller: _rrectController,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      AddParrotFromInsideParrotList(
                          race: widget.createdParrotList[0].race),
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: 1040,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 140),
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
                                    itemCount: widget.createdParrotList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 140),
                                            width: 1040,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                GenderIcon(
                                                  index: index,
                                                  createdParrotList:
                                                      widget.createdParrotList,
                                                ),
                                                TableContentRow(
                                                    createdParrotList: widget
                                                        .createdParrotList,
                                                    title: widget
                                                        .createdParrotList[
                                                            index]
                                                        .pairRingNumber,
                                                    width: 100.0,
                                                    index: index,
                                                    isPair: true),
                                                TableContentNormalRow(
                                                  title: widget
                                                      .createdParrotList[index]
                                                      .color,
                                                  width: 150.0,
                                                ),
                                                TableContentNotesRow(
                                                  title: widget
                                                      .createdParrotList[index]
                                                      .fission,
                                                  width: 200.0,
                                                ),
                                                TableContentNormalRow(
                                                  title: widget
                                                      .createdParrotList[index]
                                                      .cageNumber,
                                                  width: 150.0,
                                                ),
                                                TableContentNotesRow(
                                                  title: widget
                                                      .createdParrotList[index]
                                                      .notes,
                                                  width: 150.0,
                                                ),
                                                DeleteUpgradeButtons(
                                                  raceName: widget.createdParrotList[0].race,
                                                  index: index,
                                                  createdParrotList:
                                                      widget.createdParrotList,
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
                            width: 140,
                            color: Theme.of(context).backgroundColor,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                      width: 110.0,
                                      sortedIndex: 1,
                                      sorting: _sortingBy,
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.createdParrotList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 270,
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
                                                widget.createdParrotList,
                                            title: widget
                                                .createdParrotList[index]
                                                .ringNumber,
                                            width: 110.0,
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
                  );
                },
              ),
            ),
          );
  }

  Future<void> _deleteParrot(String ring, Parrot parrot) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await _globalMethods.checkInternetConnection(context).then((result) async {
      if (!result) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
      } else {
        if (widget.createdParrotList.length == 1) {
          Navigator.of(context).pop();
          _globalMethods.showMaterialDialog(context,
              "Nie można usunąć ostatniej papugi. Przejdź do listy ras i usuń całą rasę!");
        } else {
          Navigator.of(context).pop();
          await _parrotHelper.deleteParrot(
              uid: _firebaseUser!.uid,
              parrotToDelete: parrot,
              context: context,
              showDialog: true);
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }
}
