import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../../advertisement_banner/banner_page.dart';
import '../../../../globalWidgets/mainBackground.dart';
import '../models/pairing_model.dart';
import '../models/parrot_model.dart';
import '../widgets/pairingParrot_AddDropdownButton.dart';
import '../widgets/parrot_pair_card.dart';
import '../../../widgets/custom_drawer.dart';

class PairListScreen extends StatefulWidget {
  static const String routeName = "/ParringListScreen";

  final raceName;
  final List<Parrot> parrotList;

  const PairListScreen({this.raceName, this.parrotList});

  @override
  _PairListScreenState createState() => _PairListScreenState();
}

class _PairListScreenState extends State<PairListScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  List<ParrotPairing> _pairList = [];

  bool _showArchive;

  @override
  void initState() {
    super.initState();
    _showArchive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 30,
          child: AutoSizeText(
            'Pary: ${widget.raceName}',
            maxLines: 1,
          ),
        ),
      ),
      body: MainBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(firebaseUser.uid)
              .doc(widget.raceName)
              .collection("Pairs")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Błąd danych');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: const CircularProgressIndicator(),
                  ),
                );
              default:
                _createPairList(snapshot);
                return Column(
                  children: [
                    BannerPage(),
                    const SizedBox(height: 8),
                    !_showArchive
                        ? CreatePairingParrotDropdownButton(
                            raceName: widget.raceName,
                          )
                        : const SizedBox(height: 1),
                    _changeView(context),
                    Expanded(
                      child: ParrotPairCard(
                        pairList: _pairList,
                        race: widget.raceName,
                        parrotList: widget.parrotList,
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

  Widget _changeView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showArchive = !_showArchive;
          });
        },
        child: Container(
          width: double.infinity,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _showArchive
                ? Theme.of(context).hintColor
                : Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                !_showArchive ? "Wyświetl archiwum" : "Pokaż aktywne pary",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                !_showArchive
                    ? MaterialCommunityIcons.archive
                    : MaterialCommunityIcons.star,
                color: Theme.of(context).textSelectionColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPairList(AsyncSnapshot<QuerySnapshot> snapshot) {
    _pairList = [];
    snapshot.data.docs.forEach((val) {
      if (!_showArchive) {
        if (val.data()['Is Archive'] == "false") {
          _pairList.add(ParrotPairing(
            id: val.id,
            pairingData: val.data()['Pairing Data'],
            femaleRingNumber: val.data()['Female Ring'],
            maleRingNumber: val.data()['Male Ring'],
            pairColor: val.data()['Pair Color'],
            isArchive: val.data()['Is Archive'],
            showEggsDate: val.data()['Show Eggs Date'],
            picUrl: val.data()['Pic Url'],
          ));
        }
      } else {
        if (val.data()['Is Archive'] == "true") {
          _pairList.add(ParrotPairing(
            id: val.id,
            pairingData: val.data()['Pairing Data'],
            femaleRingNumber: val.data()['Female Ring'],
            maleRingNumber: val.data()['Male Ring'],
            pairColor: val.data()['Pair Color'],
            isArchive: val.data()['Is Archive'],
            showEggsDate: val.data()['Show Eggs Date'],
            picUrl: val.data()['Pic Url'],
          ));
        }
      }
    });
    _pairList.sort((a, b) => a.pairingData.compareTo(b.pairingData));
  }
}
