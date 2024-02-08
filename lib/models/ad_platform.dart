import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:math' as m;

import '../constants.dart';

class AppLovin {
  String appLovin = "AppLovin";
  var _interstitialRetryAttempt = 0;

  void initializeInterstitialAds() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = m.pow(2, m.min(6, _interstitialRetryAttempt)).toInt();

        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(appLovinAdUnitId);
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(appLovinAdUnitId);
  }

  Future<void> showInterstitialAd() async {
    bool isReady = (await AppLovinMAX.isInterstitialReady(appLovinAdUnitId))!;
    if (isReady) {
      AppLovinMAX.showInterstitial(appLovinAdUnitId);
    }
  }
}

class AdMob {
  String rewardedAdManager = "RewardedAdManager";
  late final RewardedAd rewardedAd;
  final String rewardedAdUnitId = adMobAdUnitId;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load rewarded ad, Error: $error");
        },
        onAdLoaded: (RewardedAd ad) {
          print("$ad loaded");
          rewardedAd = ad;
          setFullScreenContentCallback();
        },
      ),
    );
  }

  void setFullScreenContentCallback() {
    if (rewardedAd == null) return;
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print("$ad onAdShowedFullScreenContent"),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdDismissedFullScreenContent");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print("$ad onAdFailedToShowFullScreenContent: $error ");
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print("$ad Impression occurred"),
    );
  }

  void showRewardedAdWithDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      showRewardedAd();
    });
  }

  void showRewardedAd() {
    rewardedAd.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        num amount = rewardItem.amount;
        print("You earned: $amount");
      },
    );
  }
}
