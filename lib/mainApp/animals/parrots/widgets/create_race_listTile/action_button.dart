import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    Key key,
    @required this.color,
    @required this.icon,
    @required this.name,
    @required this.padding,
    @required this.function,
    this.raceName,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final String name;
  final double padding;
  final Function function;
  final String raceName;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isClicked = false;

  void _animation() {
    setState(() {
      _isClicked = !_isClicked;
    });
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      setState(() {
        _isClicked = !_isClicked;
      });
      widget.function(widget.raceName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animation();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: widget.padding),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Icon(
                    widget.icon,
                    size: _isClicked ? 35 : 30,
                    color: _isClicked
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textSelectionColor,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 35),
                    child: AutoSizeText(
                      widget.name,
                      style: TextStyle(
                        color: _isClicked
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textSelectionColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
