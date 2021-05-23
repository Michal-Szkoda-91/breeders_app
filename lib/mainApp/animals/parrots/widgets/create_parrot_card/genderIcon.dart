import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class GenderIcon extends StatefulWidget {
  final int index;
  final List<Parrot> createdParrotList;

  const GenderIcon({
    Key key,
    this.index,
    this.createdParrotList,
  }) : super(key: key);

  @override
  _GenderIconState createState() => _GenderIconState();
}

class _GenderIconState extends State<GenderIcon> {
  Color colorBackground = Colors.greenAccent;
  Color colorIcon = Colors.green[700];
  IconData icon = MaterialCommunityIcons.help;

  void _colorIcon() {
    if (widget.createdParrotList[widget.index].sex == "Samiec") {
      colorBackground = Colors.blue[300];
      colorIcon = Colors.blue[700];
      icon = MaterialCommunityIcons.gender_male;
    } else if (widget.createdParrotList[widget.index].sex == "Samica") {
      colorBackground = Colors.pink[300];
      colorIcon = Colors.pink[700];
      icon = MaterialCommunityIcons.gender_female;
    } else {
      colorBackground = Colors.greenAccent;
      colorIcon = Colors.green[700];
      icon = MaterialCommunityIcons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    _colorIcon();
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorBackground,
            border: Border.all(
              color: Theme.of(context).textSelectionColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Icon(
            icon,
            color: colorIcon,
            size: 16,
          ),
        ),
      ),
    );
  }
}
