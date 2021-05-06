import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrotsRace_list.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EggExpansionTile extends StatefulWidget {
  final String showEggDate;
  final String raceName;
  final String pairID;

  const EggExpansionTile(this.showEggDate, this.raceName, this.pairID);

  @override
  _EggExpansionTileState createState() => _EggExpansionTileState();
}

class _EggExpansionTileState extends State<EggExpansionTile> {
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  ParrotsRace _parrotsRace = new ParrotsRace();

  int daysToBorn = 0;
  int incubationDuration = 0;
  String bornTimeString = "";

  @override
  void initState() {
    super.initState();
    _parrotsRace.parrotsRaceList.forEach((element) {
      if (element['name'] == widget.raceName) {
        incubationDuration = element['icubationTime'];
      }
    });
    _countData();
  }

  void _countData() {
    setState(() {
      if (widget.showEggDate != "brak") {
        //subtraction data
        DateTime today = DateTime.now();
        DateTime incubationTime = DateTime.parse(widget.showEggDate);
        DateTime bornTime =
            incubationTime.add(Duration(days: incubationDuration));
        daysToBorn = bornTime.difference(today).inDays;
        bornTimeString = DateFormat("yyyy-MM-dd").format(bornTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        children: [
          Row(
            children: [
              Text(
                widget.showEggDate == "brak"
                    ? "Brak jajek"
                    : "Pozostało dni do wylęgu:",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              widget.showEggDate != "brak"
                  ? Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: daysToBorn <= 6 && daysToBorn > 3
                            ? Colors.orange
                            : daysToBorn <= 3
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                        border: Border.all(
                          color: Theme.of(context).textSelectionColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        daysToBorn < 0 ? "-" : daysToBorn.toString(),
                        style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Center(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          widget.showEggDate != "brak"
              ? Row(
                  children: [
                    Text(
                      "start inkubacji: ",
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.showEggDate,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : Center(),
          widget.showEggDate != "brak"
              ? Row(
                  children: [
                    Text(
                      "data wylęgu: ",
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Text(
                      bornTimeString,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : Center(),
        ],
      ),
      children: [
        Column(
          children: [
            _createInkubationStartButton(context),
            SizedBox(height: 10),
            _createInkubationCancelButton(context),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Container _createInkubationCancelButton(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black45,
      ),
      child: FlatButton.icon(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).textSelectionColor,
        ),
        onPressed: () {
          _setEggsDate("brak");
        },
        label: Text(
          "Anuluj Inkubację",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Container _createInkubationStartButton(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black45,
      ),
      child: FlatButton.icon(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).textSelectionColor,
        ),
        onPressed: () {
          _countData();
          showDatePicker(
            context: context,
            locale: const Locale("pl", "PL"),
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            cancelText: "Anuluj",
          ).then((date) {
            _setEggsDate(
                DateFormat("yyyy-MM-dd", 'pl_PL').format(date).toString());
          });
        },
        label: Text(
          "Start inkubacji",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _setEggsDate(String date) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await DataConnectionChecker().hasConnection;

    if (!result) {
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
    } else {
      try {
        await _parrotPairDataHelper
            .setEggIncubationTime(
          _firebaseUser.uid,
          widget.raceName,
          widget.pairID,
          date,
        )
            .then(
          (_) {
            _countData();
            date != "brak"
                ? _globalMethods.showMaterialDialog(
                    context, "Ustawiono datę rozpoczęcia inkubacji")
                : _globalMethods.showMaterialDialog(
                    context, "Anulowanie odliczania czasu inkubacji");
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
