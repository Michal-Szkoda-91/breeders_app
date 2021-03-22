import 'package:flutter/cupertino.dart';

class SwapInformationModel with ChangeNotifier {
  bool blink = false;

  Future<void> changeSize() async {
    blink = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400), () {
      blink = false;
      notifyListeners();
    });
  }
}
