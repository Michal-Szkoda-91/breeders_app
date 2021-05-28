import 'dart:io';

class AdHelper {
  static String get bannerAdUnitID {
    if (Platform.isAndroid) {
      return "ca-app-pub-6198840177908447/3276841709";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6198840177908447/3276841709";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
