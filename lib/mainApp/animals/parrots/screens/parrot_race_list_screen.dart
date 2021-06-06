import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Hodowla Papug"),
      ),
      body: MainBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(firebaseUser.uid)
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
                return Column(
                  children: [
                    BannerPage(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        children: [
                          const CreateParrotsDropdownButton(),
                          CreateParrotRaceListTile(
                              activeRaceList: _activeRaceList),
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

  void createListRace(AsyncSnapshot<QuerySnapshot> snapshot) {
    _activeRaceList.clear();

    snapshot.data.docs.forEach((val) {
      _activeRaceList.add(val.id);
    });
    _activeRaceList
        .sort((a, b) => removeDiacritics(a).compareTo(removeDiacritics(b)));
  }
}
