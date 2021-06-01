import 'package:breeders_app/advertisement_banner/adHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerPage extends StatefulWidget {
  BannerPage({Key key}) : super(key: key);

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  BannerAd _ad;

  bool _isAddLoaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitID,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAddLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
  }

  void dispose() {
    // TODO: Dispose a BannerAd object
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAddLoaded
        ? Container(
            child: AdWidget(
              ad: _ad,
            ),
            width: _ad.size.width.toDouble(),
            height: _ad.size.height.toDouble(),
            alignment: Alignment.center,
          )
        : Center();
  }
}
