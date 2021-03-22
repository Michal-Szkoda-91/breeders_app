import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/models/swapInformation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class SwapInformation extends StatefulWidget {
  const SwapInformation({
    Key key,
  }) : super(key: key);

  @override
  _SwapInformationState createState() => _SwapInformationState();
}

class _SwapInformationState extends State<SwapInformation> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<SwapInformationModel>(context);
    return AnimatedOpacity(
      opacity: dataProvider.blink ? 1 : 0.2,
      duration: Duration(milliseconds: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedDefaultTextStyle(
            child: Text("Przesuń aby uzyskać więcej informacji"),
            duration: Duration(milliseconds: 400),
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: MediaQuery.of(context).size.width < 350
                  ? 4
                  : dataProvider.blink
                      ? 16
                      : 14,
            ),
          ),
          Icon(
            MaterialCommunityIcons.swap_horizontal_bold,
            color: Theme.of(context).textSelectionColor,
            size: 25,
          ),
        ],
      ),
    );
  }
}
