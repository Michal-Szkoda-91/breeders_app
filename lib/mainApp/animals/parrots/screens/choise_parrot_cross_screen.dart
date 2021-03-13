import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:provider/provider.dart';

class ChoiseParrotCrossScreen extends StatefulWidget {
  static const String routeName = "/ChoiseParrotCrossScreen";

  final String raceName;
  final String urlToParrot;
  ChoiseParrotCrossScreen({this.raceName, this.urlToParrot});

  @override
  _ChoiseParrotCrossScreenState createState() =>
      _ChoiseParrotCrossScreenState();
}

class _ChoiseParrotCrossScreenState extends State<ChoiseParrotCrossScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  List<Parrot> _parrotList = [];
  bool _isLoaded = false;
  bool _isInit = true;

  Future<void> _loadData(
      {BuildContext context,
      Function readParrot,
      String uid,
      String parrotRaceName}) async {
    try {
      await readParrot(uid: uid, parrotRace: parrotRaceName).then((_) {
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
              readParrot: dataProvider.readParrotsList,
              uid: firebaseUser.uid,
              parrotRaceName: widget.raceName)
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
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.raceName),
      ),
      body: MainBackground(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: !_isLoaded
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        color: Theme.of(context).backgroundColor,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          height: 150,
                          child: Column(
                            children: [
                              Text(
                                "Hodowla - ${widget.raceName}",
                                style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                  fontSize: 22,
                                ),
                              ),
                              AutoSizeText(
                                "Liczba zwierzaków:",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  _parrotList.length.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Text("Moje krzyżówki"),
                      )
                    ],
                  )),
      ),
    );
  }
}
