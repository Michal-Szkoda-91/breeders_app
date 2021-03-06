import 'dart:io';
import 'package:path/path.dart' as Path;

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../animals/parrots/models/parrot_model.dart';
import '../../../../globalWidgets/mainBackground.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../../services/auth.dart';
import '../models/children_model.dart';
import '../models/pairing_model.dart';
import '../../../../models/global_methods.dart';

class AddParrotScreen extends StatefulWidget {
  static const String routeName = "/AddParrotScreen";

  final Map<dynamic, dynamic> parrotMap;
  final Parrot parrot;
  final ParrotPairing pair;
  final String race;
  final bool addFromChild;
  final String data;

  AddParrotScreen({
    required this.parrotMap,
    required this.parrot,
    required this.pair,
    required this.race,
    required this.addFromChild,
    required this.data,
  });

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
  String _cageNumber = "";
  String _notes = "";
  Map<double, String> _genderMap = {
    1.0: 'Samiec',
    2.0: 'Samica',
    3.0: 'Nieznana'
  };
  double _sex = 1.0;
  String _sexName = "";
  String bornTime =
      DateFormat("yyyy-MM-dd", 'pl_PL').format(DateTime.now()).toString();
  String ringToDelChildren = '';

  Pattern _countryPatter = r'^([A-Z]+)$';
  Pattern _yearPatter = r'^(\d{2}|\d{4})$';
  Pattern _numberPatter = r'^(\d*)$';

  ParrotDataHelper _parrotDataHelper = ParrotDataHelper();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  late Parrot _createdParrot;
  late Parrot _parrotToDelete;
  late Children _createdChild;
  bool _isLoading = false;

  //Adding pic to parrot
  //
  //
  //
  String _pictureUrl = "";
  bool _isPhotoChoosen = false;
  PickedFile? _image;
  bool _isClicked = false;
  final _picker = ImagePicker();
  String takenURL = 'loading';

  Future getImageFromGalery() async {
    PickedFile? image = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 750,
    );
    if (image == null) {
      return;
    } else {
      if (mounted) {
        setState(() {
          _image = image;
          _isPhotoChoosen = false;
        });
      }
    }
  }

  Future getImageFromCamera() async {
    PickedFile? image = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 750,
    );
    if (image == null) {
      return;
    } else {
      if (mounted) {
        setState(() {
          _image = image;
          _isPhotoChoosen = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pictureUrl = widget.parrot.picUrl;
    _image = PickedFile(widget.parrotMap['url']);
    _sexName = _genderMap[1.0].toString();
    if (widget.parrot.ringNumber != 'brak') {
      _isEditing(widget.parrot);
    }
    if (widget.data != '') {
      bornTime = widget.data;
      ringToDelChildren = widget.parrot.ringNumber;
    }
  }

  Future _getImage(String basicUrl) async {
    final ref = FirebaseStorage.instance.ref().child(basicUrl);
    takenURL = await ref.getDownloadURL();
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
    _pictureUrl = parrot.picUrl;
    _getImage(_pictureUrl);
  }

  @override
  Widget build(BuildContext context) {
    RegExp _regExpCountry = RegExp(_countryPatter.toString());
    RegExp _regExpYear = RegExp(_yearPatter.toString());
    RegExp _regExpNumber = RegExp(_numberPatter.toString());
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        endDrawer: CustomDrawer(auth: _auth),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading:
              (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
          title: widget.parrot.ringNumber != 'brak'
              ? const Text("Edycja")
              : const Text("Dodawanie Papugi"),
        ),
        body: !_isLoading
            ? MainBackground(
                child: DraggableScrollbar.rrect(
                  controller: _rrectController,
                  heightScrollThumb: 100,
                  backgroundColor: Theme.of(context).accentColor,
                  child: ListView.builder(
                    controller: _rrectController,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            widget.pair.id != ''
                                ? customTitleChild(context)
                                : customTitle(context),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  //******************************************************* */
                                  //Sex
                                  widget.parrot.ringNumber != 'brak'
                                      ? widget.parrot.pairRingNumber ==
                                                  "brak" ||
                                              widget.pair.id != ''
                                          ? genderSwitchRow(context, _sex)
                                          : infoText(context, widget.parrot.sex)
                                      : genderSwitchRow(context, _sex),
                                  widget.pair.id == ''
                                      ? Center()
                                      : SizedBox(height: 16.0),
                                  //
                                  //******************************************************* */
                                  //Ring number
                                  infoText(context, "Numer obr??czki"),
                                  const SizedBox(height: 16.0),
                                  ringNumberRow(
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
                                  widget.pair.id == ''
                                      ? const Center()
                                      : const SizedBox(height: 16.0),

                                  //
                                  //  Born Time
                                  //
                                  const SizedBox(height: 16.0),
                                  widget.pair.id != ''
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
                                    hint: 'Wprowad?? barw?? papugi',
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
                                  widget.pair.id == 'brak' ||
                                          widget.pair.id != ''
                                      ? const Center()
                                      : customTextFormField(
                                          context: context,
                                          node: node,
                                          hint: 'Jakie rozszczepienie',
                                          icon: Icons
                                              .star_border_purple500_outlined,
                                          mainValue: 'fission',
                                          maxlines: 1,
                                          maxLength: 50,
                                          initvalue: _fission,
                                        ),
                                  widget.pair.id == 'brak' ||
                                          widget.pair.id != ''
                                      ? const Center()
                                      : const SizedBox(height: 16.0), //
                                  //******************************************************* */
                                  //cage number
                                  widget.pair.id == 'brak' ||
                                          widget.pair.id != ''
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
                                  widget.pair.id == 'brak' ||
                                          widget.pair.id != ''
                                      ? const Center()
                                      : const SizedBox(height: 16.0),
                                  //
                                  //******************************************************* */
                                  //notes
                                  widget.pair.id == 'brak' ||
                                          widget.pair.id != ''
                                      ? const Center()
                                      : customTextFormField(
                                          context: context,
                                          node: node,
                                          hint:
                                              'Notatka / Dodatkowa informacja',
                                          icon: Icons.note,
                                          mainValue: 'notes',
                                          maxlines: 10,
                                          maxLength: 100,
                                          initvalue: _notes,
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            (widget.parrot.ringNumber == 'brak' &&
                                        widget.pair.id == '' ||
                                    widget.addFromChild)
                                ? _addParrotConfimButton(context)
                                : widget.pair.id == ''
                                    ? _editParrotConfirmButton(context)
                                    : _addParrotConfimButtonChild(context),
                            const SizedBox(height: 200),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            : MainBackground(
                child: const Center(
                  child: const CircularProgressIndicator(),
                ),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Anuluj',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
          //create a parrot
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Zapisz zmiany',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
          //edit a parrot
          onPressed: _editParrot,
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Anuluj',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
          //create a parrot
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Dodaj Papug??',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
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

  Widget _addParrotConfimButtonChild(BuildContext context) {
    if (widget.data != '') {
      return Row(
        children: [
          const Expanded(
            child: const SizedBox(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Anuluj',
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
              ),
            ),
            //create a parrot
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Zapisz zmiany',
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
              ),
              onPressed: _editChild),
        ],
      );
    } else {
      return Row(
        children: [
          const Expanded(
            child: const SizedBox(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Utw??rz Potomka',
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
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
  }
  //BUILD METODS
// ******************************************************************************************

  TextFormField customTextFormField({
    required BuildContext context,
    required FocusScopeNode node,
    required String hint,
    required IconData icon,
    required String mainValue,
    required int maxLength,
    required int maxlines,
    required String initvalue,
  }) {
    return TextFormField(
      initialValue: initvalue,
      style: customTextStyle(context),
      cursorColor: Theme.of(context).textSelectionTheme.selectionColor,
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
        if (val!.isEmpty || val.length > maxLength) {
          return 'Uzupe??nij dane';
        } else {
          return null;
        }
      },
      onChanged: (val) {
        if (mounted) {
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
        }
      },
      onEditingComplete: () => node.nextFocus(),
    );
  }

  Row genderSwitchRow(BuildContext context, double initSex) {
    return Row(
      children: [
        infoText(context, "P??e??:"),
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
              if (mounted) {
                setState(() {
                  _sex = val;
                  _sexName = _genderMap[val].toString();
                });
              }
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
            cursorColor: Theme.of(context).textSelectionTheme.selectionColor,
            decoration: _createInputDecoration(
              context,
              'Kraj',
              Icons.ac_unit,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.isEmpty || !_regExpCountry.hasMatch(val)) {
                return 'B????d';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              if (mounted) {
                setState(() {
                  _country = val;
                });
              }
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
            cursorColor: Theme.of(context).textSelectionTheme.selectionColor,
            decoration: _createInputDecoration(
              context,
              'Rok',
              Icons.ac_unit,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.isEmpty || !_regExpYear.hasMatch(val)) {
                return 'B????d';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              if (mounted) {
                setState(() {
                  _year = val;
                });
              }
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
            cursorColor: Theme.of(context).textSelectionTheme.selectionColor,
            decoration: _createInputDecoration(
              context,
              'Symbol',
              Icons.ac_unit,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.isEmpty || val.length > 6) {
                return 'B????d';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              if (mounted) {
                setState(() {
                  _symbol = val;
                });
              }
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
            cursorColor: Theme.of(context).textSelectionTheme.selectionColor,
            decoration: _createInputDecoration(
              context,
              'Numer',
              Icons.ac_unit,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.isEmpty ||
                  !_regExpNumber.hasMatch(val) ||
                  val.length > 5) {
                return 'B????d';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              if (mounted) {
                setState(() {
                  _parrotNumber = val;
                });
              }
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
        color: Theme.of(context).textSelectionTheme.selectionColor,
      ),
    );
  }

///////Adding parrots
  ///
  ///
  Future<void> _createParrots() async {
    if (!_formKey.currentState!.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie uda??o si?? doda?? papugi, nie pe??ne dane");
    } else {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        if (mounted) {
          setState(() {
            _ringNumber = "$_country-$_year-$_symbol-$_parrotNumber";
          });
        }
        if (!result) {
          _globalMethods.showMaterialDialog(
              context, "brak po????czenia z internetem.");
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        } else {
          await sendPicture().then(
            (_) async {
              if (mounted) {
                setState(() {
                  String race = "";
                  widget.pair.id == ''
                      ? race = widget.parrotMap['name']
                      : race = widget.race;
                  _createdParrot = Parrot(
                    race: race,
                    ringNumber: _ringNumber,
                    cageNumber: _cageNumber,
                    color: _parrotColor,
                    fission: _fission,
                    notes: _notes,
                    sex: _sexName,
                    picUrl: _pictureUrl,
                    pairRingNumber: '',
                  );
                });
              }
              await _parrotDataHelper.createParrotCollection(
                uid: _firebaseUser!.uid,
                parrot: _createdParrot,
                context: context,
              );
            },
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
  }

  //
  //
  //
  //Sending picture to Storage

  Future sendPicture() async {
    if (_image!.path == widget.parrotMap['url']) {
      return;
    } else {
      if (mounted) {
        setState(() {
          _pictureUrl = Path.basename(_image!.path);
        });
      }
      Reference ref = FirebaseStorage.instance.ref().child(_pictureUrl);
      UploadTask uploadTask = ref.putFile(File(_image!.path));
      await uploadTask;
    }
  }

///////Adding child
  ///
  ///
  Future<void> _createChild() async {
    if (!_formKey.currentState!.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie uda??o si?? doda?? papugi, nie pe??ne dane");
    } else {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        if (mounted) {
          setState(() {
            _ringNumber = "$_country-$_year-$_symbol-$_parrotNumber";
          });
        }

        if (!result) {
          _globalMethods.showMaterialDialog(
              context, "brak po????czenia z internetem.");
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        } else {
          if (mounted) {
            setState(() {
              _createdChild = Children(
                broodDate: bornTime,
                color: _parrotColor,
                gender: _sexName,
                ringNumber: _ringNumber,
              );
            });
          }

          await _parrotPairDataHelper.createChild(
            uid: _firebaseUser!.uid,
            race: widget.race,
            child: _createdChild,
            pairId: widget.pair.id,
            context: context,
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
  }

  Future _editChild() async {
    if (!_formKey.currentState!.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie zmieni?? danych, nie pe??ne dane");
    } else {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        if (mounted) {
          setState(
            () {
              _ringNumber = "$_country-$_year-$_symbol-$_parrotNumber";
            },
          );
        }
        if (!result) {
          _globalMethods.showMaterialDialog(
              context, "brak po????czenia z internetem.");
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        } else {
          if (mounted) {
            setState(() {
              _createdChild = Children(
                broodDate: bornTime,
                color: _parrotColor,
                gender: _sexName,
                ringNumber: _ringNumber,
              );
            });
          }
          await _parrotPairDataHelper.editChild(
            uid: _firebaseUser!.uid,
            race: widget.race,
            pairId: widget.pair.id,
            child: _createdChild,
            context: context,
            ringToDel: ringToDelChildren,
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
  }

///////Editing parrots
  ///
  ///
  Future<void> _editParrot() async {
    if (!_formKey.currentState!.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie uda??o si?? edytowa?? papugi, nie pe??ne dane");
    } else {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        if (!result) {
          _globalMethods.showMaterialDialog(
              context, "brak po????czenia z internetem.");
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        } else {
          await sendPicture().then((_) async {
            setState(
              () {
                _ringNumber = "$_country-$_year-$_symbol-$_parrotNumber";
                _createdParrot = Parrot(
                    race: widget.parrot.race,
                    ringNumber: _ringNumber,
                    cageNumber: _cageNumber,
                    color: _parrotColor,
                    fission: _fission,
                    picUrl: _pictureUrl,
                    notes: _notes,
                    sex: _sexName,
                    pairRingNumber: widget.parrot.pairRingNumber);
                if (widget.parrot.ringNumber != _ringNumber) {
                  _parrotToDelete = Parrot(
                      race: widget.parrot.race,
                      ringNumber: widget.parrot.ringNumber,
                      cageNumber: _cageNumber,
                      color: _parrotColor,
                      fission: _fission,
                      notes: _notes,
                      picUrl: _pictureUrl,
                      sex: _sexName,
                      pairRingNumber: widget.parrot.pairRingNumber);
                }
              },
            );
            await _parrotDataHelper
                .updateParrot(
              uid: _firebaseUser!.uid,
              parrot: _createdParrot,
              pairRingNumber: _createdParrot.pairRingNumber,
              context: context,
            )
                .then((_) async {
              if (widget.parrot.ringNumber != _ringNumber) {
                await _parrotDataHelper.deleteOnlyParrot(
                  context: context,
                  parrotToDelete: _parrotToDelete,
                  showDialog: false,
                  uid: _firebaseUser!.uid,
                );
              }
            }).then((value) async {
              if (_createdParrot.pairRingNumber != 'brak' &&
                  widget.parrot.ringNumber != _ringNumber) {
                await _parrotDataHelper.updatePairedParrot(
                  uid: _firebaseUser!.uid,
                  parrot: _createdParrot,
                  oldRing: widget.parrot.ringNumber,
                );
              }
            });
          });

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
  }

//Styl tekstu w inputach
  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionTheme.selectionColor,
      fontSize: 16,
    );
  }

  Widget customTitleChild(BuildContext context) {
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(
            widget.parrotMap['name'],
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget customTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).backgroundColor,
                child: widget.parrot.ringNumber != 'brak' &&
                        takenURL != 'loading' &&
                        _image!.path == widget.parrotMap['url']
                    ? CircleAvatar(
                        radius: 46,
                        backgroundImage: NetworkImage(takenURL),
                      )
                    : _image!.path == widget.parrotMap['url']
                        ? CircleAvatar(
                            radius: 46,
                            backgroundImage: AssetImage(_image!.path),
                          )
                        : CircleAvatar(
                            radius: 46,
                            backgroundImage: FileImage(
                              File(_image!.path),
                            ),
                          ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  widget.parrotMap['name'],
                  style: TextStyle(
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Positioned(
            left: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: _isClicked
                      ? Colors.orange
                      : Theme.of(context).backgroundColor,
                  radius: 25,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                    ),
                    onPressed: () {
                      _animation();
                      if (mounted) {
                        setState(() {
                          _isPhotoChoosen = !_isPhotoChoosen;
                        });
                      }
                    },
                  ),
                ),
                _isPhotoChoosen
                    ? Row(
                        children: [
                          //add photo from galery
                          CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            radius: 25,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.folder,
                                size: 35,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor,
                              ),
                              onPressed: () {
                                getImageFromGalery();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          //add photo from camera
                          CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            radius: 25,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.camera,
                                size: 35,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor,
                              ),
                              onPressed: () {
                                getImageFromCamera();
                              },
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            child: Center(),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            child: Center(),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _animation() {
    if (mounted) {
      setState(() {
        _isClicked = !_isClicked;
      });
    }
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      if (mounted) {
        setState(() {
          _isClicked = !_isClicked;
        });
      }
    });
  }

  InputDecoration _createInputDecoration(
      BuildContext context, String text, IconData icon) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
          horizontal: icon == Icons.ac_unit ? 3 : 14, vertical: 10),
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      labelText: text,
      icon: icon == Icons.ac_unit
          ? null
          : Icon(
              icon,
              color: Theme.of(context).textSelectionTheme.selectionColor,
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
          color: Theme.of(context).canvasColor,
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
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }

  Column buildRowCalendar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          onPressed: () {
            showDatePicker(
              context: context,
              locale: const Locale("pl", "PL"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
              cancelText: "Anuluj",
            ).then((date) {
              if (mounted) {
                setState(() {
                  bornTime = DateFormat("yyyy-MM-dd", 'pl_PL')
                      .format(date!)
                      .toString();
                });
              }
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
                color: Theme.of(context).textSelectionTheme.selectionColor,
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
        color: Theme.of(context).textSelectionTheme.selectionColor,
      ),
    );
  }
}
