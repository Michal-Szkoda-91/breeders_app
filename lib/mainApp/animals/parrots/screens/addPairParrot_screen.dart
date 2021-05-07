import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  GlobalMethods _globalMethods = GlobalMethods();
  ParrotDataHelper dataProvider = ParrotDataHelper();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  ScrollController _rrectController = ScrollController();

  List<Parrot> _allParrotList = [];
  List<Parrot> _maleParrotList = [];
  List<Parrot> _femaleParrotList = [];
  String _choosenMaleParrotRingNumber;
  String _choosenFeMaleParrotRingNumber;
  Parrot _femaleParrotChoosen;
  Parrot _maleParrotChoosen;
  String pairColor = "";
  ParrotPairing pair;
  String pairTime =
      DateFormat("yyyy-MM-dd", 'pl_PL').format(DateTime.now()).toString();

  void _createListsOfParrot(List<Parrot> allParrotsList) {
    _maleParrotList.clear();
    _femaleParrotList.clear();
    allParrotsList.forEach((parrot) {
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
      }
    });
  }

  ParrotPairing _createdPair;

  //load stream only once
  StreamBuilder _streamBuilder;
  @override
  void initState() {
    super.initState();
    _streamBuilder = StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(firebaseUser.uid)
          .doc(widget.raceName)
          .collection("Birds")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Błąd danych');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
              ),
            );
          default:
            _createParrotsList(snapshot);
            _createListsOfParrot(_allParrotList);
            return _createContent(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: AutoSizeText(
          "Parowanie - ${widget.raceName}",
          maxLines: 1,
        ),
      ),
      body: MainBackground(
        child: DraggableScrollbar.rrect(
          controller: _rrectController,
          heightScrollThumb: 100,
          backgroundColor: Theme.of(context).accentColor,
          child: SingleChildScrollView(
            controller: _rrectController,
            child: Column(
              children: [
                _streamBuilder,
                const SizedBox(height: 15),
                _createForm(context, node),
                const SizedBox(height: 15),
                buildRowCalendar(context),
                const SizedBox(height: 25),
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
                ),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createParrotsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    _allParrotList = [];
    snapshot.data.docs.forEach((val) {
      _allParrotList.add(Parrot(
        ringNumber: val.id,
        cageNumber: val.data()['Cage number'],
        color: val.data()['Colors'],
        fission: val.data()['Fission'],
        notes: val.data()['Notes'],
        pairRingNumber: val.data()['PairRingNumber'],
        race: widget.raceName,
        sex: val.data()['Sex'],
      ));
    });
  }

  Padding _createContent(BuildContext context) {
    return Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _createForm(BuildContext context, FocusScopeNode node) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          initialValue: pairColor,
          style: customTextStyle(context),
          cursorColor: Theme.of(context).textSelectionColor,
          maxLength: 30,
          maxLines: 1,
          decoration: _createInputDecoration(
            context,
            'Kolor Pary',
            null,
          ),
          validator: (val) {
            if (val.isEmpty) {
              return 'Uzupełnij dane';
            } else if (val.length > 30) {
              return 'Zbyt długi tekst';
            } else {
              return null;
            }
          },
          onChanged: (val) {
            setState(() {
              pairColor = val;
            });
          },
          onEditingComplete: () => node.nextFocus(),
        ),
      ),
    );
  }

  //Styl tekstu w inputach
  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
      fontSize: 16,
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
                pairTime =
                    DateFormat("yyyy-MM-dd", 'pl_PL').format(date).toString();
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

  Future<void> _createPair() async {
    if (_choosenFeMaleParrotRingNumber == null ||
        _choosenFeMaleParrotRingNumber == null ||
        !_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie można utworzyć pary, niepełne dane");
      return;
    } else {
      bool result = await _globalMethods.checkInternetConnection(context);

      if (!result) {
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
      } else {
        setState(() {
          _createdPair = ParrotPairing(
            id: "$_choosenFeMaleParrotRingNumber - $_choosenMaleParrotRingNumber - ${DateTime.now()}",
            femaleRingNumber: _choosenFeMaleParrotRingNumber,
            maleRingNumber: _choosenMaleParrotRingNumber,
            pairingData: pairTime,
            pairColor: pairColor,
          );
          print(_createdPair.id + "wybrana ID");
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
        });
        try {
          await _parrotPairDataHelper
              .createPairCollection(
            uid: firebaseUser.uid,
            pair: _createdPair,
            race: widget.raceName,
            maleParrot: _maleParrotChoosen,
            femaleParrot: _femaleParrotChoosen,
          )
              .then((_) {
            _choosenFeMaleParrotRingNumber = null;
            _choosenMaleParrotRingNumber = null;
            Navigator.of(context).pop();
            _globalMethods.showMaterialDialog(context, "Utworzono parę");
          });
        } catch (e) {
          _globalMethods.showMaterialDialog(context, "Operacja nieudana");
        }
      }
    }
  }

  InputDecoration _createInputDecoration(
      BuildContext context, String text, IconData icon) {
    return InputDecoration(
      contentPadding:
          EdgeInsets.symmetric(horizontal: icon == null ? 3 : 14, vertical: 10),
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      labelText: text,
      icon: icon == null
          ? null
          : Icon(
              icon,
              color: Theme.of(context).textSelectionColor,
            ),
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      filled: true,
      fillColor: Theme.of(context).primaryColor,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: Theme.of(context).primaryColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          width: 3,
          color: Theme.of(context).textSelectionColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).textSelectionColor,
        ),
      ),
    );
  }
}