import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SwapInformation extends StatelessWidget {
  const SwapInformation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AutoSizeText(
          "Przesuń aby uzyskać więcej informacji",
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: MediaQuery.of(context).size.width < 350 ? 4 : 14,
          ),
        ),
        Icon(
          MaterialCommunityIcons.swap_horizontal_bold,
          color: Theme.of(context).textSelectionColor,
          size: 25,
        ),
      ],
    );
  }
}
