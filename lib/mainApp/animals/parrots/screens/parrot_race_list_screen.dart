import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../widgets/tutorial_dialog_parrot_CRUD.dart';
import '../../../../advertisement_banner/banner_page.dart';
import '../widgets/notConnected_information.dart';
import '../widgets/parrots_race_AddDropdownButton.dart';
import '../widgets/create_race_listTile.dart';
import '../../../../services/auth.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../../globalWidgets/mainBackground.dart';

class ParrotsRaceListScreen extends StatefulWidget {
  static const String routeName = "/ParrotsRaceListScreen";

  @override
  _ParrotsRaceListScreenState createState() => _ParrotsRaceListScreenState();
}

class _ParrotsRaceListScreenState extends State<ParrotsRaceListScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<String> _activeRaceList = [];
  bool _showTutorial = true;
  bool _didChangeReady = false;

  //Shared Prefs

  loadShare() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool? firstTime = _prefs.getBool('show_Tutorial');
    if (firstTime != null && firstTime) {
      setState(() {
        _showTutorial = false;
      });
    } else {
      setState(() {
        _showTutorial = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (!_didChangeReady) {
      loadShare();
      setState(() {
        _didChangeReady = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading:
            (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        title: Text("Hodowla Papug"),
      ),
      body: MainBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(firebaseUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return NotConnected();
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              default:
                createListRace(snapshot);
                if (_showTutorial) {
                  Future.delayed(Duration(milliseconds: 200),
                      () => askAboutTutorial(context));
                }
                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CreateParrotsDropdownButton(
                            parrotRingList: [],
                          ),
                          CreateParrotRaceListTile(
                              activeRaceList: _activeRaceList),
                          const SizedBox(height: 8),
                          BannerPage(),
                        ],
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  void createListRace(AsyncSnapshot<QuerySnapshot> snapshot) async {
    _activeRaceList.clear();
    snapshot.data!.docs.forEach((val) {
      _activeRaceList.add(val.id);
    });
    _activeRaceList
        .sort((a, b) => removeDiacritics(a).compareTo(removeDiacritics(b)));
  }

  askAboutTutorial(BuildContext ctx) async {
    await showAnimatedDialog(
      context: context,
      builder: (ctx) => SafeArea(
        child: AlertDialog(
          title: const Text(
            "Czy chcesz zobaczy?? instrukcj?? korzystania z aplikacji?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor,
              ),
              child: AutoSizeText(
                'Pomi??',
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
              ),
              onPressed: () {
                _closeDialog();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).backgroundColor,
              ),
              child: AutoSizeText(
                'Poka??',
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showAlert(context);
              },
            )
          ],
        ),
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 800),
    );
  }

  showAlert(BuildContext ctx) async {
    await showAnimatedDialog(
      context: context,
      builder: (ctx) => SafeArea(
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: TutorialParrotCrud(),
        ),
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 800),
    );
  }

  _closeDialog() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = _prefs;
    bool? firstTime = prefs.getBool('show_Tutorial');
    if (firstTime == null) {
      prefs.setBool('show_Tutorial', true);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ParrotsRaceListScreen()),
          (route) => false);
    } else {
      Navigator.pop(context);
    }
  }
}
