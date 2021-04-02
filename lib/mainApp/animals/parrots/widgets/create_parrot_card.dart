import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:breeders_app/mainApp/animals/parrots/screens/addParrot_screen.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:provider/provider.dart';

class ParrotCard extends StatefulWidget {
  const ParrotCard({
    Key key,
    @required List<Parrot> createdParrotList,
  })  : _createdParrotList = createdParrotList,
        super(key: key);

  final List<Parrot> _createdParrotList;

  @override
  _ParrotCardState createState() => _ParrotCardState();
}

class _ParrotCardState extends State<ParrotCard> {
  GlobalMethods _globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget._createdParrotList.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.30,
          closeOnScroll: true,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(child: createParrotCard(context, index)),
                _globalMethods.arrowConteiner,
              ],
            ),
          ),
          secondaryActions: [
            GestureDetector(
              onTap: () {
                _globalMethods.showDeletingDialog(
                  context,
                  widget._createdParrotList[index].ringNumber,
                  "Napewno usunąć tę papugę z hodowli?",
                  _deleteParrot,
                  widget._createdParrotList[index],
                );
              },
              child: _globalMethods.createActionItem(context, Colors.red,
                  MaterialCommunityIcons.delete, "Usuń Papugę", 13),
            ),
          ],
        );
      },
    );
  }

  Card createParrotCard(BuildContext context, int index) {
    return Card(
      color: Colors.transparent,
      shadowColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleRow(context, "Obrączka:", index, true),
              _contentText(
                  index, context, widget._createdParrotList[index].ringNumber),
              SizedBox(height: 10),
              widget._createdParrotList[index].pairRingNumber != "brak"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleRow(context, "Para:", index, false),
                        _contentText(index, context,
                            widget._createdParrotList[index].pairRingNumber),
                      ],
                    )
                  : _titleRow(context, "Brak pary", index, false),
            ],
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 3.0),
                _titleRow(context, "Kolor:", index, false),
                _contentText(
                    index, context, widget._createdParrotList[index].color),
                Divider(thickness: 3.0),
                _titleRow(context, "Rozczepienie:", index, false),
                _contentText(
                    index, context, widget._createdParrotList[index].fission),
                Divider(thickness: 3.0),
                _titleRow(context, "Numer klatki:", index, false),
                _contentText(index, context,
                    widget._createdParrotList[index].cageNumber),
                Divider(thickness: 3.0),
                _titleRow(context, "Notatki:", index, false),
                _contentText(
                    index, context, widget._createdParrotList[index].notes),
                Divider(thickness: 3.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddParrotScreen(
                              parrotMap: {
                                "url": "assets/image/parrot.jpg",
                                "name": "Edytuj Papugę",
                                "icubationTime": "21"
                              },
                              parrot: widget._createdParrotList[index],
                            ),
                          ),
                        );
                      },
                      child: _globalMethods.createActionItem(
                          context,
                          Colors.indigo,
                          MaterialCommunityIcons.circle_edit_outline,
                          "Edycja Papugi",
                          4),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentText(int index, BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, left: 15),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _titleRow(BuildContext context, String text, int index, bool isFirst) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).backgroundColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        isFirst ? _genderIcon(context, index) : Center(),
      ],
    );
  }

  Container _genderIcon(BuildContext context, int index) {
    Color colorBackground = Colors.greenAccent;
    Color colorIcon = Colors.green[700];
    IconData icon = MaterialCommunityIcons.help;

    if (widget._createdParrotList[index].sex == "Samiec") {
      colorBackground = Colors.blue[300];
      colorIcon = Colors.blue[700];
      icon = MaterialCommunityIcons.gender_male;
    } else if (widget._createdParrotList[index].sex == "Samica") {
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

  Future<void> _deleteParrot(String ring, Parrot parrot) async {
    final dataProvider = Provider.of<ParrotDataHelper>(context, listen: false);
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await DataConnectionChecker().hasConnection;

    if (!result) {
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
    } else {
      try {
        Navigator.of(context).pop();
        await dataProvider.deleteParrot(_firebaseUser.uid, parrot).then(
          (_) {
            _globalMethods.showMaterialDialog(context,
                "Usunięto papugę o numerze obrączki ${parrot.ringNumber}");
          },
        );
      } catch (e) {
        Navigator.of(context).pop();
        _globalMethods.showMaterialDialog(context,
            "Operacja nie udana, nieznany błąd lub brak połączenia z internetem.");
      }
    }
  }
}
