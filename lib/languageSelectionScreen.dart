import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/colors.dart';
import 'package:tasbih/screens/home_screen.dart';

import 'constant/app_constant.dart';
import 'constants.dart';
import 'controllers/language_controller.dart';
import 'models/ad_platform.dart';

class SetLanguage extends StatefulWidget {
  const SetLanguage({Key? key}) : super(key: key);

  @override
  State<SetLanguage> createState() => _SetLanguageState();
}

class _SetLanguageState extends State<SetLanguage> {
  void _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  static final AppLovin adManager = AppLovin();
  static final AdMob rewardedAdManager = AdMob();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rewardedAdManager.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          String adPlatform = adPlatfrom;

          if (adPlatform == adMob) {
            rewardedAdManager.loadRewardedAd();
            rewardedAdManager.showRewardedAdWithDelay();
          } else if (adPlatform == appLovin) {
            adManager.initializeInterstitialAds();
            adManager.showInterstitialAd();
          }
          Navigator.pop(context);
          return false;
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/secondary_background.png"),
                  fit: BoxFit.fill)),
          child: Stack(children: [
            Positioned(
                top: 45.h,
                left: 20.w,
                right: 16.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        String adPlatform = adPlatfrom;

                        if (adPlatform == adMob) {
                          rewardedAdManager.loadRewardedAd();
                          rewardedAdManager.showRewardedAdWithDelay();
                        } else if (adPlatform == appLovin) {
                          adManager.initializeInterstitialAds();
                          adManager.showInterstitialAd();
                        }
                        Navigator.pop(context);
                        print('ok');
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: Text(
                        'select_language'.tr,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            Center(
              child: GetBuilder<LocalizationController>(
                  builder: (localizationController) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 38, 72, 44),
                        borderRadius: BorderRadius.circular(14),
                        // border: Border.all(
                        //   color: Colors.white,
                        //   width: 2.0,
                        // ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          localizationController.setLanguage(Locale(
                            AppConstants.languages[0].languageCode,
                            AppConstants.languages[0].countryCode,
                          ));
                          localizationController.setSelectedIndex(0);
                          _saveLanguage('en'); // Save 'en' as selected language
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
                        child: Text(
                          'English',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 60.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 38, 72, 44),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextButton(
                        onPressed: () {
                          localizationController.setLanguage(Locale(
                            AppConstants.languages[1].languageCode,
                            AppConstants.languages[1].countryCode,
                          ));
                          localizationController.setSelectedIndex(1);
                          _saveLanguage('ar'); // Save 'ar' as selected language
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
                        child: Text(
                          'العربية',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
