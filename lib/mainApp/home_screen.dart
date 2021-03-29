import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import 'models/breedings_model.dart';
import 'widgets/breeds_ListView.dart';
import 'widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final _firebaseUser = FirebaseAuth.instance.currentUser;
  var _isLoading = true;
  var _isInit = false;
  List<BreedingsModel> _breedingsList;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isLoading = true;
      final providerData = Provider.of<BreedingsList>(context);
      providerData.loadBreeds(_firebaseUser.uid, context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _breedingsList = Provider.of<BreedingsList>(context).getBreedingsList ?? [];
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Moje Hodowle'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                BreedsListView(_breedingsList),
              ],
            ),
    );
  }
}
