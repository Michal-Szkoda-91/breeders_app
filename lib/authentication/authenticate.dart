import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'register_screen.dart';
import 'signIn_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int _page = 0;
  late PageController _controller;

  @protected
  void initState() {
    super.initState();
    _controller = new PageController(
      initialPage: _page,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Column(
        children: [
          Expanded(
            child: SignInScreen(
              changePage: _changePage,
            ),
          ),
        ],
      ),
      RegisterScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => _showDialog(context),
          ),
        ],
        title: const Text('Logowanie użytkownika'),
      ),
      body: new PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          _changePage(newPage);
        },
        children: [
          ..._widgetOptions,
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GNav(
            rippleColor: Theme.of(context).backgroundColor,
            hoverColor: Theme.of(context).backgroundColor,
            gap: 10,
            activeColor: Theme.of(context).textSelectionTheme.selectionColor,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 600),
            tabBackgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).textSelectionTheme.selectionColor,
            backgroundColor: Colors.transparent,
            selectedIndex: _page,
            tabs: [
              const GButton(
                text: "Zaloguj się",
                icon: Icons.login,
              ),
              const GButton(
                text: "Utwórz konto",
                icon: Icons.create,
              ),
            ],
            onTabChange: (index) {
              _changePage(index);
            },
          ),
        ),
      ),
    );
  }

  void _changePage(index) {
    if (mounted) {
      setState(() {
        this._controller.animateToPage(index,
            duration: const Duration(milliseconds: 800), curve: Curves.ease);
        this._page = index;
      });
    }
  }

//Dialog wyswietlany przy zamykaniu aplikacji
  _showDialog(BuildContext dialogContext) {
    showAnimatedDialog(
      context: dialogContext,
      builder: (ctx) => new AlertDialog(
        title: const Text(
          "Czy na pewno chcesz zamknąć aplikacje?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: AutoSizeText(
              'Zamknij',
            ),
            onPressed: () => exit(0),
          ),
          TextButton(
            child: AutoSizeText(
              'Anuluj',
            ),
            onPressed: () {
              Navigator.pop(ctx);
            },
          )
        ],
      ),
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 800),
    );
  }
}
