import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/pairing_model.dart';
import '../models/parrotsRace_list.dart';
import '../../../../models/global_methods.dart';
import 'egg_expansion_tile/content_column.dart';
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
    if (mounted) {
      setState(() {
        if (widget.showEggDate != "brak") {
          //subtraction data
          DateTime today = DateTime.now();
          DateTime incubationTime = DateTime.parse(widget.showEggDate);
          DateTime bornTime =
              incubationTime.add(Duration(days: _incubationDuration));
          _daysToBorn = bornTime.difference(today).inDays + 1;
          _bornTimeString = DateFormat("yyyy-MM-dd").format(bornTime);
        }
      });
    }
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
                  incubationLength: _incubationDuration,
                ),
              )
            : ExpansionTile(
                title: ContentColumn(
                  showEggDate: widget.showEggDate,
                  daysToBorn: _daysToBorn,
                  bornTimeString: _bornTimeString,
                  incubationLength: _incubationDuration,
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
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await _globalMethods.checkInternetConnection(context).then((result) async {
      if (!result) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        _globalMethods.showMaterialDialog(
            context, "brak połączenia z internetem.");
      } else {
        await _parrotPairDataHelper.setEggIncubationTime(
            _firebaseUser!.uid, widget.raceName, widget.pairID, date, context);
        _countData();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }
}
