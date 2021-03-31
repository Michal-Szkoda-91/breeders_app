import 'package:breeders_app/mainApp/animals/parrots/widgets/notConnected_information.dart';
import 'package:breeders_app/models/global_methods.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/create_race_listTile.dart';
import '../../../../services/auth.dart';
import '../models/parrot_model.dart';
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
  GlobalMethods _globalMethods = GlobalMethods();
  List<Parrot> _parrotList = [];
  List<String> _activeRaceList = [];
  bool _isLoaded = false;
  bool _isInit = true;
  bool _isNotConnected = false;

  Future<void> _loadData(
      {BuildContext context, Function readParrot, String uid}) async {
    bool result = await DataConnectionChecker().hasConnection;

    if (!result) {
      _globalMethods.showMaterialDialog(context,
          "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
      setState(() {
        _isNotConnected = true;
        _isLoaded = true;
      });
    } else {
      try {
        await readParrot(uid: uid).then((_) {
          setState(() {
            _isLoaded = true;
          });
        });
      } catch (error) {
        _globalMethods.showMaterialDialog(context,
            "Operacja nieudana, nieznany błąd lub brak połączenia z internetem.");
      }
    }
  }

  void _createActiveRaceList(List<Parrot> parrotList) {
    _activeRaceList.clear();
    parrotList.forEach((val) {
      if (!_activeRaceList.contains(val.race)) {
        _activeRaceList.add(val.race);
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final dataProvider = Provider.of<ParrotsList>(context, listen: false);
      _loadData(
              context: context,
              readParrot: dataProvider.readParrotsList,
              uid: firebaseUser.uid)
          .then((_) {
        setState(() {
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<ParrotsList>(context);
    _parrotList = dataProvider.getParrotList ?? [];
    _createActiveRaceList(_parrotList);
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Hodowla Papug"),
      ),
      body: MainBackground(
        child: Column(
          children: [
            !_isLoaded
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _isNotConnected
                    ? NotConnected()
                    : Expanded(
                        child: Column(
                          children: [
                            CreateParrotRaceListTile(
                                activeRaceList: _activeRaceList),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
