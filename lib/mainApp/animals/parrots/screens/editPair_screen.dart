import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import 'package:auto_size_text/auto_size_text.dart';
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

class EditPairScreen extends StatefulWidget {
  static const String routeName = "/EditPairScreen";
  final String pairingData;
  final String picUrl;
  final String pairColor;
  final String pairID;
  final String raceName;

  const EditPairScreen(
      {required this.raceName,
      required this.pairingData,
      required this.picUrl,
      required this.pairColor,
      required this.pairID});

  @override
  _EditPairScreenState createState() => _EditPairScreenState();
}

class _EditPairScreenState extends State<EditPairScreen> {
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

  late String _pairColor;
  late String _pictureUrl;
  late String _pairTime;
  bool _isLoading = false;
  late String takenURL;
  bool _isPhotoChanged = false;
  final _picker = ImagePicker();
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
    _pairColor = widget.pairColor;
    _pictureUrl = widget.picUrl;
    _pairTime = widget.pairingData;
  }

  Future _getImage(String basicUrl) async {
    final ref = FirebaseStorage.instance.ref().child(basicUrl);
    takenURL = await ref.getDownloadURL();
  }

  Future getImageFromGalery() async {
    // ignore: deprecated_member_use
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
          _isPhotoChanged = true;
        });
      }
    }
  }

  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
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
          _isPhotoChanged = true;
        });
      }
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
        leading:
            (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        title: AutoSizeText(
          "Edycja Pary",
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
                                _sendPictureToStorage(context);
                              },
                              child: _createInfoText(
                                context,
                                'Zpisz zmiany',
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
                child: FutureBuilder(
                  future: _getImage(widget.picUrl),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      case ConnectionState.done:
                        {
                          if (widget.picUrl != "brak" && !_isPhotoChanged) {
                            return CircleAvatar(
                              radius: 46,
                              backgroundImage: NetworkImage("$takenURL"),
                            );
                          } else if (_image!.path ==
                              'assets/image/parrotsRace/parrot_pair.jpg') {
                            return CircleAvatar(
                              radius: 46,
                              backgroundImage: AssetImage(_image!.path),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 46,
                              backgroundImage: FileImage(
                                File(_image!.path),
                              ),
                            );
                          }
                        }

                      default:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
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
                      if (mounted) {
                        _animation();
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
          maxLength: 30,
          maxLines: 1,
          decoration: _createInputDecoration(
            context,
            'Kolor Pary',
            Icons.ac_unit,
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Uzupełnij dane';
            } else if (val.length > 30) {
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

  Text _createInfoText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textSelectionTheme.selectionColor,
      ),
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

  Future<void> _sendPictureToStorage(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
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
          if (mounted) {
            setState(() {
              _isLoading = true;
            });
          }
          await sendPicture().then((_) {
            _editPair();
          }).catchError((error) {
            _globalMethods.showMaterialDialog(context,
                "Nie udało się wczytać zdjęcia, Spróbuj ponownie póżniej");
          });
        }
      });
    }
  }

  Future<void> _editPair() async {
    await _parrotPairDataHelper
        .editPair(
      uid: firebaseUser!.uid,
      race: widget.raceName,
      id: widget.pairID,
      pairingData: _pairTime,
      picUrl: _pictureUrl,
      color: _pairColor,
      context: context,
    )
        .then((_) async {
      if (widget.picUrl != _pictureUrl) {
        //Delete picture from storage
        try {
          final ref = FirebaseStorage.instance.ref().child(widget.picUrl);
          await ref.delete();
          print("pic deleted");
        } catch (e) {
          print("error occured $e");
        }
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
