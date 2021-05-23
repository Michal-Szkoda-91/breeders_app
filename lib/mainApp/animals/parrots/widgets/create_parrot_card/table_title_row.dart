import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TableTitleRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Colors.red,
        radius: 22,
        onTap: () {
          if (sortedIndex != 0) sorting(sortedIndex);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              right: BorderSide(color: Colors.black, width: 2.0),
              bottom: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
          width: width,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: MediaQuery.of(context).size.width > 350 ? 14 : 12,
                ),
              ),
              sortedIndex != 0
                  ? Icon(
                      MaterialCommunityIcons.arrow_down_drop_circle_outline,
                      color: Theme.of(context).textSelectionColor,
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
