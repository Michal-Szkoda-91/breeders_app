import 'package:auto_size_text/auto_size_text.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:group_button/group_button.dart';

import 'package:breeders_app/mainApp/animals/parrots/screens/pairList_screen.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/models/global_methods.dart';
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
  bool _isLoading = false;

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
    return !_isLoading
        ? DraggableScrollbar.rrect(
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
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.pairList.length,
                    itemBuilder: (context, index) {
                      return _createCard(context, index);
                    },
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _createCard(BuildContext context, int index) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(
            left: 15,
            right: 10,
            top: 80,
            bottom: 15,
          ),
          color: widget.pairList[index].isArchive == "false"
              ? Colors.transparent
              : Colors.grey[700],
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
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
              Divider(
                color: Theme.of(context).textSelectionColor,
              ),
              _deleteAndArchiveButtons(context, index),
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
        widget.pairList[index].picUrl == "brak"
            ? PairCircleAvatar(
                picUrl: widget.pairList[index].picUrl,
                isAssets: true,
              )
            : PairCircleAvatar(
                picUrl: widget.pairList[index].picUrl,
                isAssets: false,
              ),
      ],
    );
  }

  Row _deleteAndArchiveButtons(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton.icon(
          padding: EdgeInsets.all(5),
          label: Text(
            "Usuń Parę",
            style: TextStyle(
              color: Colors.red,
              fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
            ),
          ),
          icon: Icon(
            MaterialCommunityIcons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            _globalMethods.showDeletingDialog(
              context,
              "Usuń parę",
              "Napewno usunąć wybraną parę z hodowli?",
              (_) {
                _deletePair(
                    widget.pairList[index].id,
                    widget.pairList[index].femaleRingNumber,
                    widget.pairList[index].maleRingNumber,
                    widget.pairList[index].picUrl);
              },
              null,
            );
          },
        ),
        widget.pairList[index].isArchive == "false"
            ? FlatButton.icon(
                padding: EdgeInsets.all(5),
                label: Text(
                  "Do Archiwum",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
                  ),
                ),
                icon: Icon(
                  MaterialCommunityIcons.archive,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
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
              )
            : Center(),
      ],
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
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ParrotDialogInformation(
                          parrotRace: widget.race,
                          parrotRing: content,
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

  Future<void> _deletePair(
      String id, String femaleId, String maleID, String picUrl) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await _globalMethods.checkInternetConnection(context);

    if (!result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PairListScreen(
            raceName: widget.race,
            parrotList: widget.parrotList,
          ),
        ),
      );
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
    } else {
      setState(() {
        _isLoading = true;
      });
      widget.parrotList.forEach((parr) {
        if (parr.ringNumber == femaleId) {
          chosenFemaleParrot = parr;
        } else if (parr.ringNumber == maleID) {
          chosenMaleParrot = parr;
        }
      });

      Navigator.of(context).pop();

      await _parrotPairDataHelper
          .deletePair(
        _firebaseUser.uid,
        widget.race,
        id,
        chosenFemaleParrot,
        chosenMaleParrot,
        picUrl,
      )
          .then((_) {
        _globalMethods.showMaterialDialog(
            context, "Usunięto wybraną parę papug");
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      });
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
          _globalMethods.showMaterialDialog(context, "Przesunięto do archiwum");
        },
      ).catchError((error) {
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      });
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

class PairCircleAvatar extends StatefulWidget {
  const PairCircleAvatar({
    @required this.picUrl,
    this.isAssets,
  });

  final String picUrl;
  final bool isAssets;

  @override
  _PairCircleAvatarState createState() => _PairCircleAvatarState();
}

class _PairCircleAvatarState extends State<PairCircleAvatar> {
  String takenURL;
  bool isMaximaze = false;

  Future _getImage(String basicUrl) async {
    final ref = FirebaseStorage.instance.ref().child(basicUrl);
    takenURL = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    takenURL = null;
    return FutureBuilder(
      future: _getImage(widget.picUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: isMaximaze
                      ? (MediaQuery.of(context).size.width / 2) - 15
                      : 60,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            break;
          case ConnectionState.done:
            {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isMaximaze = !isMaximaze;
                  });
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: isMaximaze
                        ? (MediaQuery.of(context).size.width / 2) - 10
                        : 60,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: isMaximaze
                          ? (MediaQuery.of(context).size.width / 2) - 15
                          : 57,
                      backgroundImage: widget.isAssets || takenURL == null
                          ? AssetImage(
                              "assets/image/parrotsRace/parrot_pair.jpg")
                          : NetworkImage("$takenURL"),
                    ),
                  ),
                ),
              );
            }
            break;

          default:
            {
              return Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: isMaximaze
                      ? (MediaQuery.of(context).size.width / 2) - 10
                      : 60,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: isMaximaze
                        ? (MediaQuery.of(context).size.width / 2) - 15
                        : 57,
                    backgroundImage:
                        AssetImage("assets/image/parrotsRace/parrot_pair.jpg"),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
