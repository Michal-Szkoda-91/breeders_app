import 'package:breeders_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/parrot_model.dart';
import '../widgets/create_parrot_listTile.dart';
import '../widgets/parrots_race_AddDropdownButton.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../../globalWidgets/mainBackground.dart';
import 'package:provider/provider.dart';

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
  List<String> _activeRaceList = [];
  bool _isLoaded = false;
  bool _isInit = true;

  Future<void> _loadData(
      {BuildContext context, Function readRaceList, String uid}) async {
    try {
      await readRaceList(uid: uid).then((_) {
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final dataProvider = Provider.of<ParrotsList>(context);
      _loadData(
              context: context,
              readRaceList: dataProvider.readActiveParrotRace,
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
    _activeRaceList = dataProvider.getRaceList;
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: MainBackground(
        child: Column(
          children: [
            //switch do zmiany zwierzaka
            CreateParrotsDropdownButton(),
            !_isLoaded
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child:
                        CreateParrotListTile(activeRaceList: _activeRaceList),
                  ),
          ],
        ),
      ),
    );
  }
}
