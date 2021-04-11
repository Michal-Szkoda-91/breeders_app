import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'parrotDialogInformation.dart';

class ParrotPairCard extends StatefulWidget {
  final String race;
  final List<Parrot> parrotList;
  const ParrotPairCard({
    Key key,
    @required List<ParrotPairing> pairList,
    this.race,
    this.parrotList,
  })  : _pairList = pairList,
        super(key: key);

  final List<ParrotPairing> _pairList;

  @override
  _ParrotPairCardState createState() => _ParrotPairCardState();
}

class _ParrotPairCardState extends State<ParrotPairCard> {
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  Parrot chosenMaleParrot;
  Parrot chosenFemaleParrot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget._pairList.length,
          itemBuilder: (context, index) {
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.35,
              closeOnScroll: true,
              child: Row(
                children: [
                  Expanded(child: _createCard(context, index)),
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
                            widget._pairList[index].id,
                            widget._pairList[index].femaleRingNumber,
                            widget._pairList[index].maleRingNumber);
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
              ],
            );
          },
        ),
      ),
    );
  }

  Card _createCard(BuildContext context, int index) {
    return Card(
      color: Colors.transparent,
      shadowColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createInfoRow(
              context,
              "Data utworzenia pary: ",
              widget._pairList[index].pairingData,
            ),
            SizedBox(height: 10),
            _createInfoRow(
              context,
              "Kolor Pary: ",
              widget._pairList[index].pairColor,
            ),
            SizedBox(height: 10),
            _createInfoRowParrot(
              context,
              "Samica(0,1): ",
              widget._pairList[index].femaleRingNumber,
            ),
            SizedBox(height: 10),
            _createInfoRowParrot(
              context,
              "Samiec(1,0): ",
              widget._pairList[index].maleRingNumber,
            ),
          ],
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
    bool result = await DataConnectionChecker().hasConnection;

    if (!result) {
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
}
