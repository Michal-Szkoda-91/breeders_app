import 'package:breeders_app/mainApp/animals/parrots/screens/incubationInfo_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'IncubationCountsContainer.dart';

class IncubationInformation extends StatefulWidget {
  IncubationInformation({Key key}) : super(key: key);

  @override
  _IncubationInformationState createState() => _IncubationInformationState();
}

class _IncubationInformationState extends State<IncubationInformation> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  int _incubationTimes = 0;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection(firebaseUser.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text(
            'Nie można wyświetlić informacji o inkubacji. Błąd danych.',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (_isLoading) {
              _loadInkubationData(snapshot);
            }
            return _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _incubationTimes == 0
                    ? Text(
                        "Brak Par oczekujących na wylęg",
                        style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IncubationInformationScreen(),
                            ),
                          );
                        },
                        child: IncubationCountsContainer(
                            incubationTimes: _incubationTimes),
                      );
        }
      },
    );
  }

  void _loadInkubationData(AsyncSnapshot<QuerySnapshot> snapshot) {
    _incubationTimes = 0;
    snapshot.data.docs.forEach((val) {
      FirebaseFirestore.instance
          .collection(firebaseUser.uid)
          .doc(val.id)
          .collection("Pairs")
          .get()
          .then((snap) {
        for (DocumentSnapshot doc in snap.docs) {
          if (doc.data()['Show Eggs Date'] == "brak" ||
              doc.data()["Is Archive"] == "true") {
            return;
          } else {
            setState(() {
              _incubationTimes++;
            });
            print("_________________________$_incubationTimes");
          }
        }
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }
}
