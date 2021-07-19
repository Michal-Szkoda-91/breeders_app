import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:path/path.dart' as Path;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  PickedFile? _image =
      new PickedFile('assets/image/parrotsRace/parrot_pair.jpg');
  bool _isBlinking = false;
  bool _isDataReady = false;
  bool _isClicked = false;

  List<Parrot> _allParrotList = [];
  List<Parrot> _maleParrotList = [];
  List<Parrot> _femaleParrotList = [];
  String _choosenMaleParrotRingNumber = '';
  String _choosenFeMaleParrotRingNumber = '';
  late Parrot _femaleParrotChoosen;
  late Parrot _maleParrotChoosen;
  String _pairColor = "";
  String _pictureUrl = "brak";
  String _pairTime =
      DateFormat("yyyy-MM-dd", 'pl_PL').format(DateTime.now()).toString();
  bool _isLoading = false;
  final _picker = ImagePicker();

  void _createListsOfParrot(List<Parrot> allParrotsList) {
    _maleParrotList.clear();
    _femaleParrotList.clear();
    allParrotsList.forEach((parrot) {
      if (parrot.sex == "Samiec" &&
          parrot.race == widget.raceName &&
          parrot.pairRingNumber == "brak") {
        _maleParrotList.add(parrot);
        if (_choosenMaleParrotRingNumber == '')
          _choosenMaleParrotRingNumber = _maleParrotList[0].ringNumber;
      } else if (parrot.sex == "Samica" &&
          parrot.race == widget.raceName &&
          parrot.pairRingNumber == "brak") {
        _femaleParrotList.add(parrot);
        if (_choosenFeMaleParrotRingNumber == '')
          _choosenFeMaleParrotRingNumber = _femaleParrotList[0].ringNumber;
      }
    });
  }

  late ParrotPairing _createdPair;

  Future<void> getParrotsFromStream() async {
    FirebaseFirestore.instance
        .collection(firebaseUser!.uid)
        .doc(widget.raceName)
        .collection("Birds")
        .get()
        .then((snapshot) {
      _allParrotList = [];
      snapshot.docs.forEach((val) {
        _allParrotList.add(Parrot(
          ringNumber: val.id,
          cageNumber: val['Cage number'],
          color: val['Colors'],
          fission: val['Fission'],
          notes: val['Notes'],
          pairRingNumber: val['PairRingNumber'],
          race: widget.raceName,
          sex: val['Sex'],
        ));
      });
    }).then((value) {
      _createListsOfParrot(_allParrotList);
      setState(() {
        _isDataReady = true;
      });
    });
  }

  Future getImageFromGalery() async {
    PickedFile? image = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 750,
      maxHeight: 1000,
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
      maxWidth: 750,
      maxHeight: 1000,
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
    getParrotsFromStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    // getParrotsFromStream();
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading:
            (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
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
                child: ListView.builder(
                  controller: _rrectController,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _createTitle(context),
                        !_isDataReady
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : _createContent(context),
                        const SizedBox(height: 15),
                        _createForm(context, node),
                        const SizedBox(height: 15),
                        buildRowCalendar(context),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: _createInfoText(
                                context,
                                'Anuluj',
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                              ),
                              onPressed: () {
                                _sendPictureToStorage();
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
                    );
                  },
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
                child:
                    _image!.path == 'assets/image/parrotsRace/parrot_pair.jpg'
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
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: AutoSizeText(
                  widget.raceName,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).textSelectionTheme.selectionColor,
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
                  backgroundColor: _isBlinking || _isClicked
                      ? Colors.orange
                      : Theme.of(context).backgroundColor,
                  radius: _isBlinking ? 30 : 25,
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
                icon: Icons.female,
                gender: _createDropdownButtonFeMale,
                list: _femaleParrotList),
            const SizedBox(height: 15),
            createCard(
              context: context,
              text: "Samiec (1,0)",
              alterText: "Brak Samców z wybranego gatunku",
              color: Colors.blue,
              icon: Icons.male,
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
          cursorColor: Theme.of(context).textSelectionTheme.selectionColor,
          maxLength: 60,
          maxLines: 1,
          decoration: _createInputDecoration(
            context,
            'Kolor Pary',
            Icons.ac_unit,
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Uzupełnij dane';
            } else if (val.length > 60) {
              return 'Zbyt długi tekst';
            } else {
              return null;
            }
          },
          onChanged: (val) {
            if (mounted) {
              setState(() {
                _pairColor = val;
              });
            }
          },
          onEditingComplete: () => node.nextFocus(),
        ),
      ),
    );
  }

  //Styl tekstu w inputach
  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionTheme.selectionColor,
      fontSize: 16,
    );
  }

  Card createCard(
      {required BuildContext context,
      required String text,
      required String alterText,
      required Color color,
      required IconData icon,
      required Function gender,
      required List list}) {
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
        color: Theme.of(context).textSelectionTheme.selectionColor,
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
        color: Theme.of(context).textSelectionTheme.selectionColor,
      ),
      iconSize: 24,
      elevation: 40,
      dropdownColor: Theme.of(context).backgroundColor,
      underline: Container(height: 0),
      onChanged: (val) {
        if (mounted) {
          setState(() {
            _choosenMaleParrotRingNumber = val;
          });
        }
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
                color: Theme.of(context).textSelectionTheme.selectionColor,
              ),
            ),
            SizedBox(height: 2),
            AutoSizeText(
              "Kolor: " + parrot.color,
              maxLines: 2,
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
              ),
            ),
            Divider(
              color: Theme.of(context).textSelectionTheme.selectionColor,
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
        color: Theme.of(context).textSelectionTheme.selectionColor,
      ),
      iconSize: 24,
      elevation: 40,
      dropdownColor: Theme.of(context).backgroundColor,
      underline: Container(height: 0),
      onChanged: (val) {
        if (mounted) {
          setState(() {
            _choosenFeMaleParrotRingNumber = val;
          });
        }
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
            color: Theme.of(context).textSelectionTheme.selectionColor,
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
                  _pairTime = DateFormat("yyyy-MM-dd", 'pl_PL')
                      .format(date!)
                      .toString();
                });
              }
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
                  fontSize: 18,
                  color: Theme.of(context).textSelectionTheme.selectionColor),
            ),
          ),
        ),
      ],
    );
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

//
//
//
//
//############################
//
//
//
//Firebase methods
  Future sendPicture() async {
    if (_image!.path == 'assets/image/parrotsRace/parrot_pair.jpg') {
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

  Future<void> _sendPictureToStorage() async {
    if (_choosenFeMaleParrotRingNumber == '' ||
        _choosenMaleParrotRingNumber == '' ||
        !_formKey.currentState!.validate()) {
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
          if (_image!.path == 'assets/image/parrotsRace/parrot_pair.jpg') {
            _showPicQuestionDialog();
          } else {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            await sendPicture().then((_) async {
              await _createPair();
            }).catchError((error) {
              _globalMethods.showMaterialDialog(context,
                  "Nie udało się wczytać zdjęcia, Spróbuj ponownie póżniej");
            });
          }
        }
      });
    }
  }

  Future<void> _showPicQuestionDialog() {
    return showAnimatedDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => new AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Uwaga!",
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
          ),
        ),
        content: Text(
          "Nie wybrano zdjęcia par. Czy mimo to chcesz kontynuwać?",
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
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
                TextButton(
                    child: AutoSizeText(
                      "Kontynuuj",
                      maxLines: 1,
                      style: TextStyle(
                        color:
                            Theme.of(context).textSelectionTheme.selectionColor,
                      ),
                    ),
                    onPressed: () async {
                      if (mounted) {
                        setState(() {
                          _isLoading = true;
                        });
                      }
                      Navigator.of(ctx).pop();
                      await sendPicture().then((_) async {
                        await _createPair();
                      });
                    }),
                TextButton(
                  child: AutoSizeText(
                    "Uzupełnij \nzdjęcie",
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(ctx).textSelectionTheme.selectionColor,
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
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 2),
    );
  }

  Future<void> _createPair() async {
    if (mounted) {
      setState(() {
        _createdPair = ParrotPairing(
          id: "$_choosenFeMaleParrotRingNumber - $_choosenMaleParrotRingNumber - ${DateTime.now()}",
          femaleRingNumber: _choosenFeMaleParrotRingNumber,
          maleRingNumber: _choosenMaleParrotRingNumber,
          pairingData: _pairTime,
          pairColor: _pairColor,
          picUrl: _pictureUrl,
          isArchive: '',
          race: '',
          showEggsDate: '',
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
    }
    await _parrotPairDataHelper
        .createPairCollection(
      uid: firebaseUser!.uid,
      pair: _createdPair,
      race: widget.raceName,
      maleParrot: _maleParrotChoosen,
      femaleParrot: _femaleParrotChoosen,
      context: context,
    )
        .then((_) {
      _choosenFeMaleParrotRingNumber = '';
      _choosenMaleParrotRingNumber = '';
      if (mounted) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  _blinkingCamera() async {
    if (mounted) {
      setState(() {
        _isBlinking = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _isBlinking = false;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _isBlinking = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _isBlinking = false;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _isBlinking = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _isBlinking = false;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      setState(() {
        _isBlinking = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _isBlinking = false;
      });
    }
  }
}
