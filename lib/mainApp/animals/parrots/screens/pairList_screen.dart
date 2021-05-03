import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/pairingParrot_AddDropdownButton.dart';
import 'package:breeders_app/mainApp/animals/parrots/widgets/parrot_pair_card.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                    child: CircularProgressIndicator(),
                  ),
                );
              default:
                _createPairList(snapshot);
                return Column(
                  children: [
                    CreatePairingParrotDropdownButton(
                      raceName: widget.raceName,
                    ),
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

  void _createPairList(AsyncSnapshot<QuerySnapshot> snapshot) {
    _pairList = [];
    snapshot.data.docs.forEach((val) {
      if (val.data()['Is Archive'] == "false") {
        _pairList.add(ParrotPairing(
          id: val.id,
          pairingData: val.data()['Pairing Data'],
          femaleRingNumber: val.data()['Female Ring'],
          maleRingNumber: val.data()['Male Ring'],
          pairColor: val.data()['Pair Color'],
          isArchive: val.data()['Is Archive'],
        ));
      }
    });
    _pairList.sort((a, b) => a.pairingData.compareTo(b.pairingData));
  }
}
