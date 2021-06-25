import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../models/pairing_model.dart';
import '../models/parrot_model.dart';
import '../../../../models/global_methods.dart';
import 'parrot_pair_card_widgets/CreatePairCard.dart';

class ParrotPairCard extends StatefulWidget {
  final String race;
  final List<Parrot> parrotList;
  final List<ParrotPairing> pairList;
  const ParrotPairCard({
    required this.pairList,
    required this.race,
    required this.parrotList,
  });

  @override
  _ParrotPairCardState createState() => _ParrotPairCardState();
}

class _ParrotPairCardState extends State<ParrotPairCard> {
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  late Parrot chosenMaleParrot;
  late Parrot chosenFemaleParrot;
  ScrollController _rrectController = ScrollController();
  bool _isLoading = false;
  GlobalMethods _globalMethods = GlobalMethods();

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
          widget.pairList.sort((a, b) =>
              a.pairColor.toLowerCase().compareTo(b.pairColor.toLowerCase()));
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
            child: ListView.builder(
              controller: _rrectController,
              itemCount: 1,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _sortingColumn(context),
                    const SizedBox(height: 15),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.pairList.length,
                      itemBuilder: (context, index) {
                        return CreatePairCard(
                          index: index,
                          pairList: widget.pairList,
                          race: widget.race,
                          delete: _deletePair,
                          toArchive: _movingToArchive,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          )
        : const Center(
            child: const CircularProgressIndicator(),
          );
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
                color: Theme.of(context).textSelectionTheme.selectionColor,
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
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 12,
            ),
            unselectedTextStyle: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 12,
            ),
            onSelected: (index, isSelected) => _sortingBy(index),
            buttons: ["Data Parowania", "Kolor"],
          )
        ],
      ),
    );
  }

  Future<void> _deletePair(
      String id, String femaleId, String maleID, String picUrl) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoading = true;
    });
    await _globalMethods.checkInternetConnection(context).then((result) async {
      if (!result) {
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(
            context, "Brak połączenia z internetem.");
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        widget.parrotList.forEach((parr) {
          if (parr.ringNumber == femaleId) {
            chosenFemaleParrot = parr;
          } else if (parr.ringNumber == maleID) {
            chosenMaleParrot = parr;
          }
        });
        Navigator.of(context).pop();
        await _parrotPairDataHelper.deletePair(
          uid: _firebaseUser!.uid,
          race: widget.race,
          id: id,
          femaleParrot: chosenFemaleParrot,
          maleParrot: chosenMaleParrot,
          picUrl: picUrl,
          context: context,
        );
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _movingToArchive(
      String id, String femaleId, String maleID) async {
    setState(() {
      _isLoading = true;
    });
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    await _globalMethods.checkInternetConnection(context).then((result) async {
      if (!result) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(
            context, "Brak połączenia z internetem.");
      } else {
        widget.parrotList.forEach((parr) {
          if (parr.ringNumber == femaleId) {
            chosenFemaleParrot = parr;
          } else if (parr.ringNumber == maleID) {
            chosenMaleParrot = parr;
          }
        });
        Navigator.of(context).pop();
        await _parrotPairDataHelper.moveToArchive(
          _firebaseUser!.uid,
          widget.race,
          id,
          chosenFemaleParrot,
          chosenMaleParrot,
          context,
        );
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
