import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'register_screen.dart';
import 'signIn_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int _page = 0;
  PageController _controller;

  //check of keyboard activity
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool keyboardState;

  @protected
  void initState() {
    super.initState();
    _controller = new PageController(
      initialPage: _page,
    );

    keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          keyboardState = visible;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
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
          FlatButton(
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
            activeColor: Theme.of(context).textSelectionColor,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 600),
            tabBackgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).textSelectionColor,
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
    setState(() {
      this._controller.animateToPage(index,
          duration: const Duration(milliseconds: 800), curve: Curves.ease);
      this._page = index;
    });
  }

//Dialog wyswietlany przy zamykaniu aplikacji
  _showDialog(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      builder: (ctx) => new AlertDialog(
        title: const Text(
          "Czy na pewno chcesz zamknąć aplikacje?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: AutoSizeText(
              'Zamknij',
            ),
            onPressed: () => exit(0),
          ),
          FlatButton(
            child: AutoSizeText(
              'Anuluj',
            ),
            onPressed: () {
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }
}
