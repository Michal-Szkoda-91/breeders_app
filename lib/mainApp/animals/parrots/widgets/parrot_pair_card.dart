import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:group_button/group_button.dart';

import 'add_child_button.dart';
import 'children_list.dart';
import 'egg_expansionTile.dart';
import 'parrotDialogInformation.dart';

class ParrotPairCard extends StatefulWidget {
  final String race;
  final List<Parrot> parrotList;
  final List<ParrotPairing> pairList;
  const ParrotPairCard({
    this.pairList,
    this.race,
    this.parrotList,
  });

  @override
  _ParrotPairCardState createState() => _ParrotPairCardState();
}

class _ParrotPairCardState extends State<ParrotPairCard> {
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  Parrot chosenMaleParrot;
  Parrot chosenFemaleParrot;
  ScrollController _rrectController = ScrollController();

  _sortingBy(int index) {
    switch (index) {
      case 0:
        setState(() {
          widget.pairList
              .sort((a, b) => b.pairingData.compareTo(a.pairingData));
        });
        break;
      case 1:
        setState(() {
          widget.pairList.sort((a, b) => a.pairColor.compareTo(b.pairColor));
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar.rrect(
      controller: _rrectController,
      heightScrollThumb: 100,
      backgroundColor: Theme.of(context).accentColor,
      child: SingleChildScrollView(
        controller: _rrectController,
        physics: ScrollPhysics(),
        child: Column(
          children: [
            _sortingColumn(context),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.pairList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.35,
                    closeOnScroll: true,
                    child: Row(
                      children: [
                        Expanded(
                          child: _createCard(context, index),
                        ),
                        _globalMethods.arrowConteiner,
                      ],
                    ),
                    secondaryActions: [
                      GestureDetector(
                        onTap: () {
                          _globalMethods.showDeletingDialog(
                            context,
                            "Usuń parę",
                            "Napewno usunąć wybraną parę z hodowli?",
                            (_) {
                              _deletePair(
                                  widget.pairList[index].id,
                                  widget.pairList[index].femaleRingNumber,
                                  widget.pairList[index].maleRingNumber);
                            },
                            null,
                          );
                        },
                        child: _globalMethods.createActionItem(
                          context,
                          Colors.red,
                          MaterialCommunityIcons.delete,
                          "Usuń Parę",
                          4,
                        ),
                      ),
                      widget.pairList[index].isArchive == "false"
                          ? GestureDetector(
                              onTap: () {
                                _globalMethods.showDeletingDialog(
                                  context,
                                  "Przenieś do archiwum",
                                  "Napewno ustawić wybraną parę jako nie aktywną? \nNie można cofnąć operacji",
                                  (_) {
                                    _movingToArchive(
                                        widget.pairList[index].id,
                                        widget.pairList[index].femaleRingNumber,
                                        widget.pairList[index].maleRingNumber);
                                  },
                                  null,
                                );
                              },
                              child: _globalMethods.createActionItem(
                                context,
                                Colors.indigo,
                                MaterialCommunityIcons.archive,
                                "Przenieś do archiwum",
                                4,
                              ),
                            )
                          : null,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Card(
        color: widget.pairList[index].isArchive == "false"
            ? Colors.transparent
            : Colors.grey[700],
        shadowColor: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _createInfoRow(
              context,
              "Data utworzenia pary: ",
              widget.pairList[index].pairingData,
            ),
            const SizedBox(height: 3),
            _createInfoRow(
              context,
              "Kolor Pary: ",
              widget.pairList[index].pairColor,
            ),
            const SizedBox(height: 3),
            _createInfoRowParrot(
              context,
              "Samica(0,1): ",
              widget.pairList[index].femaleRingNumber,
            ),
            const SizedBox(height: 3),
            _createInfoRowParrot(
              context,
              "Samiec(1,0): ",
              widget.pairList[index].maleRingNumber,
            ),
            const SizedBox(
              height: 3,
            ),
            widget.pairList[index].isArchive == "false"
                ? Divider(
                    color: Theme.of(context).textSelectionColor,
                  )
                : Center(),
            widget.pairList[index].isArchive == "false"
                ? EggExpansionTile(
                    widget.pairList[index].showEggsDate,
                    widget.race,
                    widget.pairList[index].id,
                  )
                : Center(),
            Divider(
              color: Theme.of(context).textSelectionColor,
            ),
            widget.pairList[index].isArchive == "false"
                ? AddPairChildButton(
                    pair: widget.pairList[index],
                    raceName: widget.race,
                  )
                : SizedBox(
                    height: 1,
                  ),
            const SizedBox(
              height: 3,
            ),
            ChildrenList(
              pairId: widget.pairList[index].id,
              raceName: widget.race,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _createInfoRow(BuildContext context, String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          maxLines: 1,
          style: _cretedTextStyletitle(context),
          softWrap: true,
        ),
        AutoSizeText(
          content,
          maxLines: 3,
          style: _cretedTextStyle(context),
          softWrap: true,
        ),
      ],
    );
  }

  Widget _createInfoRowParrot(
      BuildContext context, String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          maxLines: 1,
          style: _cretedTextStyletitle(context),
          softWrap: true,
        ),
        InkWell(
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                      backgroundColor: Theme.of(context).backgroundColor,
                      scrollable: true,
                      title: new Text(
                        content,
                        style: _cretedTextStyle(context),
                      ),
                      content: ParrotDialogInformation(
                        parrotRace: widget.race,
                        parrotRing: content,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black45,
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              content,
              style: _cretedTextStyle(context),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _cretedTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
    );
  }

  TextStyle _cretedTextStyletitle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).hintColor,
      fontSize: MediaQuery.of(context).size.width > 330 ? 14 : 10,
    );
  }

  Future<void> _deletePair(String id, String femaleId, String maleID) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await _globalMethods.checkInternetConnection(context);

    if (!result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
    } else {
      widget.parrotList.forEach((parr) {
        if (parr.ringNumber == femaleId) {
          chosenFemaleParrot = parr;
        } else if (parr.ringNumber == maleID) {
          chosenMaleParrot = parr;
        }
      });
      try {
        Navigator.of(context).pop();
        await _parrotPairDataHelper
            .deletePair(
          _firebaseUser.uid,
          widget.race,
          id,
          chosenFemaleParrot,
          chosenMaleParrot,
        )
            .then(
          (_) {
            _globalMethods.showMaterialDialog(
                context, "Usunięto wybraną parę papug");
          },
        );
      } catch (e) {
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(context,
            "Operacja nie udana, nieznany błąd lub brak połączenia z internetem.");
      }
    }
  }

  Future<void> _movingToArchive(
      String id, String femaleId, String maleID) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await _globalMethods.checkInternetConnection(context);

    if (!result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
    } else {
      widget.parrotList.forEach((parr) {
        if (parr.ringNumber == femaleId) {
          chosenFemaleParrot = parr;
        } else if (parr.ringNumber == maleID) {
          chosenMaleParrot = parr;
        }
      });
      try {
        Navigator.of(context).pop();
        await _parrotPairDataHelper
            .moveToArchive(
          _firebaseUser.uid,
          widget.race,
          id,
          chosenFemaleParrot,
          chosenMaleParrot,
        )
            .then(
          (_) {
            _globalMethods.showMaterialDialog(
                context, "Przesunięto do archiwum");
          },
        );
      } catch (e) {
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(context,
            "Operacja nie udana, nieznany błąd lub brak połączenia z internetem.");
      }
    }
  }

  Container _sortingColumn(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Sortowanie listy par",
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 16,
              ),
            ),
          ),
          GroupButton(
            isRadio: true,
            spacing: 5,
            buttonHeight: 25,
            buttonWidth: 140,
            unselectedColor: Theme.of(context).hintColor,
            selectedColor: Theme.of(context).accentColor,
            selectedTextStyle: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 12,
            ),
            unselectedTextStyle: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 12,
            ),
            onSelected: (index, isSelected) => _sortingBy(index),
            buttons: ["Data Parowania", "Kolor"],
          )
        ],
      ),
    );
  }
}
