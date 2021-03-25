import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/parrot_model.dart';
import '../widgets/create_parrot_card.dart';
import '../../../../globalWidgets/mainBackground.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../../services/auth.dart';

class ParrotsListScreen extends StatefulWidget {
  static const String routeName = "/ParrotsListScreen";

  final raceName;

  const ParrotsListScreen({this.raceName});

  @override
  _ParrotsListScreenState createState() => _ParrotsListScreenState();
}

class _ParrotsListScreenState extends State<ParrotsListScreen> {
  final AuthService _auth = AuthService();
  List<Parrot> _createdParrotList = [];

  void _loadParrot() {
    var providerData = Provider.of<ParrotsList>(context);
    _createdParrotList.clear();
    providerData.getParrotList.forEach((parrot) {
      if (parrot.race == widget.raceName) {
        _createdParrotList.add(parrot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadParrot();
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.raceName),
      ),
      body: MainBackground(
        child: ParrotCard(createdParrotList: _createdParrotList),
      ),
    );
  }
}
