import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class AdsHelper {
  //var eventListener = null;
  final String appId = Platform.isAndroid
      ? (isInDebugMode
          ? 'ca-app-pub-3940256099942544~3347511713' // test AppID
          : 'ca-app-pub-0154172666410102~7085691057') //Android
      : 'ca-app-pub-0154172666410102~6510975989'; //iOS

  static const kEYWORDS = <String>[
    'chatbot',
    'xchat',
    'CognitAI',
    'chatgpt',
    'openai',
    'chatai',
    'chatimagetext',
  ];

  static const cONTENTURL = 'https://www.erhacorp.id';

  static createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? (isInDebugMode
              ? 'ca-app-pub-3940256099942544/6300978111'
              : 'ca-app-pub-0154172666410102/1218851359') //Android
          : 'ca-app-pub-0154172666410102/6379129958', //iOS
      size: AdSize.banner,
      request: request,
      listener: listenerBanner,
    );

    return _bannerAd!.load();
  }

  static createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? (isInDebugMode
                ? 'ca-app-pub-3940256099942544/1033173712'
                : 'ca-app-pub-0154172666410102/5896462960') //Android
            : 'ca-app-pub-0154172666410102/7309068242', //iOS
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            _interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) =>
                  debugPrint('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                debugPrint('$ad onAdDismissedFullScreenContent.');
                ad.dispose();

                _interstitialAd = null;
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                //debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();

                _interstitialAd = null;

                Future.delayed(const Duration(seconds: 10), () {
                  createInterstitialAd();
                });
              },
              onAdImpression: (InterstitialAd ad) =>
                  debugPrint('$ad impression occurred.'),
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            _interstitialAd = null;

            Future.delayed(const Duration(seconds: 10), () {
              createInterstitialAd();
            });
          },
        ));
  }

  static const AdRequest request = AdRequest(
    keywords: kEYWORDS,
    contentUrl: cONTENTURL,
    nonPersonalizedAds: true,
  );

  static bool _bannerReady = false;
  bool get bannerReady => _bannerReady;

  static final BannerAdListener listenerBanner = BannerAdListener(
    onAdLoaded: (Ad ad) {
      // _bannerAd = ad.;
      debugPrint('${ad.runtimeType} loaded.');
      _bannerReady = true;
      setBannerContainer();
    },
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      //debugPrint(
      //    '${ad.runtimeType.toString()} failed to load: ${error.toString()}.');
      ad.dispose();
      _bannerAd = null;
      setBannerContainer(setNull: true);

      Future.delayed(const Duration(seconds: 10), () {
        createBannerAd();
      });
    },
    onAdOpened: (Ad ad) =>
        debugPrint('${ad.runtimeType.toString()} onAdOpened.'),
    onAdClosed: (Ad ad) {
      debugPrint('${ad.runtimeType.toString()} closed.');
      ad.dispose();
      _bannerAd = null;
      setBannerContainer(setNull: true);

      Future.delayed(const Duration(seconds: 10), () {
        createBannerAd();
      });
    },
    //onApplicationExit: (Ad ad) => debugPrint('${ad.runtimeType} onApplicationExit.'),
  );

  static BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd!;

  static InterstitialAd? _interstitialAd;
  InterstitialAd? get interstitialAd => _interstitialAd;

  AdsHelper._() {
    init();
  }

  static final AdsHelper _instance = AdsHelper._();
  static AdsHelper get instance => _instance;

  init() {
    debugPrint("[AdsHelper] initialization...");
    MobileAds.instance.initialize().then((InitializationStatus status) {
      debugPrint('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((value) {
        //prepare init ad unit

        createBannerAd();
        createInterstitialAd();
      });
    });

    debugPrint("Ads initialization done...");
  }

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  // extention for banner container
  static final bannerContainer = WidgetAdsBanner().obs;
  static setBannerContainer({final bool? setNull}) {
    if (setNull != null && setNull) {
      //debugPrint("ads_helper set Null");
      bannerContainer.update((val) {
        val!.aContainer = null;
      });
    } else {
      //debugPrint("ads_helper setBannerContainer");
      bannerContainer.update((val) {
        val!.aContainer = Container(
          padding: EdgeInsets.zero,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      });
    }
  }
}

class WidgetAdsBanner {
  Container? aContainer;
}
