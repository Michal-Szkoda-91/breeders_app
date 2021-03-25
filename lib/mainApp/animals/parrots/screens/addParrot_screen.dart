import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'parrot_race_list_screen.dart';

class AddParrotScreen extends StatefulWidget {
  static const String routeName = "/AddParrotScreen";

  final Map<dynamic, dynamic> parrotMap;
  final Parrot parrot;

  AddParrotScreen({this.parrotMap, this.parrot});

  @override
  _RaceListScreenState createState() => _RaceListScreenState();
}

class _RaceListScreenState extends State<AddParrotScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  GlobalMethods _globalMethods = GlobalMethods();

  final double _sizedBoxHeight = 16.0;

  String country = "PL";
  String year = DateTime.now().year.toString();
  String symbol = "";
  String parrotNumber = "";
  String ringNumber = "";
  String parrotColor = "";
  String fission = "";
  String cageNumber = "";
  String notes = "brak";
  Map<double, String> genderMap = {
    1.0: 'Samiec',
    2.0: 'Samica',
    3.0: 'Nieznana'
  };
  double sex = 1.0;
  String sexName = "";
  String actualRing = "";

  Pattern _countryPatter = r'^([A-Z]+)$';
  Pattern _yearPatter = r'^(\d{2}|\d{4})$';
  Pattern _numberPatter = r'^(\d*)$';

  ParrotsList dataProvider;
  Parrot _createdParrot;

  @override
  void initState() {
    super.initState();
    sexName = genderMap[1.0];
    if (widget.parrot != null) {
      _isEditing(widget.parrot);
      print("edycja");
    }
  }

  void _isEditing(Parrot parrot) {
    sex = genderMap.keys.firstWhere((key) => genderMap[key] == parrot.sex);
    sexName = parrot.sex;
    country = parrot.ringNumber.split("-")[0];
    year = parrot.ringNumber.split("-")[1];
    symbol = parrot.ringNumber.split("-")[2];
    parrotNumber = parrot.ringNumber.split("-")[3];
    parrotColor = parrot.color;
    cageNumber = parrot.cageNumber;
    fission = parrot.fission;
    notes = parrot.notes;

    //save actual parrot ring
    actualRing = parrot.ringNumber;
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<ParrotsList>(context);
    RegExp _regExpCountry = RegExp(_countryPatter);
    RegExp _regExpYear = RegExp(_yearPatter);
    RegExp _regExpNumber = RegExp(_numberPatter);
    final node = FocusScope.of(context);
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:
            widget.parrot != null ? Text("Edycja") : Text("Dodawanie Papugi"),
      ),
      body: MainBackground(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: _sizedBoxHeight),
              customTitle(context),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //******************************************************* */
                    //Sex
                    genderSwitchRow(context, sex),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //Ring number
                    infoText(context, "Numer obrączki"),
                    SizedBox(height: _sizedBoxHeight),
                    ringNumberRow(
                      context,
                      _regExpCountry,
                      node,
                      _regExpYear,
                      _regExpNumber,
                      country,
                      year,
                      symbol,
                      parrotNumber,
                    ),
                    SizedBox(height: _sizedBoxHeight),

                    //
                    //******************************************************* */
                    //Color
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Wprowadż barwę papugi',
                      icon: Icons.color_lens,
                      mainValue: 'parrotColor',
                      maxlines: 1,
                      maxLength: 30,
                      initvalue: parrotColor,
                    ),
                    SizedBox(height: _sizedBoxHeight),

                    //
                    //******************************************************* */
                    //cage number
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Numer / nazwa klatki',
                      icon: Icons.home_outlined,
                      mainValue: 'cageNumber',
                      maxlines: 1,
                      maxLength: 30,
                      initvalue: cageNumber,
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //Fission
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Jakie rozszczepienie',
                      icon: Icons.star_border_purple500_outlined,
                      mainValue: 'fission',
                      maxlines: 2,
                      maxLength: 50,
                      initvalue: fission,
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //notes
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Notatka / Dodatkowa informacja',
                      icon: Icons.home_outlined,
                      mainValue: 'notes',
                      maxlines: 10,
                      maxLength: 100,
                      initvalue: notes,
                    ),
                  ],
                ),
              ),
              SizedBox(height: _sizedBoxHeight),
              widget.parrot == null
                  ? _addParrotConfimButton(context)
                  : Row(
                      children: [
                        Expanded(child: SizedBox()),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Zapisz zmiany',
                            style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                            ),
                          ),
                          //edit a parrot
                          onPressed: _editParrot,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Anuluj',
                            style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                            ),
                          ),
                          //create a parrot
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
              SizedBox(height: 100),
            ],
          ),
        ),
      )),
    );
  }

  Row _addParrotConfimButton(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: const SizedBox(),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'Dodaj Papugę',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          //create a parrot
          onPressed: _createParrots,
        ),
      ],
    );
  }
  //BUILD METODS
// ******************************************************************************************

  TextFormField customTextFormField({
    BuildContext context,
    FocusScopeNode node,
    String hint,
    IconData icon,
    String mainValue,
    int maxLength,
    int maxlines,
    String initvalue,
  }) {
    return TextFormField(
      initialValue: initvalue,
      style: customTextStyle(context),
      cursorColor: Theme.of(context).textSelectionColor,
      maxLength: maxLength,
      maxLines: maxlines,
      minLines: 1,
      decoration: _createInputDecoration(
        context,
        hint,
        icon,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val.isEmpty || val.length > maxLength) {
          return 'Uzupełnij dane';
        } else {
          return null;
        }
      },
      onChanged: (val) {
        setState(() {
          switch (mainValue) {
            case 'parrotColor':
              parrotColor = val;
              break;
            case 'fission':
              fission = val;
              break;
            case 'cageNumber':
              cageNumber = val;
              break;
            case 'notes':
              notes = val;
              break;
            default:
              return;
          }
        });
      },
      onEditingComplete: () => node.nextFocus(),
    );
  }

  Row genderSwitchRow(BuildContext context, double initSex) {
    return Row(
      children: [
        infoText(context, "Płeć:"),
        Expanded(
          child: Slider(
            value: initSex,
            activeColor: sex == 1.0
                ? Colors.blue
                : sex == 2.0
                    ? Colors.pinkAccent
                    : Colors.green,
            max: 3,
            min: 1,
            divisions: 2,
            onChanged: (val) {
              setState(() {
                sex = val;
                sexName = genderMap[val];
              });
            },
          ),
        ),
        infoText(context, sexName),
      ],
    );
  }

  Row ringNumberRow(
      BuildContext context,
      RegExp _regExpCountry,
      FocusScopeNode node,
      RegExp _regExpYear,
      RegExp _regExpNumber,
      String initCountry,
      String initYear,
      String initSymbol,
      String initNumber) {
    return Row(
      children: [
        //
        //
        //************************************ */
        // Country
        Expanded(
          flex: 4,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 4,
            initialValue: initCountry,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Kraj',
              null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val.isEmpty || !_regExpCountry.hasMatch(val)) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                country = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
        infoText(context, " - "),
        //
        //
        //************************************ */
        // Year
        Expanded(
          flex: 4,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 4,
            initialValue: initYear,
            keyboardType: TextInputType.number,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Rok',
              null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val.isEmpty || !_regExpYear.hasMatch(val)) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                year = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
        infoText(context, " - "),
        //
        //
        //************************************ */
        // Symbol
        Expanded(
          flex: 6,
          child: TextFormField(
            initialValue: initSymbol,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Symbol',
              null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val.isEmpty || val.length > 6) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                symbol = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
        infoText(context, " - "),
        //
        //************************************ */
        // Number
        Expanded(
          flex: 5,
          child: TextFormField(
            initialValue: initNumber,
            textAlign: TextAlign.center,
            maxLength: 5,
            keyboardType: TextInputType.number,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Numer',
              null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val.isEmpty ||
                  !_regExpNumber.hasMatch(val) ||
                  val.length > 5) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                parrotNumber = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
      ],
    );
  }

  Text infoText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).textSelectionColor,
      ),
    );
  }

  void _createParrots() {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showInSnackBar("Nie udało się dodać papugi", context);
    } else {
      setState(() {
        ringNumber = "$country-$year-$symbol-$parrotNumber";
        _createdParrot = Parrot(
            race: widget.parrotMap['name'],
            ringNumber: ringNumber,
            cageNumber: cageNumber,
            color: parrotColor,
            fission: fission,
            notes: notes,
            sex: sexName);
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ParrotsRaceListScreen(
              name: "Hodowla Papug",
            ),
          ),
        );
      });
      dataProvider.createParrotCollection(
        uid: firebaseUser.uid,
        parrot: _createdParrot,
      );
    }
  }

  void _editParrot() {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showInSnackBar("Nie udało się edytować", context);
    } else {
      setState(() {
        ringNumber = "$country-$year-$symbol-$parrotNumber";
        _createdParrot = Parrot(
            race: widget.parrot.race,
            ringNumber: ringNumber,
            cageNumber: cageNumber,
            color: parrotColor,
            fission: fission,
            notes: notes,
            sex: sexName);
      });
      dataProvider
          .updateParrot(
        uid: firebaseUser.uid,
        parrot: _createdParrot,
        actualparrotRing: actualRing,
      )
          .then((_) {
        if (actualRing != _createdParrot.ringNumber) {
          _createdParrot = Parrot(
              race: widget.parrot.race,
              ringNumber: actualRing,
              cageNumber: cageNumber,
              color: parrotColor,
              fission: fission,
              notes: notes,
              sex: sexName);
          dataProvider.deleteParrot(
            firebaseUser.uid,
            _createdParrot,
          );
        }
        _globalMethods.showInSnackBar("Edytowano papugę!", context);
        Navigator.of(context).pop();
        print("udalo");
      }).catchError((_) {
        Navigator.of(context).pop();
        print("nie udalo");
      });
    }
  }

//Styl tekstu w inputach
  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
      fontSize: 16,
    );
  }

  Row customTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).backgroundColor,
          child: CircleAvatar(
            radius: 46,
            backgroundImage: AssetImage(
              widget.parrotMap['url'],
            ),
          ),
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: AutoSizeText(
            widget.parrot == null
                ? widget.parrotMap['name']
                : widget.parrot.race,
            maxLines: 1,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).textSelectionColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
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
