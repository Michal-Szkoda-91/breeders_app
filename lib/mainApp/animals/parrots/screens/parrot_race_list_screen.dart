import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/create_race_listTile.dart';
import '../widgets/swap_information.dart';
import '../../../../services/auth.dart';
import '../models/parrot_model.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../../globalWidgets/mainBackground.dart';

class ParrotsRaceListScreen extends StatefulWidget {
  static const String routeName = "/ParrotsRaceListScreen";

  final String name;

  ParrotsRaceListScreen({Key key, this.name}) : super(key: key);

  @override
  _ParrotsRaceListScreenState createState() => _ParrotsRaceListScreenState();
}

class _ParrotsRaceListScreenState extends State<ParrotsRaceListScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<Parrot> _parrotList = [];
  List<String> _activeRaceList = [];
  bool _isLoaded = false;
  bool _isInit = true;

  Future<void> _loadData(
      {BuildContext context, Function readParrot, String uid}) async {
    try {
      await readParrot(uid: uid).then((_) {
        setState(() {
          _isLoaded = true;
        });
      });
    } catch (error) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Nie udało się wczytać danych!'),
          content: Text(
              'Sprawdź połączenie z internetem.\nJeśli połączenie jest prawidłowe spróbuj ponownie później.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
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
      final dataProvider = Provider.of<ParrotsList>(context);
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
    _parrotList = dataProvider.getParrotList;
    _createActiveRaceList(_parrotList);
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.name),
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
                : Expanded(
                    child: Column(
                      children: [
                        SwapInformation(),
                        SizedBox(height: 5),
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
