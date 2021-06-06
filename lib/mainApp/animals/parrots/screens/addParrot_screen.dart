import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/children_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
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
  final _firebaseUser = FirebaseAuth.instance.currentUser;
  ScrollController _rrectController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  GlobalMethods _globalMethods = GlobalMethods();

  String _country = "PL";
  String _year = DateTime.now().year.toString();
  String _symbol = "";
  String _parrotNumber = "";
  String _ringNumber = "";
  String _parrotColor = "";
  String _fission = "";
  String _cageNumber = "brak";
  String _notes = "brak";
  Map<double, String> _genderMap = {
    1.0: 'Samiec',
    2.0: 'Samica',
    3.0: 'Nieznana'
  };
  double _sex = 1.0;
  String _sexName = "";
  String bornTime =
      DateFormat("yyyy-MM-dd", 'pl_PL').format(DateTime.now()).toString();

  Pattern _countryPatter = r'^([A-Z]+)$';
  Pattern _yearPatter = r'^(\d{2}|\d{4})$';
  Pattern _numberPatter = r'^(\d*)$';

  ParrotDataHelper _parrotDataHelper = ParrotDataHelper();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  Parrot _createdParrot;
  Children _createdChild;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sexName = _genderMap[1.0];
    if (widget.parrot != null) {
      _isEditing(widget.parrot);
    }
  }

  void _isEditing(Parrot parrot) {
    _sex = _genderMap.keys.firstWhere((key) => _genderMap[key] == parrot.sex);
    _sexName = parrot.sex;
    _country = parrot.ringNumber.split("-")[0];
    _year = parrot.ringNumber.split("-")[1];
    _symbol = parrot.ringNumber.split("-")[2];
    _parrotNumber = parrot.ringNumber.split("-")[3];
    _parrotColor = parrot.color;
    _cageNumber = parrot.cageNumber;
    _fission = parrot.fission;
    _notes = parrot.notes;
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
        title: widget.parrot != null
            ? const Text("Edycja")
            : const Text("Dodawanie Papugi"),
      ),
      body: !_isLoading
          ? MainBackground(
              child: DraggableScrollbar.rrect(
                controller: _rrectController,
                heightScrollThumb: 100,
                backgroundColor: Theme.of(context).accentColor,
                child: SingleChildScrollView(
                  controller: _rrectController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16.0),
                        customTitle(context),
                        const SizedBox(height: 30),
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
                                      ? genderSwitchRow(context, _sex)
                                      : infoText(context, widget.parrot.sex)
                                  : genderSwitchRow(context, _sex),
                              widget.pair != null
                                  ? Center()
                                  : SizedBox(height: 16.0),
                              //
                              //******************************************************* */
                              //Ring number
                              infoText(context, "Numer obrączki"),
                              const SizedBox(height: 16.0),
                              widget.parrot != null
                                  ? infoText(context, widget.parrot.ringNumber)
                                  : ringNumberRow(
                                      context,
                                      _regExpCountry,
                                      node,
                                      _regExpYear,
                                      _regExpNumber,
                                      _country,
                                      _year,
                                      _symbol,
                                      _parrotNumber,
                                    ),
                              widget.pair != null
                                  ? const Center()
                                  : const SizedBox(height: 16.0),

                              //
                              //  Born Time
                              //
                              const SizedBox(height: 16.0),
                              widget.pair != null
                                  ? Row(
                                      children: [
                                        Spacer(),
                                        buildRowCalendar(context),
                                        Spacer(),
                                      ],
                                    )
                                  : const SizedBox(height: 16.0),

                              //
                              //******************************************************* */
                              //Color
                              const SizedBox(height: 16.0),
                              customTextFormField(
                                context: context,
                                node: node,
                                hint: 'Wprowadż barwę papugi',
                                icon: Icons.color_lens,
                                mainValue: 'parrotColor',
                                maxlines: 1,
                                maxLength: 30,
                                initvalue: _parrotColor,
                              ),
                              const SizedBox(height: 16.0),

                              //
                              //******************************************************* */
                              //Fission
                              widget.pair != null
                                  ? const Center()
                                  : customTextFormField(
                                      context: context,
                                      node: node,
                                      hint: 'Jakie rozszczepienie',
                                      icon:
                                          Icons.star_border_purple500_outlined,
                                      mainValue: 'fission',
                                      maxlines: 2,
                                      maxLength: 50,
                                      initvalue: _fission,
                                    ),
                              widget.pair != null
                                  ? const Center()
                                  : const SizedBox(height: 16.0), //
                              //******************************************************* */
                              //cage number
                              widget.pair != null
                                  ? const Center()
                                  : customTextFormField(
                                      context: context,
                                      node: node,
                                      hint: 'Numer / nazwa klatki',
                                      icon: Icons.home_outlined,
                                      mainValue: 'cageNumber',
                                      maxlines: 1,
                                      maxLength: 30,
                                      initvalue: _cageNumber,
                                    ),
                              widget.pair != null
                                  ? const Center()
                                  : const SizedBox(height: 16.0),
                              //
                              //******************************************************* */
                              //notes
                              widget.pair != null
                                  ? const Center()
                                  : customTextFormField(
                                      context: context,
                                      node: node,
                                      hint: 'Notatka / Dodatkowa informacja',
                                      icon: Icons.home_outlined,
                                      mainValue: 'notes',
                                      maxlines: 10,
                                      maxLength: 100,
                                      initvalue: _notes,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        (widget.parrot == null && widget.pair == null)
                            ? _addParrotConfimButton(context)
                            : widget.pair == null
                                ? _editParrotConfirmButton(context)
                                : _addParrotConfimButtonChild(context),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : MainBackground(
              child: const Center(
                child: const CircularProgressIndicator(),
              ),
            ),
    );
  }

  Row _editParrotConfirmButton(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: const SizedBox(),
        ),
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
        const SizedBox(width: 20),
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
              _parrotColor = val;
              break;
            case 'fission':
              _fission = val;
              break;
            case 'cageNumber':
              _cageNumber = val;
              break;
            case 'notes':
              _notes = val;
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
            activeColor: _sex == 1.0
                ? Colors.blue
                : _sex == 2.0
                    ? Colors.pinkAccent
                    : Colors.green,
            max: 3,
            min: 1,
            divisions: 2,
            onChanged: (val) {
              setState(() {
                _sex = val;
                _sexName = _genderMap[val];
              });
            },
          ),
        ),
        infoText(context, _sexName),
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
                _country = val;
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
                _year = val;
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
                _symbol = val;
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
                _parrotNumber = val;
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
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        setState(() {
          _ringNumber = "$_country-$_year-$_symbol-$_parrotNumber";
        });

        if (!result) {
          Navigator.of(context).pop();
          _globalMethods.showMaterialDialog(
              context, "brak połączenia z internetem.");
          return;
        } else {
          setState(() {
            _isLoading = true;
            String race = "";
            widget.pair == null
                ? race = widget.parrotMap['name']
                : race = widget.race;
            _createdParrot = Parrot(
                race: race,
                ringNumber: _ringNumber,
                cageNumber: _cageNumber,
                color: _parrotColor,
                fission: _fission,
                notes: _notes,
                sex: _sexName);
          });

          await _parrotDataHelper
              .createParrotCollection(
            uid: _firebaseUser.uid,
            parrot: _createdParrot,
          )
              .then((_) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
            _globalMethods.showMaterialDialog(context, "Dodano Papugę");
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });
            _globalMethods.showMaterialDialog(context,
                "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
          });
        }
      });
    }
  }

  Future<void> _createChild() async {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie udało się dodać papugi, nie pełne dane");
    } else {
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        setState(() {
          _ringNumber = "$_country-$_year-$_symbol-$_parrotNumber";
        });

        if (!result) {
          Navigator.of(context).pop();
          _globalMethods.showMaterialDialog(
              context, "brak połączenia z internetem.");
          return;
        } else {
          setState(() {
            _isLoading = true;
            _createdChild = Children(
              broodDate: bornTime,
              color: _parrotColor,
              gender: _sexName,
              ringNumber: _ringNumber,
            );
          });

          await _parrotPairDataHelper
              .createChild(
            uid: _firebaseUser.uid,
            race: widget.race,
            child: _createdChild,
            pairId: widget.pair.id,
          )
              .then((_) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
            _globalMethods.showMaterialDialog(context, "Utworzono potomka");
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });
            _globalMethods.showMaterialDialog(context,
                "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
          });
        }
      });
    }
  }

  Future<void> _editParrot() async {
    if (!_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie udało się edytować papugi, nie pełne dane");
    } else {
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        if (!result) {
          Navigator.of(context).pop();
          _globalMethods.showMaterialDialog(
              context, "brak połączenia z internetem.");
          return;
        } else {
          setState(
            () {
              _isLoading = true;
              _createdParrot = Parrot(
                  race: widget.parrot.race,
                  ringNumber: widget.parrot.ringNumber,
                  cageNumber: _cageNumber,
                  color: _parrotColor,
                  fission: _fission,
                  notes: _notes,
                  sex: _sexName,
                  pairRingNumber: widget.parrot.pairRingNumber);
            },
          );
          await _parrotDataHelper
              .updateParrot(
            uid: _firebaseUser.uid,
            parrot: _createdParrot,
            pairRingNumber: _createdParrot.pairRingNumber,
          )
              .then((_) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
            _globalMethods.showMaterialDialog(context, "Edytowano dane");
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });
            _globalMethods.showMaterialDialog(context,
                "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
          });
        }
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

  Widget customTitle(BuildContext context) {
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
        const Spacer(),
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
                bornTime =
                    DateFormat("yyyy-MM-dd", 'pl_PL').format(date).toString();
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
                fontSize: 18,
                color: Theme.of(context).textSelectionColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text _createInfoText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textSelectionColor,
      ),
    );
  }
}
