import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/pairing_model.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrotsRace_list.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'egg_expansion_tile/incubation_cancel_button.dart';
import 'egg_expansion_tile/inkubation_start_button.dart';

class EggExpansionTile extends StatefulWidget {
  final String showEggDate;
  final String raceName;
  final String pairID;
  final bool isShowingOnly;

  const EggExpansionTile(
      this.showEggDate, this.raceName, this.pairID, this.isShowingOnly);

  @override
  _EggExpansionTileState createState() => _EggExpansionTileState();
}

class _EggExpansionTileState extends State<EggExpansionTile> {
  GlobalMethods _globalMethods = GlobalMethods();
  ParrotPairDataHelper _parrotPairDataHelper = ParrotPairDataHelper();
  ParrotsRace _parrotsRace = new ParrotsRace();

  int _daysToBorn = 0;
  int _incubationDuration = 0;
  String _bornTimeString = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _parrotsRace.parrotsRaceList.forEach((element) {
      if (element['name'] == widget.raceName) {
        _incubationDuration = element['icubationTime'];
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
            incubationTime.add(Duration(days: _incubationDuration));
        _daysToBorn = bornTime.difference(today).inDays;
        _bornTimeString = DateFormat("yyyy-MM-dd").format(bornTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? widget.isShowingOnly
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ContentColumn(
                  showEggDate: widget.showEggDate,
                  daysToBorn: _daysToBorn,
                  bornTimeString: _bornTimeString,
                ),
              )
            : ExpansionTile(
                title: ContentColumn(
                  showEggDate: widget.showEggDate,
                  daysToBorn: _daysToBorn,
                  bornTimeString: _bornTimeString,
                ),
                children: [
                  Column(
                    children: [
                      InkubationStartButton(
                        countData: _countData,
                        setEggsDate: _setEggsDate,
                      ),
                      const SizedBox(height: 10),
                      IncubationCancelButton(
                        setEggsDate: _setEggsDate,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              )
        : const Center(child: const CircularProgressIndicator());
  }

  Future<void> _setEggsDate(String date) async {
    final _firebaseUser = FirebaseAuth.instance.currentUser;
    bool result = await _globalMethods.checkInternetConnection(context);

    if (!result) {
      Navigator.of(context).pop();
      _globalMethods.showMaterialDialog(
          context, "brak połączenia z internetem.");
    } else {
      setState(() {
        _isLoading = true;
      });

      _parrotPairDataHelper
          .setEggIncubationTime(
        _firebaseUser.uid,
        widget.raceName,
        widget.pairID,
        date,
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        _countData();
        date != "brak"
            ? _globalMethods.showMaterialDialog(
                context, "Ustawiono datę rozpoczęcia inkubacji")
            : _globalMethods.showMaterialDialog(
                context, "Anulowanie odliczania czasu inkubacji");
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd, spróbuj ponownie pózniej");
      });
    }
  }
}

class ContentColumn extends StatelessWidget {
  final String showEggDate;
  final int daysToBorn;
  final String bornTimeString;

  const ContentColumn(
      {Key key, this.showEggDate, this.daysToBorn, this.bornTimeString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: AutoSizeText(
                showEggDate == "brak" ? "Brak jajek" : "Dni do wylęgu:",
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
            ),
            const Spacer(),
            showEggDate != "brak"
                ? Container(
                    width: 33,
                    height: 33,
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
                        Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      daysToBorn < 0 ? "-" : daysToBorn.toString(),
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                : const Center(),
          ],
        ),
        const SizedBox(height: 5),
        showEggDate != "brak"
            ? Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: AutoSizeText(
                      "Start inkubacji: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize:
                            MediaQuery.of(context).size.width < 330 ? 10 : 14,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    showEggDate,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize:
                          MediaQuery.of(context).size.width < 330 ? 10 : 14,
                    ),
                  ),
                ],
              )
            : const Center(),
        showEggDate != "brak"
            ? Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: AutoSizeText(
                      "data wylęgu: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize:
                            MediaQuery.of(context).size.width < 330 ? 10 : 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    bornTimeString,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize:
                          MediaQuery.of(context).size.width < 330 ? 10 : 14,
                    ),
                  ),
                ],
              )
            : const Center(),
      ],
    );
  }
}
