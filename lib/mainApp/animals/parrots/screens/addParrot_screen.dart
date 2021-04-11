import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/children_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';

class AddParrotScreen extends StatefulWidget {
  static const String routeName = "/AddParrotScreen";

  final Map<dynamic, dynamic> parrotMap;
  final Parrot parrot;
  final ParrotPairing pair;
  final String race;

  AddParrotScreen({this.parrotMap, this.parrot, this.pair, this.race});

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
  String cageNumber = "brak";
  String notes = "brak";
  Map<double, String> genderMap = {
    1.0: 'Samiec',
    2.0: 'Samica',
    3.0: 'Nieznana'
  };
  double sex = 1.0;
  String sexName = "";
  String actualRing = "";
  String bornTime = DateFormat.yMd('pl_PL').format(DateTime.now()).toString();

  Pattern _countryPatter = r'^([A-Z]+)$';
  Pattern _yearPatter = r'^(\d{2}|\d{4})$';
  Pattern _numberPatter = r'^(\d*)$';

  ParrotDataHelper dataProvider = ParrotDataHelper();
  ParrotPairDataHelper pairDataprovider = ParrotPairDataHelper();
  Parrot _createdParrot;
  Children _createdChild;

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
                    widget.parrot != null
                        ? widget.parrot.pairRingNumber == "brak"
                            ? genderSwitchRow(context, sex)
                            : infoText(context, widget.parrot.sex)
                        : genderSwitchRow(context, sex),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //Ring number
                    infoText(context, "Numer obrączki"),
                    SizedBox(height: _sizedBoxHeight),
                    widget.parrot != null
                        ? infoText(context, widget.parrot.ringNumber)
                        : ringNumberRow(
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
                    //  Born Time
                    //
                    SizedBox(height: _sizedBoxHeight),
                    Row(
                      children: [
                        Spacer(),
                        buildRowCalendar(context),
                        Spacer(),
                      ],
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
                    SizedBox(height: _sizedBoxHeight), //
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
              (widget.parrot == null && widget.pair == null)
                  ? _addParrotConfimButton(context)
                  : widget.pair == null
                      ? _editParrotConfirmButton(context)
                      : _addParrotConfimButtonChild(context),
            ],
          ),
        ),
      )),
    );
  }

  Row _editParrotConfirmButton(BuildContext context) {
    return Row(
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
          onPressed: () {
            _createParrots();
          },
        ),
      ],
    );
  }

  Row _addParrotConfimButtonChild(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: const SizedBox(),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'Utwórz Potomka',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          //create a parrot
          onPressed: () {
            _createParrots();
            _createChild();
          },
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

  Future<void> _createParrots() async {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie udało się dodać papugi, nie pełne dane");
    } else {
      bool result = await DataConnectionChecker().hasConnection;
      setState(() {
        ringNumber = "$country-$year-$symbol-$parrotNumber";
      });

      if (!result) {
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
        return;
      } else {
        setState(() {
          String race = "";
          widget.pair == null
              ? race = widget.parrotMap['name']
              : race = widget.race;
          _createdParrot = Parrot(
              race: race,
              ringNumber: ringNumber,
              cageNumber: cageNumber,
              color: parrotColor,
              fission: fission,
              notes: notes,
              sex: sexName);
        });
        try {
          dataProvider
              .createParrotCollection(
            uid: firebaseUser.uid,
            parrot: _createdParrot,
          )
              .then((_) {
            Navigator.of(context).pop();
            _globalMethods.showMaterialDialog(context, "Dodano Papugę");
          });
        } catch (e) {
          _globalMethods.showMaterialDialog(context,
              "Operacja nieudana, nieznany błąd lub brak połączenia z internetem!");
        }
      }
    }
  }

  Future<void> _createChild() async {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie udało się dodać papugi, nie pełne dane");
    } else {
      bool result = await DataConnectionChecker().hasConnection;
      setState(() {
        ringNumber = "$country-$year-$symbol-$parrotNumber";
      });

      if (!result) {
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
        return;
      } else {
        setState(() {
          _createdChild = Children(
            broodDate: bornTime,
            color: parrotColor,
            gender: sexName,
            ringNumber: ringNumber,
          );
        });
        try {
          pairDataprovider
              .createChild(
            uid: firebaseUser.uid,
            race: widget.race,
            child: _createdChild,
            pairId: widget.pair.id,
          )
              .then((_) {
            Navigator.of(context).pop();
            _globalMethods.showMaterialDialog(context, "Utworzono potomka");
          });
        } catch (e) {
          _globalMethods.showMaterialDialog(context,
              "Operacja nieudana, nieznany błąd lub brak połączenia z internetem!");
        }
      }
    }
  }

  Future<void> _editParrot() async {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie udało się edytować papugi, nie pełne dane");
    } else {
      bool result = await DataConnectionChecker().hasConnection;
      if (!result) {
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
        return;
      } else {
        setState(() {
          _createdParrot = Parrot(
              race: widget.parrot.race,
              ringNumber: widget.parrot.ringNumber,
              cageNumber: cageNumber,
              color: parrotColor,
              fission: fission,
              notes: notes,
              sex: sexName,
              pairRingNumber: widget.parrot.pairRingNumber);
        });
        try {
          dataProvider
              .updateParrot(
            uid: firebaseUser.uid,
            parrot: _createdParrot,
            pairRingNumber: _createdParrot.pairRingNumber,
          )
              .then((_) {
            Navigator.of(context).pop();

            _globalMethods.showMaterialDialog(context, "Edytowano dane");
          });
        } catch (e) {
          _globalMethods.showMaterialDialog(context,
              "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
        }
      }
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
                bornTime = DateFormat.yMd('pl_PL').format(date).toString();
              });
            });
          },
          child: _createInfoText(
            context,
            'Data urodzenia papugi',
          ),
        ),
        Card(
          color: Colors.transparent,
          shadowColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              bornTime,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).textSelectionColor),
            ),
          ),
        ),
      ],
    );
  }

  Text _createInfoText(BuildContext context, String text) {
    return Text(
      text,
      style:
          TextStyle(fontSize: 16, color: Theme.of(context).textSelectionColor),
    );
  }
}
