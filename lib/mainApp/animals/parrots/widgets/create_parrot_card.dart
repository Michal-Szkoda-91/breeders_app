import 'package:auto_size_text/auto_size_text.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:breeders_app/mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';

import 'parrotDialogInformation.dart';

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
    return DraggableScrollbar.rrect(
      controller: _rrectController,
      heightScrollThumb: 100,
      backgroundColor: Theme.of(context).accentColor,
      child: SingleChildScrollView(
        controller: _rrectController,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 1030,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 130),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _createTitleRow(context, "", 50.0, 6),
                                _createTitleRow(context, "Para", 100.0, 5),
                                _createTitleRow(context, "Kolor", 150.0, 2),
                                _createTitleRow(
                                    context, "Rozszczepienie", 200.0, 3),
                                _createTitleRow(context, "Nr klatki", 150.0, 4),
                                _createTitleRow(context, "Notatki", 150.0, 0),
                                SizedBox(
                                  width: 100,
                                ),
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
                                    padding: EdgeInsets.only(left: 130),
                                    width: 1030,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _genderIcon(context, index),
                                        _createContentRowPair(
                                          context,
                                          widget._createdParrotList[index]
                                              .pairRingNumber,
                                          100.0,
                                          index,
                                          true,
                                        ),
                                        _createContentRow(
                                          context,
                                          widget
                                              ._createdParrotList[index].color,
                                          150.0,
                                        ),
                                        _createContentRowNotes(
                                            context,
                                            widget._createdParrotList[index]
                                                .fission,
                                            200.0),
                                        _createContentRow(
                                          context,
                                          widget._createdParrotList[index]
                                              .cageNumber,
                                          150.0,
                                        ),
                                        _createContentRowNotes(
                                          context,
                                          widget
                                              ._createdParrotList[index].notes,
                                          150.0,
                                        ),
                                        _createInteractiveRow(index),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
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
                            _createTitleRow(context, "Nr", 30.0, 0),
                            _createTitleRow(context, "Obrączka", 100.0, 1),
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
                                  _createContentRow(
                                      context, (index + 1).toString(), 30.0),
                                  _createContentRowPair(
                                    context,
                                    widget._createdParrotList[index].ringNumber,
                                    100.0,
                                    index,
                                    false,
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
    );
  }

  Container _createInteractiveRow(int index) {
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              _globalMethods.showDeletingDialog(
                context,
                widget._createdParrotList[index].ringNumber,
                "Napewno usunąć tę papugę z hodowli?",
                _deleteParrot,
                widget._createdParrotList[index],
              );
            },
            child: Icon(
              Icons.delete,
              color: Colors.red,
              size: 30,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParrotScreen(
                    parrotMap: {
                      "url": "assets/image/parrot.jpg",
                      "name": "Edytuj Papugę",
                      "icubationTime": "21"
                    },
                    parrot: widget._createdParrotList[index],
                  ),
                ),
              );
            },
            child: Icon(
              MaterialCommunityIcons.circle_edit_outline,
              color: Colors.lightBlueAccent,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Container _createContentRow(
      BuildContext context, String title, double width) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 60,
      width: width,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _createContentRowPair(BuildContext context, String title,
      double width, int index, bool isPair) {
    return Container(
      padding: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 60,
      width: width,
      alignment: Alignment.center,
      child: widget._createdParrotList[index].pairRingNumber == "brak" && isPair
          ? AutoSizeText(
              title,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )
          : createPairRow(context, index, title),
    );
  }

  Container _createContentRowNotes(
      BuildContext context, String title, double width) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      height: 60,
      width: width,
      alignment: Alignment.center,
      child: title.length > 25
          ? GestureDetector(
              onTap: () {
                return _showInfo(context, title);
              },
              child: Text(
                title.substring(0, 20) + "... ->",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Future<void> _showInfo(BuildContext context, String title) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text(
            title,
            style: new TextStyle(
              fontSize: 14,
              color: Theme.of(context).textSelectionColor,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _createTitleRow(
      BuildContext context, String title, double width, int sortedIndex) {
    return Material(
      child: InkWell(
        splashColor: Colors.red,
        radius: 22,
        onTap: () {
          if (sortedIndex != 0) _sortingBy(sortedIndex);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              right: BorderSide(color: Colors.black, width: 2.0),
              bottom: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
          width: width,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
                ),
              ),
              sortedIndex != 0
                  ? Icon(
                      MaterialCommunityIcons.arrow_down_drop_circle_outline,
                      color: Theme.of(context).textSelectionColor,
                      size: 25,
                    )
                  : Container(
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createPairRow(BuildContext context, int index, String title) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              scrollable: true,
              title: new Text(
                title,
                style: _cretedTextStyle(context),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                child: ParrotDialogInformation(
                  parrotRace: widget._createdParrotList[index].race,
                  parrotRing: title,
                ),
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
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black45,
          ),
          padding: EdgeInsets.all(10),
          child: AutoSizeText(
            title,
            maxLines: 2,
            style: _cretedTextStyle(context),
          ),
        ),
      ),
    );
  }

  Container _genderIcon(BuildContext context, int index) {
    Color colorBackground = Colors.greenAccent;
    Color colorIcon = Colors.green[700];
    IconData icon = MaterialCommunityIcons.help;

    if (widget._createdParrotList[index].sex == "Samiec") {
      colorBackground = Colors.blue[300];
      colorIcon = Colors.blue[700];
      icon = MaterialCommunityIcons.gender_male;
    } else if (widget._createdParrotList[index].sex == "Samica") {
      colorBackground = Colors.pink[300];
      colorIcon = Colors.pink[700];
      icon = MaterialCommunityIcons.gender_female;
    }

    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorBackground,
            border: Border.all(
              color: Theme.of(context).textSelectionColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Icon(
            icon,
            color: colorIcon,
            size: 16,
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

  TextStyle _cretedTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
    );
  }
}
