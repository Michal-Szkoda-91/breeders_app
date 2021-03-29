import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';

class AddPairScreen extends StatefulWidget {
  static const String routeName = "/AddPairingScreen";
  final raceName;

  const AddPairScreen({this.raceName});

  @override
  _AddPairScreenState createState() => _AddPairScreenState();
}

class _AddPairScreenState extends State<AddPairScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  List<Parrot> _allParrotsList = [];
  List<Parrot> _maleParrotList = [];
  List<Parrot> _femaleParrotList = [];
  String _choosenMaleParrotRingNumber;
  String _choosenFeMaleParrotRingNumber;
  Parrot _femaleParrotChoosen;
  Parrot _maleParrotChoosen;
  ParrotPairing pair;
  String pairTime = DateFormat.yMd('pl_PL').format(DateTime.now()).toString();

  void _createListsOfParrot(List<Parrot> allParrotsList) {
    _maleParrotList = [];
    _femaleParrotList = [];

    allParrotsList.forEach((parrot) {
      print("_____________" + parrot.pairRingNumber.toString());
      if (parrot.sex == "Samiec" &&
          parrot.race == widget.raceName &&
          parrot.pairRingNumber == "brak") {
        _maleParrotList.add(parrot);
        if (_choosenMaleParrotRingNumber == null)
          _choosenMaleParrotRingNumber = _maleParrotList[0].ringNumber;
      } else if (parrot.sex == "Samica" &&
          parrot.race == widget.raceName &&
          parrot.pairRingNumber == "brak") {
        _femaleParrotList.add(parrot);
        if (_choosenFeMaleParrotRingNumber == null)
          _choosenFeMaleParrotRingNumber = _femaleParrotList[0].ringNumber;
      } else
        return;
    });
  }

  ParrotPairingList dataPairProvider;
  ParrotPairing _createdPair;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<ParrotsList>(context);
    dataPairProvider = Provider.of<ParrotPairingList>(context);
    _allParrotsList = dataProvider.getParrotList;
    _createListsOfParrot(_allParrotsList);
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Parowanie Papug"),
      ),
      body: MainBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                createCard(
                    context: context,
                    text: "Samica (0,1)",
                    alterText: "Brak Samic z wybranego gatunku",
                    color: Colors.pink,
                    icon: MaterialCommunityIcons.gender_female,
                    gender: _createDropdownButtonFeMale,
                    list: _femaleParrotList),
                SizedBox(
                  height: 15,
                ),
                createCard(
                  context: context,
                  text: "Samiec (1,0)",
                  alterText: "Brak Samców z wybranego gatunku",
                  color: Colors.blue,
                  icon: MaterialCommunityIcons.gender_male,
                  gender: _createDropdownButtonMale,
                  list: _maleParrotList,
                ),
                SizedBox(height: 15),
                buildRowCalendar(context),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Theme.of(context).backgroundColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: _createInfoText(
                        context,
                        'Anuluj',
                      ),
                    ),
                    FlatButton(
                      color: Theme.of(context).backgroundColor,
                      onPressed: _createPair,
                      child: _createInfoText(
                        context,
                        'Utwórz parę',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card createCard(
      {BuildContext context,
      String text,
      String alterText,
      Color color,
      IconData icon,
      Function gender,
      List list}) {
    return Card(
      color: Colors.transparent,
      shadowColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _customTextIcon(
              context,
              text,
              icon,
              color,
            ),
            SizedBox(
              height: 20,
            ),
            list.isEmpty
                ? _createInfoText(context, alterText)
                : gender(context),
          ],
        ),
      ),
    );
  }

  Text _createInfoText(BuildContext context, String text) {
    return Text(
      text,
      style:
          TextStyle(fontSize: 16, color: Theme.of(context).textSelectionColor),
    );
  }

  DropdownButton _createDropdownButtonMale(BuildContext context) {
    return DropdownButton(
      itemHeight: 80,
      isExpanded: true,
      value: _choosenMaleParrotRingNumber,
      icon: Icon(
        Icons.arrow_downward,
        size: 30,
        color: Theme.of(context).textSelectionColor,
      ),
      iconSize: 24,
      elevation: 40,
      dropdownColor: Theme.of(context).backgroundColor,
      underline: Container(height: 0),
      onChanged: (val) {
        setState(() {
          _choosenMaleParrotRingNumber = val;
        });
      },
      items: _maleParrotList.map((parrot) {
        return DropdownMenuItem(
          value: parrot.ringNumber,
          child: createDropdownButton(parrot, context),
        );
      }).toList(),
    );
  }

  Widget createDropdownButton(Parrot parrot, BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parrot.ringNumber,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Kolor: " + parrot.color,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            Divider(
              color: Theme.of(context).textSelectionColor,
              height: 10,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton _createDropdownButtonFeMale(BuildContext context) {
    return DropdownButton(
      itemHeight: 80,
      isExpanded: true,
      value: _choosenFeMaleParrotRingNumber,
      icon: Icon(
        Icons.arrow_downward,
        size: 30,
        color: Theme.of(context).textSelectionColor,
      ),
      iconSize: 24,
      elevation: 40,
      dropdownColor: Theme.of(context).backgroundColor,
      underline: Container(height: 0),
      onChanged: (val) {
        setState(() {
          _choosenFeMaleParrotRingNumber = val;
        });
      },
      items: _femaleParrotList.map((parrot) {
        return DropdownMenuItem(
          value: parrot.ringNumber,
          child: createDropdownButton(parrot, context),
        );
      }).toList(),
    );
  }

  Row _customTextIcon(
      BuildContext context, String text, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 24,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          icon,
          color: color,
          size: 40,
        )
      ],
    );
  }

  Column buildRowCalendar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
          color: Theme.of(context).backgroundColor,
          onPressed: () {
            showDatePicker(
              context: context,
              locale: const Locale("pl", "PL"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
              cancelText: "Anuluj",
            ).then((date) {
              setState(() {
                pairTime = DateFormat.yMd('pl_PL').format(date).toString();
              });
            });
          },
          child: _createInfoText(
            context,
            'Data parowania Papug',
          ),
        ),
        Card(
          color: Colors.transparent,
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              pairTime,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).textSelectionColor),
            ),
          ),
        ),
      ],
    );
  }

  void _createPair() {
    if (_choosenFeMaleParrotRingNumber == null ||
        _choosenFeMaleParrotRingNumber == null) {
      return;
    } else {
      setState(() {
        _createdPair = ParrotPairing(
          id: "$_choosenFeMaleParrotRingNumber / $_choosenMaleParrotRingNumber / ${DateTime.now()}",
          femaleRingNumber: _choosenFeMaleParrotRingNumber,
          maleRingNumber: _choosenMaleParrotRingNumber,
          pairingData: pairTime,
          childrenList: [],
        );
        _maleParrotList.forEach((parrot) {
          if (parrot.ringNumber == _choosenMaleParrotRingNumber) {
            _maleParrotChoosen = parrot;
          }
        });
        _femaleParrotList.forEach((parrot) {
          if (parrot.ringNumber == _choosenFeMaleParrotRingNumber) {
            _femaleParrotChoosen = parrot;
          }
        });
        Navigator.of(context).pop();
      });
      dataPairProvider.createPairCollection(
        uid: firebaseUser.uid,
        pair: _createdPair,
        race: widget.raceName,
        maleParrot: _maleParrotChoosen,
        femaleParrot: _femaleParrotChoosen,
      );
    }
  }
}
