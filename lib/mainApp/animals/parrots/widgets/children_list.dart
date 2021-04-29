import 'package:breeders_app/mainApp/animals/parrots/models/children_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ChildrenList extends StatefulWidget {
  final String raceName;
  final String pairId;

  const ChildrenList({this.raceName, this.pairId});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<Children> _childrenList = [];
  int _childrenCount = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(firebaseUser.uid)
          .doc(widget.raceName)
          .collection("Pairs")
          .doc(widget.pairId)
          .collection("Child")
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
            _createChildList(snapshot);
            return _childrenCount == 0
                ? _createdNoChildRow(context)
                : ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "Ilość potomków:",
                          style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                              color: Theme.of(context).textSelectionColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            _childrenCount.toString(),
                            style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _childrenCount,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _childrenList[index].ringNumber,
                              style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Kolor:           ",
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${_childrenList[index].color}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Data ur.:       ",
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${_childrenList[index].broodDate}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: _genderIcon(context, index),
                          );
                        },
                      ),
                    ],
                  );
        }
      },
    );
  }

  Container _genderIcon(BuildContext context, int index) {
    Color colorBackground = Colors.greenAccent;
    Color colorIcon = Colors.green[700];
    IconData icon = MaterialCommunityIcons.help;

    if (_childrenList[index].gender == "Samiec") {
      colorBackground = Colors.blue[300];
      colorIcon = Colors.blue[700];
      icon = MaterialCommunityIcons.gender_male;
    } else if (_childrenList[index].gender == "Samica") {
      colorBackground = Colors.pink[300];
      colorIcon = Colors.pink[700];
      icon = MaterialCommunityIcons.gender_female;
    }

    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorBackground,
        border: Border.all(
          color: Theme.of(context).textSelectionColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(35),
        ),
      ),
      child: Icon(icon, color: colorIcon),
    );
  }

  Row _createdNoChildRow(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Text(
          "Brak potomstwa",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 16,
          ),
        ),
        Spacer(),
      ],
    );
  }

  void _createChildList(AsyncSnapshot<QuerySnapshot> snapshot) {
    snapshot.data.docs.forEach((val) {
      _childrenList.add(
        new Children(
          ringNumber: val.id,
          broodDate: val.data()['Born Date'],
          color: val.data()['Colors'],
          gender: val.data()['Sex'],
        ),
      );
      _childrenCount++;
    });
  }
}
