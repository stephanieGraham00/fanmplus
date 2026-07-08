import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._();
  factory AdService() => _instance;
  AdService._();

  bool _initialized = false;
  int _interstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool get _isSupported => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  String get _bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) return 'ca-app-pub-3940256099942544/6300978111';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ca-app-pub-3940256099942544/2934735716';
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  String get _interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) return 'ca-app-pub-3940256099942544/8691691433';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ca-app-pub-3940256099942544/5135589807';
    return 'ca-app-pub-3940256099942544/8691691433';
  }

  String get _rewardedAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) return 'ca-app-pub-3940256099942544/5224354917';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ca-app-pub-3940256099942544/1712485313';
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  Future<void> initialize() async {
    if (!_isSupported || _initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    _loadInterstitialAd();
  }

  BannerAd? createBannerAd() {
    if (!_isSupported) return null;
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }

  void _loadInterstitialAd() {
    if (!_isSupported) return;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialLoadAttempts++;
          if (_interstitialLoadAttempts < 3) {
            _loadInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitial() {
    _interstitialAd?.show();
  }

  void loadRewardedAd({required void Function(RewardItem) onRewarded}) {
    if (!_isSupported) return;
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void showRewardedAd() {
    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {},
    );
  }
}
