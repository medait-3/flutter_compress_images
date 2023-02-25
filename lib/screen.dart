import 'package:compress_images_flutter/compress_images_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:imagecomp/ad_helper.dart';

class compres extends StatefulWidget {
  const compres({super.key});

  @override
  State<compres> createState() => _compresState();
}

class _compresState extends State<compres> {
  final CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();
  XFile? photo;
  double photoLengthCompressed = 0;
  double photoLengthNormal = 0;
  final ImagePicker _picker = ImagePicker();
  File? newPhoto;
  File? compressedPhoto;

  //---------------sttart ads
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd;
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _bottomBannerAd.dispose();
  }
//-------------end ads

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (newPhoto != null) {
            GallerySaver.saveImage(newPhoto!.path);
            print("saved");
            var snackBar = SnackBar(content: Text('Save in Gallery'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            var snackBar = SnackBar(content: Text('Select img'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        label: Row(
          children: [Icon(Icons.save), Text('Save in Gallery')],
        ),
      ),
      appBar: AppBar(
        title: const Text('Compress image'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  photo = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {});
                  if (photo != null) {
                    newPhoto = File(photo!.path);
                    compressedPhoto = await compressImagesFlutter
                        .compressImage(photo!.path, quality: 30);
                    photoLengthCompressed =
                        (((compressedPhoto!.readAsBytesSync().lengthInBytes) *
                                    1.0) /
                                1024) /
                            1024;
                    photoLengthNormal =
                        (((newPhoto!.readAsBytesSync().lengthInBytes) * 1.0) /
                                1024) /
                            1024;
                  } else {
                    print("no image");
                  }
                },
                child: Image(
                    fit: BoxFit.fill,
                    height: 115,
                    width: 115,
                    image: AssetImage("assets/add-image.png")),
              ),
              if (compressedPhoto != null)
                Image.file(
                  compressedPhoto!,
                  key: UniqueKey(),
                ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
