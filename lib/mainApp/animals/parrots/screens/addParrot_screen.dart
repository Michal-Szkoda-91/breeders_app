import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../animals/parrots/models/parrot_model.dart';
import 'package:breeders_app/globalWidgets/mainBackground.dart';
import 'package:breeders_app/mainApp/widgets/custom_drawer.dart';
import 'package:breeders_app/services/auth.dart';
import 'package:provider/provider.dart';

import 'Parrotrace_list_screen.dart';

class AddParrotScreen extends StatefulWidget {
  static const String routeName = "/AddParrotScreen";

  final Map<dynamic, dynamic> parrotMap;

  AddParrotScreen({this.parrotMap});

  @override
  _RaceListScreenState createState() => _RaceListScreenState();
}

class _RaceListScreenState extends State<AddParrotScreen> {
  final AuthService _auth = AuthService();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

  final double _sizedBoxHeight = 16.0;

  String country = "PL";
  String year = DateTime.now().year.toString();
  String symbol = "";
  String parrotNumber = "";
  String ringNumber = "";
  String parrotColor = "";
  String fission = "";
  String cageNumber = "";
  String notes = "";
  Map<double, String> sexMap = {1.0: 'Samiec', 2.0: 'Samica', 3.0: 'Nieznana'};
  double sex = 1.0;
  String sexName = "";

  Pattern _countryPatter = r'^([A-Z]+)$';
  Pattern _yearPatter = r'^(\d{2}|\d{4})$';
  Pattern _numberPatter = r'^(\d*)$';

  ParrotsList dataProvider;
  Parrot _createdParrot;

  @override
  void initState() {
    super.initState();
    sexName = sexMap[1.0];
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<ParrotsList>(context);
    RegExp _regExpCountry = RegExp(_countryPatter);
    RegExp _regExpYear = RegExp(_yearPatter);
    RegExp _regExpNumber = RegExp(_numberPatter);
    final node = FocusScope.of(context);
    return Scaffold(
      endDrawer: CustomDrawer(auth: _auth),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Dodawanie Papugi"),
      ),
      body: MainBackground(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: _sizedBoxHeight),
              customTitle(context),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //******************************************************* */
                    //Ring number
                    infoText(context, "Numer obrączki"),
                    SizedBox(height: _sizedBoxHeight),
                    ringNumberRow(
                      context,
                      _regExpCountry,
                      node,
                      _regExpYear,
                      _regExpNumber,
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //Sex
                    sexSwitchRow(context),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //Color
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Wprowadż barwę papugi',
                      icon: Icons.color_lens,
                      mainValue: 'parrotColor',
                      maxlines: 1,
                      maxLength: 30,
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //Fission
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Jakie rozszczepienie',
                      icon: Icons.star_border_purple500_outlined,
                      mainValue: 'fission',
                      maxlines: 1,
                      maxLength: 30,
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //cage number
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Numer / nazwa klatki',
                      icon: Icons.home_outlined,
                      mainValue: 'cageNumber',
                      maxlines: 1,
                      maxLength: 30,
                    ),
                    SizedBox(height: _sizedBoxHeight),
                    //
                    //******************************************************* */
                    //notes
                    customTextFormField(
                      context: context,
                      node: node,
                      hint: 'Notatka / Dodatkowa informacja',
                      icon: Icons.home_outlined,
                      mainValue: 'notes',
                      maxlines: 3,
                      maxLength: 100,
                    ),
                  ],
                ),
              ),
              SizedBox(height: _sizedBoxHeight),
              Row(
                children: [
                  const Expanded(
                    child: const SizedBox(),
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Dodaj Papugę',
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                      ),
                    ),
                    //create a parrot
                    onPressed: createParrots,
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
  //BUILD METODS
// ******************************************************************************************

  TextFormField customTextFormField({
    BuildContext context,
    FocusScopeNode node,
    String hint,
    IconData icon,
    String mainValue,
    int maxLength,
    int maxlines,
  }) {
    return TextFormField(
      style: customTextStyle(context),
      cursorColor: Theme.of(context).textSelectionColor,
      maxLength: maxLength,
      maxLines: maxlines,
      decoration: _createInputDecoration(
        context,
        hint,
        icon,
      ),
      validator: (val) {
        if (val.isEmpty) {
          return 'Uzupełnij dane';
        } else {
          return null;
        }
      },
      onChanged: (val) {
        setState(() {
          switch (mainValue) {
            case 'parrotColor':
              parrotColor = val;
              break;
            case 'fission':
              fission = val;
              break;
            case 'cageNumber':
              cageNumber = val;
              break;
            case 'notes':
              notes = val;
              break;
            default:
              return;
          }
        });
      },
      onEditingComplete: () => node.nextFocus(),
    );
  }

  Row sexSwitchRow(BuildContext context) {
    return Row(
      children: [
        infoText(context, "Płeć:"),
        FittedBox(
          child: Slider(
            value: sex,
            activeColor: sex == 1.0
                ? Colors.blue
                : sex == 2.0
                    ? Colors.pinkAccent
                    : Colors.green,
            max: 3,
            min: 1,
            divisions: 2,
            onChanged: (val) {
              setState(() {
                sex = val;
                sexName = sexMap[val];
              });
            },
          ),
        ),
        infoText(context, sexName),
      ],
    );
  }

  Row ringNumberRow(BuildContext context, RegExp _regExpCountry,
      FocusScopeNode node, RegExp _regExpYear, RegExp _regExpNumber) {
    return Row(
      children: [
        //
        //
        //************************************ */
        // Country
        Expanded(
          flex: 4,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 4,
            initialValue: country,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Kraj',
              null,
            ),
            validator: (val) {
              if (val.isEmpty || !_regExpCountry.hasMatch(val)) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                country = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
        infoText(context, " - "),
        //
        //
        //************************************ */
        // Year
        Expanded(
          flex: 4,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 4,
            initialValue: year,
            keyboardType: TextInputType.number,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Rok',
              null,
            ),
            validator: (val) {
              if (val.isEmpty || !_regExpYear.hasMatch(val)) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                year = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
        infoText(context, " - "),
        //
        //
        //************************************ */
        // Symbol
        Expanded(
          flex: 6,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 6,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Symbol',
              null,
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                symbol = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
        infoText(context, " - "),
        //
        //************************************ */
        // Number
        Expanded(
          flex: 5,
          child: TextFormField(
            textAlign: TextAlign.center,
            maxLength: 5,
            keyboardType: TextInputType.number,
            style: customTextStyle(context),
            cursorColor: Theme.of(context).textSelectionColor,
            decoration: _createInputDecoration(
              context,
              'Numer',
              null,
            ),
            validator: (val) {
              if (val.isEmpty || !_regExpNumber.hasMatch(val)) {
                return 'Błąd';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                parrotNumber = val;
              });
            },
            onEditingComplete: () => node.nextFocus(),
          ),
        ),
      ],
    );
  }

  Text infoText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).textSelectionColor,
      ),
    );
  }

  void createParrots() {
    if (!_formKey.currentState.validate()) {
      print("nie udalo sie");
    } else {
      setState(() {
        ringNumber = "$country-$year-$symbol-$parrotNumber";
        _createdParrot = Parrot(
            race: widget.parrotMap['name'],
            ringNumber: ringNumber,
            cageNumber: cageNumber,
            color: parrotColor,
            fission: fission,
            notes: notes,
            sex: sexName);
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ParrotsRaceListScreen(
              name: "Hodowla Papug",
            ),
          ),
        );
      });
      dataProvider.createParrotCollection(
        uid: firebaseUser.uid,
        parrot: _createdParrot,
      );
      // print(
      //     "${widget.parrot['name']}\n$ringNumber\n$sexName\n$parrotColor\n$fission\n$cageNumber\n$notes");
    }
  }

//Styl tekstu w inputach
  TextStyle customTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).textSelectionColor,
      fontSize: 16,
    );
  }

  Row customTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipOval(
          child: Image.asset(
            widget.parrotMap['url'],
            fit: BoxFit.cover,
            height: 80,
            width: 80,
          ),
        ),
        Text(
          widget.parrotMap['name'],
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  InputDecoration _createInputDecoration(
      BuildContext context, String text, IconData icon) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: icon == null ? 3 : 14),
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      labelText: text,
      icon: icon == null
          ? null
          : Icon(
              icon,
              color: Theme.of(context).textSelectionColor,
            ),
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      filled: true,
      fillColor: Theme.of(context).primaryColor,
      enabledBorder: UnderlineInputBorder(
        // borderRadius: const BorderRadius.all(
        //   const Radius.circular(5.0),
        // ),
        borderSide: BorderSide(
          width: 3,
          color: Theme.of(context).primaryColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          width: 3,
          color: Theme.of(context).textSelectionColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).textSelectionColor,
        ),
      ),
    );
  }
}
