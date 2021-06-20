import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../widgets/custom_drawer.dart';
import '../models/pairing_model.dart';
import '../../../../models/global_methods.dart';
import '../../../../services/auth.dart';
import '../../../../globalWidgets/mainBackground.dart';
import '../models/parrot_model.dart';

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
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  ScrollController _rrectController = ScrollController();
  bool _isPhotoChoosen = false;
  File _image = new File('assets/image/parrotsRace/parrot_pair.jpg');
  bool _isBlinking = false;

  List<Parrot> _allParrotList = [];
  List<Parrot> _maleParrotList = [];
  List<Parrot> _femaleParrotList = [];
  String _choosenMaleParrotRingNumber;
  String _choosenFeMaleParrotRingNumber;
  Parrot _femaleParrotChoosen;
  Parrot _maleParrotChoosen;
  String _pairColor = "";
  String _pictureUrl = "brak";
  String _pairTime =
      DateFormat("yyyy-MM-dd", 'pl_PL').format(DateTime.now()).toString();
  bool _isLoading = false;

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

  Future getImageFromGalery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 750, maxHeight: 1000);

    if (image == null) {
      return;
    } else {
      setState(() {
        _image = image;
        _isPhotoChoosen = false;
      });
    }
  }

  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 750, maxHeight: 1000);
    if (image == null) {
      return;
    } else {
      setState(() {
        _image = image;
        _isPhotoChoosen = false;
      });
    }
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
      body: !_isLoading
          ? MainBackground(
              child: DraggableScrollbar.rrect(
                controller: _rrectController,
                heightScrollThumb: 100,
                backgroundColor: Theme.of(context).accentColor,
                child: SingleChildScrollView(
                  controller: _rrectController,
                  child: Column(
                    children: [
                      _createTitle(context),
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
                            onPressed: () {
                              _sendPictureToStorage(context);
                            },
                            child: _createInfoText(
                              context,
                              'Utwórz parę',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                ),
              ),
            )
          : MainBackground(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget _createTitle(BuildContext context) {
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
                child: CircleAvatar(
                  radius: 46,
                  backgroundImage:
                      _image.path == 'assets/image/parrotsRace/parrot_pair.jpg'
                          ? AssetImage(_image.path)
                          : FileImage(
                              _image,
                            ),
                ),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: AutoSizeText(
                  widget.raceName,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).textSelectionColor,
                    fontWeight: FontWeight.bold,
                  ),
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
                  backgroundColor: _isBlinking
                      ? Colors.orange
                      : Theme.of(context).backgroundColor,
                  radius: _isBlinking ? 30 : 25,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color: Theme.of(context).textSelectionColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPhotoChoosen = true;
                      });
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
                                color: Theme.of(context).textSelectionColor,
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
                                color: Theme.of(context).textSelectionColor,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            const SizedBox(height: 15),
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
          initialValue: _pairColor,
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
              _pairColor = val;
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _customTextIcon(
              context,
              text,
              icon,
              color,
            ),
            const SizedBox(height: 20),
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
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textSelectionColor,
      ),
    );
  }

  DropdownButton _createDropdownButtonMale(BuildContext context) {
    return DropdownButton(
      itemHeight: 90,
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              parrot.ringNumber,
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            SizedBox(height: 2),
            AutoSizeText(
              "Kolor: " + parrot.color,
              maxLines: 2,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            Divider(
              color: Theme.of(context).textSelectionColor,
              height: 7,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton _createDropdownButtonFeMale(BuildContext context) {
    return DropdownButton(
      itemHeight: 90,
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
        const SizedBox(width: 10),
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
                _pairTime =
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
              _pairTime,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).textSelectionColor),
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

//
//
//
//
//############################
//
//
//
//Firebase methods
  Future sendPicture(BuildContext context) async {
    if (_image.path == 'assets/image/parrotsRace/parrot_pair.jpg') {
      return;
    } else {
      setState(() {
        _pictureUrl = basename(_image.path);
      });
      Reference ref = FirebaseStorage.instance.ref().child(_pictureUrl);
      UploadTask uploadTask = ref.putFile(_image);
      await uploadTask;
    }
  }

  Future<void> _sendPictureToStorage(BuildContext context) async {
    if (_choosenFeMaleParrotRingNumber == null ||
        _choosenFeMaleParrotRingNumber == null ||
        !_formKey.currentState.validate()) {
      _globalMethods.showMaterialDialog(
          context, "Nie można utworzyć pary, niepełne dane");
      return;
    } else {
      await _globalMethods
          .checkInternetConnection(context)
          .then((result) async {
        if (!result) {
          _globalMethods.showMaterialDialog(
              context, "brak połączenia z internetem.");
          return;
        } else {
          if (_image.path == 'assets/image/parrotsRace/parrot_pair.jpg') {
            _showPicQuestionDialog(context);
          } else {
            setState(() {
              _isLoading = true;
            });
            await sendPicture(context).then((_) {
              _createPair(context);
            }).catchError((error) {
              _globalMethods.showMaterialDialog(context,
                  "Nie udało się wczytać zdjęcia, Spróbuj ponownie póżniej");
            });
          }
        }
      });
    }
  }

  Future _showPicQuestionDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => new AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Uwaga!",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        content: Text(
          "Nie wybrano zdjęcia par. Czy mimo to chcesz kontynuwać?",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    child: AutoSizeText(
                      "Kontynuuj",
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      Navigator.of(ctx).pop();
                      await sendPicture(context).then((_) async {
                        await _createPair(context);
                      });
                    }),
                FlatButton(
                  child: AutoSizeText(
                    "Uzupełnij \nzdjęcie",
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.of(ctx).pop();
                    _rrectController
                        .animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                    )
                        .then((_) {
                      _blinkingCamera();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createPair(BuildContext context) async {
    setState(() {
      _createdPair = ParrotPairing(
        id: "$_choosenFeMaleParrotRingNumber - $_choosenMaleParrotRingNumber - ${DateTime.now()}",
        femaleRingNumber: _choosenFeMaleParrotRingNumber,
        maleRingNumber: _choosenMaleParrotRingNumber,
        pairingData: _pairTime,
        pairColor: _pairColor,
        picUrl: _pictureUrl,
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
    });
    Navigator.of(context).pop();
    await _parrotPairDataHelper
        .createPairCollection(
      uid: firebaseUser.uid,
      pair: _createdPair,
      race: widget.raceName,
      maleParrot: _maleParrotChoosen,
      femaleParrot: _femaleParrotChoosen,
      context: context,
    )
        .then((_) {
      _choosenFeMaleParrotRingNumber = null;
      _choosenMaleParrotRingNumber = null;
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _blinkingCamera() async {
    setState(() {
      _isBlinking = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isBlinking = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isBlinking = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isBlinking = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isBlinking = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isBlinking = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      _isBlinking = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isBlinking = false;
    });
  }
}
