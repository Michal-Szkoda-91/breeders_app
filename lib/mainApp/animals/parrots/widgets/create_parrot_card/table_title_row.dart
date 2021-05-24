import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TableTitleRow extends StatefulWidget {
  const TableTitleRow({
    Key key,
    @required this.context,
    @required this.title,
    @required this.width,
    @required this.sortedIndex,
    this.sorting,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final double width;
  final int sortedIndex;
  final Function sorting;

  @override
  _TableTitleRowState createState() => _TableTitleRowState();
}

class _TableTitleRowState extends State<TableTitleRow> {
  bool _isClicked = false;

  void _animation() {
    setState(() {
      _isClicked = !_isClicked;
    });
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      setState(() {
        _isClicked = !_isClicked;
      });
      if (widget.sortedIndex != 0) widget.sorting(widget.sortedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Colors.red,
        radius: 22,
        onTap: () {
          _animation();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: const Border(
              right: const BorderSide(color: Colors.black, width: 2.0),
              bottom: const BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
          width: widget.width,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                widget.title,
                maxLines: 1,
                style: TextStyle(
                  color: _isClicked
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textSelectionColor,
                  fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
                ),
              ),
              widget.sortedIndex != 0
                  ? Icon(
                      MaterialCommunityIcons.arrow_down_drop_circle_outline,
                      color: _isClicked
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textSelectionColor,
                      size: 25,
                    )
                  : Container(
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
