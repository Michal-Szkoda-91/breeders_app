import 'package:flutter/material.dart';

import '../../models/parrot_model.dart';

class GenderIcon extends StatefulWidget {
  final int index;
  final List<Parrot> createdParrotList;

  const GenderIcon({
    required this.index,
    required this.createdParrotList,
  });

  @override
  _GenderIconState createState() => _GenderIconState();
}

class _GenderIconState extends State<GenderIcon> {
  Color colorBackground = Colors.greenAccent;
  Color? colorIcon = Colors.green[700];
  IconData icon = Icons.help;

  void _colorIcon() {
    if (widget.createdParrotList[widget.index].sex == "Samiec") {
      colorBackground = Colors.blue.shade300;
      colorIcon = Colors.blue[700];
      icon = Icons.male;
    } else if (widget.createdParrotList[widget.index].sex == "Samica") {
      colorBackground = Colors.pink.shade300;
      colorIcon = Colors.pink[700];
      icon = Icons.female;
    } else {
      colorBackground = Colors.greenAccent;
      colorIcon = Colors.green[700];
      icon = Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    _colorIcon();
    return Container(
      width: 50,
      height: 60,
      decoration: const BoxDecoration(
        border: const Border(
          right: const BorderSide(color: Colors.black, width: 1.0),
          bottom: const BorderSide(color: Colors.black, width: 1.0),
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
              color: Theme.of(context).canvasColor,
            ),
            borderRadius: const BorderRadius.all(
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
