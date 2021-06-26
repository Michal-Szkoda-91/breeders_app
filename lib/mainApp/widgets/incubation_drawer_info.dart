import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../animals/parrots/models/pairing_model.dart';
import '../animals/parrots/screens/incubationInfo_screen.dart';
import 'IncubationCountsContainer.dart';

class IncubationInformation extends StatefulWidget {
  @override
  _IncubationInformationState createState() => _IncubationInformationState();
}

class _IncubationInformationState extends State<IncubationInformation> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  int _incubationTimes = 0;
  bool _isLoading = true;
  List<ParrotPairing> _pairList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection(firebaseUser!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text(
            'Nie można wyświetlić informacji o inkubacji. Błąd danych.',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: const CircularProgressIndicator(),
            );
          default:
            if (_isLoading) {
              _loadInkubationData(snapshot);
            }
            return _incubationTimes == 0
                ? Text(
                    "Brak Par oczekujących na wylęg",
                    style: TextStyle(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Material(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.black45,
                      child: InkWell(
                        splashColor: Theme.of(context).primaryColor,
                        onTap: () {
                          Navigator.of(context).pop();
                          _pairList.sort((a, b) => a.race.compareTo(b.race));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IncubationInformationScreen(
                                pairList: _pairList,
                              ),
                            ),
                          );
                        },
                        child: IncubationCountsContainer(
                          incubationTimes: _incubationTimes,
                        ),
                      ),
                    ),
                  );
        }
      },
    );
  }

  void _loadInkubationData(AsyncSnapshot<QuerySnapshot> snapshot) {
    _incubationTimes = 0;
    snapshot.data!.docs.forEach((val) {
      FirebaseFirestore.instance
          .collection(firebaseUser!.uid)
          .doc(val.id)
          .collection("Pairs")
          .get()
          .then((snap) {
        for (DocumentSnapshot doc in snap.docs) {
          if (doc['Show Eggs Date'] != "brak" && doc['Is Archive'] != "true") {
            _pairList.add(
              ParrotPairing(
                id: doc.id,
                femaleRingNumber: doc['Female Ring'],
                maleRingNumber: doc['Male Ring'],
                isArchive: doc['Is Archive'],
                pairColor: doc['Pair Color'],
                pairingData: doc['Pairing Data'],
                picUrl: doc['Pic Url'],
                race: doc['Race'],
                showEggsDate: doc['Show Eggs Date'],
              ),
            );
            if (mounted) {
              setState(() {
                _incubationTimes++;
              });
            }
          }
        }
      }).then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }
}
