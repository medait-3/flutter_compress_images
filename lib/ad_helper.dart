import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5268324707641148/4445731601";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

//
//
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5268324707641148/4761426374";
      //} //else if (Platform.isIOS) {
      //return "ca-app-pub-3940256099942544/5135589807";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
