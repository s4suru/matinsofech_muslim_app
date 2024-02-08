import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/languageSelectionScreen.dart';
import 'package:tasbih/screens/alquran_surah_list.dart';
import 'package:tasbih/screens/compass_screen.dart';
import 'package:tasbih/screens/donation_screen.dart';
import 'package:tasbih/screens/dua_screen.dart';
import 'package:tasbih/screens/hadith_screen.dart';
import 'package:tasbih/screens/prayer_time_screen.dart';
import 'package:tasbih/screens/preferences_screen.dart';
import 'package:tasbih/screens/privacy_screen.dart';
import 'package:tasbih/screens/summary_screen.dart';
import 'package:tasbih/screens/surah_page.dart';
import 'package:tasbih/screens/tasbih_counter.dart';
import 'package:tasbih/screens/tasbih_counter_zikir.dart';

import '../bar graph/bar_graph.dart';
import '../chatGPT/chat_screen.dart';
import '../colors.dart';
import '../constants.dart';
import '../models/ad_platform.dart';
import '../provider/zikir_provider.dart';
import 'about_us_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = '';
  Position? _position;

  late Coordinates _coordinates;
  late final _calculationMethod;
  List<PrayerTimes> _prayerTimes = [];

  final date = DateTime.now();
  final params = CalculationMethod.muslim_world_league.getParameters();

  List _zikir = [];

  late GeolocatorPlatform _geolocator;
  //late bool _locationEnabled;

  Future<void> readJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language',);
    print(language);
    String jsonAssetPath = 'assets/zikir_ar.json';
    if (language == 'en') {
      jsonAssetPath = 'assets/zikir_en.json';
    } else if (language == 'ar') {
      jsonAssetPath = 'assets/zikir_ar.json';
    } else if (language == 'ku') {
      jsonAssetPath = 'assets/zikir_ar.json';
    }


    final String response = await rootBundle.loadString(jsonAssetPath);
    final data = await json.decode(response);
    setState(() {
      _zikir = data['data'];
    });
  }

  static final AppLovin adManager = AppLovin();
  static final AdMob rewardedAdManager = AdMob();

  bool _showItem3 = true;

  @override
  void initState() {
    super.initState();
    getLocation();
    readJson();
    _geolocator = GeolocatorPlatform.instance;
    rewardedAdManager.loadRewardedAd();
    if(isChatAvailable == 'Yes'){
      setState(() {
        _showItem3 = true;
      });
    } else{
      setState(() {
        _showItem3 = false;
      });
    }
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String placeName = await getPlaceName(position);
      setState(() {
        location = placeName;
        _position = position;
      });
      _updatePrayerTimes();
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        location = 'Unknown Location';
      });
    }
  }

  Future<String> getPlaceName(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[
    0]; // Note: use 0 instead of 1 to get the most accurate result
    String? cityName = place.locality;
    String? countryName = place.country;
    return '$cityName, $countryName';
  }

  Future<void> _updatePrayerTimes() async {
    _coordinates = Coordinates(_position!.latitude,
        _position!.longitude); // Replace with your own location lat, lng.
    _calculationMethod = CalculationMethod.muslim_world_league.getParameters();
    _prayerTimes.clear();
    for (var i = -1; i <= 5; i++) {
      final date = DateComponents.from(DateTime.now().add(Duration(days: i)));
      final prayerTimes = PrayerTimes(_coordinates, date, _calculationMethod);
      _prayerTimes.add(prayerTimes);
    }
    setState(() {});
  }

  String _formatPrayerTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        
        height: 70.h,
        width: double.infinity,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:24.0),
              child: SvgPicture.asset(
                "assets/images/home_icon.svg",
                height: 50.h,
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompassScreen()));
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/compass_icon.svg",
                        height: 20.h,
                      ),
                      Text(
                        'quibla_compass'.tr,
                        style: TextStyle(fontSize: 10.sp),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (_showItem3)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    String adPlatform = adPlatfrom;

                    if (adPlatform == adMob) {
                      rewardedAdManager.loadRewardedAd();
                      //rewardedAdManager.showRewardedAdWithDelay();
                    }

                    else if (adPlatform == appLovin) {
                      adManager.initializeInterstitialAds();
                      //adManager.showInterstitialAd();
                    }

                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                      ),
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            double sheetHeight =
                                MediaQuery.of(context).size.height * 0.6;
                            return KeyboardVisibilityBuilder(
                              builder: (context, isKeyboardVisible) {
                                return Container(
                                  height: isKeyboardVisible
                                      ? MediaQuery.of(context).size.height * 0.87
                                      : sheetHeight,
                                  decoration:  const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(255, 90, 251, 136),
                                        Color.fromARGB(255, 74, 153, 96)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overScroll) {
                                      overScroll.disallowIndicator();
                                      return true;
                                    },
                                    child: SingleChildScrollView(
                                      physics: isKeyboardVisible
                                          ? const NeverScrollableScrollPhysics()
                                          : const AlwaysScrollableScrollPhysics(),
                                      child: SizedBox(
                                        height: isKeyboardVisible
                                            ? MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.87 +
                                            MediaQuery.of(context).size.height * 0.35
                                            : sheetHeight,
                                        child: const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: ChatScreen(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ).then((value){
                      if (adPlatform == adMob) {
                        //rewardedAdManager.loadRewardedAd();
                        rewardedAdManager.showRewardedAdWithDelay();
                      }

                      else if (adPlatform == appLovin) {
                        //adManager.initializeInterstitialAds();
                        adManager.showInterstitialAd();
                      }
                    });
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/chat.svg",
                          height: 20.h,
                        ),
                        Text(
                          "chat".tr,
                          style: TextStyle(fontSize: 10.sp),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.colorGradient2Start,
                              AppColors.colorGradient2End,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 12.h),
                              Container(
                                height: 6.h,
                                width: 57.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white38),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const TasbihCounter()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/counter.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'tasbih'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PrayerTimeScreen(
                                                      lat: _position?.latitude,
                                                      lon: _position
                                                          ?.longitude)));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/prayerTimes.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'prayer_times'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const CompassScreen()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/qiblaCompus.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'quibla_compass'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // ---- Hadith Screen ---- //
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HadithListView()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/hadith.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'hadith'.tr,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ---- Dua Screen ---- //
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const DuaScreen()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/dua.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'dua'.tr,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ---- Donation Screen ---- //
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const DonationScreen()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/donation.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'donation'.tr,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // ---- Preferences Screen ---- //
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const SetLanguage()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/preferences.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'preference'.tr,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ---- Privacy Policy Screen ---- //
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const PrivacyPolicyScreen()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/policy.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'privacy_policy'.tr,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ---- About Us Screen ---- //
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const AboutUsScreen()));
                                    },
                                    child: Container(
                                      height: 110.h,
                                      width: 102.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/aboutUs.png",
                                            height: 32.h,
                                            width: 32.w,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'about_us'.tr,
                                            style: TextStyle(
                                                color:
                                                AppColors.colorBlackHighEmp,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/menu_icon.svg",
                        height: 20.h,
                      ),
                      Text(
                        'menu'.tr,
                        style: TextStyle(fontSize: 10.sp),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ColorfulSafeArea(
        color: AppColors.colorGradient1Start,
        child: Stack(children: <Widget>[
          Positioned(
            top: 0.h,
            bottom: 0.h,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 200.h,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.colorGradient1Start,
                                  AppColors.colorGradient1End
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40))),
                        ),
                      ),
                      Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 20.0, right: 20.0, top: 16.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Image.asset(
                          //         "assets/images/logo.png",
                          //         height: 48.h,
                          //       ),
                          //       SizedBox(width: 16.w),
                          //       SizedBox(
                          //         width: 150.w,
                          //         child: Column(
                          //           crossAxisAlignment:
                          //           CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               'assalamu_alaikum'.tr,
                          //               style: TextStyle(
                          //                   fontSize: 18.sp,
                          //                   fontWeight: FontWeight.w600,
                          //                   color: Colors.white),
                          //             ),
                          //             Text(
                          //               'welcome'.tr,
                          //               style: TextStyle(
                          //                   fontSize: 14.sp,
                          //                   fontWeight: FontWeight.w300,
                          //                   color: Colors.white),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                               
                          //       InkWell(
                          //         onTap: () {},
                          //         child: Visibility(
                          //           visible: false,
                          //           child: Icon(
                          //             Icons.notifications,
                          //             size: 35.sp,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
Container(
  child:Stack(
children: [
  Container(
    margin: EdgeInsets.only(top:80),
    height: 200,
  width: 160,
  // color: Colors.white,
  child: Column(children: [
    SizedBox(height: 20,),
    Text('Welcome',style: TextStyle(fontSize: 21,color:Colors.amber ),),
    Text('App Name ',style: TextStyle(fontSize: 28,color:Colors.blue ),),
    SizedBox(height: 5,),
    Padding(
      padding: const EdgeInsets.only(left:20),
      child: Text('All the prayers in this have been taken from Quraan',style: TextStyle( ),),
    ),
  ],),
  )
],


  ),
height: 300,
width: 400,

decoration: BoxDecoration(
  color: Colors.white,
  image: DecorationImage(image: AssetImage('assets/header.jpg',),fit: BoxFit.cover)
),




),




                          SizedBox(
                            height: 20.h,
                          ),





                          //   prayer Time Container


                           Container(
                             height: 80,
                                  width: 350,
                            padding: EdgeInsets.only(top:20,left:10),
                            child: Row(children: [

                     Column(
                       children: [
                        SizedBox(height: 5,),
                         Text('Next Prayer at',style: TextStyle(color: Colors.green),),
                         Text('Magrib 05:26 pm ',style: TextStyle(fontWeight: FontWeight.w600),)
                       ],
                     ),
                     SizedBox(width: 12,),

                     Container(height: 50,
                     width:80,
                     child:Center(child: Text('All Prayer',style: TextStyle(color: Colors.white),)),
                     decoration:BoxDecoration(color:const Color.fromARGB(255, 34, 60, 35),
                     borderRadius: BorderRadius.circular(11))
                     
                     ),
                     SizedBox(width:15,height: 5,),
                     

                     Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('After That Prayer',style: TextStyle(color: Colors.green),),
                        Text('Isha 06:56 pm ',style: TextStyle(fontWeight: FontWeight.w600),)
                      ],
                     )

                            ],),
                                 
                                 
                                  decoration: BoxDecoration(
                                     color: Colors.grey.shade200,
                                     borderRadius: BorderRadius.circular(22)
                                  ),
                                ),
SizedBox(height: 10,),






                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 16.0, right: 16.0),
                          //   child: Row(
                          //     mainAxisAlignment:
                          //     MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       InkWell(
                          //           onTap: () {},
                          //           child: Stack(
                          //             children: [
                          //               Container(
                          //                 height: 220.h,
                          //                 width: 200.w,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius.circular(24),
                          //                   color: Colors.white,
                          //                   boxShadow: const [
                          //                     BoxShadow(
                          //                       color: AppColors.shadowColor,
                          //                       spreadRadius: -2.0,
                          //                       blurRadius: 4,
                          //                       offset: Offset(0,
                          //                           1), // changes position of shadow
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               Column(
                          //                 children: [
                          //                   Align(
                          //                     alignment: Alignment.topCenter,
                          //                     child: InkWell(
                          //                       onTap: () {
                          //                         Navigator.push(
                          //                             context,
                          //                             MaterialPageRoute(
                          //                                 builder: (context) =>
                          //                                 const SummaryScreen()));
                          //                       },
                          //                       child: Container(
                          //                         height: 180.h,
                          //                         width: 200.w,
                          //                         decoration: BoxDecoration(
                          //                           borderRadius:
                          //                           BorderRadius.circular(
                          //                               24),
                          //                           gradient:
                          //                           const LinearGradient(
                          //                             colors: [
                          //                               AppColors
                          //                                   .colorGradient1End,
                          //                               AppColors
                          //                                   .colorGradient3End
                          //                             ],
                          //                             begin:
                          //                             Alignment.topLeft,
                          //                             end: Alignment
                          //                                 .bottomRight,
                          //                           ),
                          //                         ),
                          //                         child: Column(
                          //                           mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .center,
                          //                           children: [
                          //                             Text(
                          //                               'weekly_counter'.tr,
                          //                               textAlign:
                          //                               TextAlign.center,
                          //                               style: TextStyle(
                          //                                   color:
                          //                                   Colors.white,
                          //                                   fontSize: 14.sp,
                          //                                   fontWeight:
                          //                                   FontWeight
                          //                                       .bold),
                          //                             ),
                          //                             Text(
                          //                               'last_week'.tr,
                          //                               textAlign:
                          //                               TextAlign.center,
                          //                               style: TextStyle(
                          //                                 color: AppColors
                          //                                     .colorAlert,
                          //                                 fontSize: 12.sp,
                          //                               ),
                          //                             ),
                          //                             SizedBox(
                          //                               height: 10.h,
                          //                             ),
                          //                             FutureBuilder<
                          //                                 List<int>>(
                          //                               future: ZikirProvider()
                          //                                   .getLast7DaysTotalCounts(),
                          //                               builder: (context,
                          //                                   snapshot) {
                          //                                 if (snapshot
                          //                                     .hasData) {
                          //                                   final last7DaysTotalCounts =
                          //                                   snapshot
                          //                                       .data!;
                          //                                   //final weeklySummary = last7DaysTotalCounts?.map((count) => count.toDouble()).toList();
                          //                                   return SizedBox(
                          //                                       height: 80.h,
                          //                                       width: 187.w,
                          //                                       child:
                          //                                       BarGraph(
                          //                                         weeklySummary: last7DaysTotalCounts
                          //                                             .map((count) => count != null
                          //                                             ? (count > 1000
                          //                                             ? 1000.0
                          //                                             : count.toDouble())
                          //                                             : 0.0)
                          //                                             .toList(),
                          //                                       ));
                          //                                 } else if (snapshot
                          //                                     .hasError) {
                          //                                   return Center(
                          //                                     child: Text(
                          //                                         'Error: ${snapshot.error}'),
                          //                                   );
                          //                                 } else {
                          //                                   return const Center(
                          //                                     child:
                          //                                     CircularProgressIndicator(),
                          //                                   );
                          //                                 }
                          //                               },
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   SizedBox(
                          //                     height: 8.h,
                          //                   ),
                          //                   Align(
                          //                     alignment:
                          //                     Alignment.bottomCenter,
                          //                     child: InkWell(
                          //                       onTap: () {
                          //                         Navigator.push(
                          //                             context,
                          //                             MaterialPageRoute(
                          //                                 builder: (context) =>
                          //                                 const TasbihCounter()));
                          //                       },
                          //                       child: Row(
                          //                         children: [
                          //                           Text('counter'.tr,
                          //                               style: TextStyle(
                          //                                   fontSize: 16.sp,
                          //                                   color: AppColors
                          //                                       .colorPrimary)),
                          //                           Padding(
                          //                             padding:
                          //                             const EdgeInsets
                          //                                 .only(
                          //                                 left: 5.0),
                          //                             child: Icon(
                          //                               Icons
                          //                                   .arrow_circle_right,
                          //                               size: 24.sp,
                          //                               color: AppColors
                          //                                   .colorPrimary,
                          //                             ),
                          //                           ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ],
                                    // )),
                          //       Container(
                          //         height: 220.h,
                          //         width: 120.w,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(16),
                          //           gradient: const LinearGradient(
                          //             colors: [
                          //               AppColors.colorGradient1End,
                          //               AppColors.colorGradient1Start
                          //             ],
                          //             begin: Alignment.topLeft,
                          //             end: Alignment.bottomRight,
                          //           ),
                          //           boxShadow: const [
                          //             BoxShadow(
                          //               color: AppColors.shadowColor,
                          //               spreadRadius: 0,
                          //               blurRadius: 4,
                          //               offset: Offset(0,
                          //                   2), // changes position of shadow
                          //             ),
                          //           ],
                          //         ),
                          //         child: ListView.builder(
                          //           padding: EdgeInsets.zero,
                          //           itemCount: _zikir.length,
                          //           itemBuilder:
                          //               (BuildContext context, int index) {
                          //             return InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             TasbihCounterZikir(
                          //                               data: _zikir[index]
                          //                               ["phrase"],
                          //                             )));
                          //               },
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     left: 12.0, right: 12.0),
                          //                 child: Container(
                          //                   height: 75.h,
                          //                   decoration: const BoxDecoration(
                          //                     border: Border(
                          //                       bottom: BorderSide(
                          //                           width: 1.0,
                          //                           color: Colors.grey),
                          //                     ),
                          //                   ),
                          //                   child: Column(
                          //                     mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                     children: <Widget>[
                          //                       Text(
                          //                         '#${index + 1}',
                          //                         style: TextStyle(
                          //                             fontSize: 24.sp,
                          //                             fontWeight:
                          //                             FontWeight.w700,
                          //                             color: AppColors
                          //                                 .colorAlert),
                          //                       ),
                          //                       Text(
                          //                         _zikir[index]["phrase"],
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontSize: 10.sp),
                          //                         textAlign: TextAlign.center,
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),


SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 12.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HadithListView()));
                                  },
                                  child: Container(
                                    
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.shadowColor,
                                          spreadRadius: -3,
                                          blurRadius: 5.0,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/hadith_icon.svg",
                                          height: 24.h,
                                        ),
                                        Text(
                                          'Holidays'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const DuaScreen()));
                                  },
                                  child: Container(
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.shadowColor,
                                          spreadRadius: -3,
                                          blurRadius: 5.0,
                                          offset: Offset(0,
                                              3), // changes position of shadow// changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/dua_icon.svg",
                                          height: 24.h,
                                        ),
                                        Text(
                                          'Tasbih'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SurahListScreen()));
                                  },
                                  child: Container(
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.shadowColor,
                                          spreadRadius: -3,
                                          blurRadius: 5.0,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/quran_icon.svg",
                                          height: 24.h,
                                        ),
                                        Text(
                                          'Name of allah'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),














                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 12.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HadithListView()));
                                  },
                                  child: Container(
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.shadowColor,
                                          spreadRadius: -3,
                                          blurRadius: 5.0,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/hadith_icon.svg",
                                          height: 24.h,
                                        ),
                                        Text(
                                          'hadith'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const DuaScreen()));
                                  },
                                  child: Container(
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.shadowColor,
                                          spreadRadius: -3,
                                          blurRadius: 5.0,
                                          offset: Offset(0,
                                              3), // changes position of shadow// changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/dua_icon.svg",
                                          height: 24.h,
                                        ),
                                        Text(
                                          'dua'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SurahListScreen()));
                                  },
                                  child: Container(
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.shadowColor,
                                          spreadRadius: -3,
                                          blurRadius: 5.0,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/quran_icon.svg",
                                          height: 24.h,
                                        ),
                                        Text(
                                          'alquran'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 18.0),
                                  child: _position?.latitude == null
                                      ? Stack(
                                    children: [
                                      Container(
                                        height: 280.h,
                                        width: 340.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(24),
                                          color: AppColors
                                              .colorPrimaryDarker,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              spreadRadius: -5.0,
                                              blurRadius: 5.0,
                                              offset: Offset(
                                                1,
                                                1,
                                              ), // changes position of shadow
                                            ),
                                          ],
                                        ),


                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment
                                                      .topCenter,
                                                  child: Container(
                                                    height: 210.h,
                                                    width: 340.w,
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          24),
                                                      gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 134, 152, 141),
                                                          Color.fromARGB(255, 113, 172, 118)
                                                        ],
                                                        begin: Alignment
                                                            .topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top:
                                                              12.0),
                                                          child:
                                                          Container(
                                                            height:
                                                            34.h,
                                                            width:
                                                            185.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    50),
                                                                color: AppColors
                                                                    .colorPrimaryDarker),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color:
                                                                  AppColors.colorPrimaryLighter,
                                                                  size:
                                                                  16.sp,
                                                                ),
                                                                Text(
                                                                  '$location',
                                                                  style: TextStyle(
                                                                      color: AppColors.colorPrimaryLighter,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14.sp),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),




                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top: 4.0),
                                                          child: Text(
                                                            'prayer_time'.tr,
                                                            style: TextStyle(
                                                                fontSize: 18
                                                                    .sp,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                              'd\'${_getDaySuffix(DateTime.now().day)}\' MMMM y')
                                                              .format(DateTime
                                                              .now()),
                                                          style: TextStyle(
                                                              fontSize:
                                                              12.sp,
                                                              color: AppColors
                                                                  .colorAlert),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                            10.h),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(
                                                              8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height:
                                                                90.h,
                                                                width:
                                                                60.w,
                                                                decoration: BoxDecoration(
                                                                    border:
                                                                    Border.all(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: Color.fromARGB(255, 90, 251, 136)),
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    if (_prayerTimes.isNotEmpty)
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                                                                        child: Text(
                                                                          _formatPrayerTime(_prayerTimes[0].fajr),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4.h,
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/images/fajr_icon.svg",
                                                                      height: 18.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text(
                                                                        'fajr'.tr,
                                                                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                90.h,
                                                                width:
                                                                60.w,
                                                                decoration: BoxDecoration(
                                                                    border:
                                                                    Border.all(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: const Color.fromARGB(255, 90, 251, 136)),
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    if (_prayerTimes.isNotEmpty)
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                                                                        child: Text(
                                                                          _formatPrayerTime(_prayerTimes[0].dhuhr),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4.h,
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/images/duhr_icon.svg",
                                                                      height: 18.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text(
                                                                        'duhr'.tr,
                                                                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                90.h,
                                                                width:
                                                                60.w,
                                                                decoration: BoxDecoration(
                                                                    border:
                                                                    Border.all(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: const Color.fromARGB(255, 90, 251, 136)),
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    if (_prayerTimes.isNotEmpty)
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                                                                        child: Text(
                                                                          _formatPrayerTime(_prayerTimes[0].asr),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4.h,
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/images/asr_icon.svg",
                                                                      height: 18.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text(
                                                                        'asr'.tr,
                                                                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                90.h,
                                                                width:
                                                                60.w,
                                                                decoration: BoxDecoration(
                                                                    border:
                                                                    Border.all(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: AppColors.colorGradient3Start),
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    if (_prayerTimes.isNotEmpty)
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                                                                        child: Text(
                                                                          _formatPrayerTime(_prayerTimes[0].maghrib),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4.h,
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/images/magrib_icon.svg",
                                                                      height: 18.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text(
                                                                        'magrib'.tr,
                                                                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                90.h,
                                                                width:
                                                                60.w,
                                                                decoration: BoxDecoration(
                                                                    border:
                                                                    Border.all(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: const Color.fromARGB(255, 90, 251, 136)),
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    if (_prayerTimes.isNotEmpty)
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                                                                        child: Text(
                                                                          _formatPrayerTime(_prayerTimes[0].isha),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4.h,
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/images/isha_icon.svg",
                                                                      height: 18.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text(
                                                                        'isha'.tr,
                                                                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                /*SvgPicture.asset(
                                                  "assets/images/lamp_left.svg",
                                                  height: 28.h,
                                                ),*/
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/asr_icon.svg",
                                                  height: 28.h,
                                                ),
                                                if (_prayerTimes
                                                    .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'iftar'.tr,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .colorAlert),
                                                        ),
                                                        Text(
                                                          _formatPrayerTime(
                                                              _prayerTimes[
                                                              0]
                                                                  .maghrib),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              20.sp),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                SizedBox(
                                                  width: 30.h,
                                                ),
                                                SvgPicture.asset(
                                                  "assets/images/fajr_icon.svg",
                                                  height: 28.h,
                                                ),
                                                if (_prayerTimes
                                                    .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'sahri'.tr,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .colorAlert),
                                                        ),
                                                        Text(
                                                          _formatPrayerTime(_prayerTimes[
                                                          0]
                                                              .fajr
                                                              .subtract(const Duration(
                                                              minutes:
                                                              3))),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              20.sp),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 40.0, left: 20.0,right: 20.0),
                                        child: Container(
                                          height: 200.h,
                                          width: 300.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                24),
                                            color: Colors.black
                                                .withOpacity(0.8),
                                          ),
                                          child:  Center(
                                            child: Text(
                                              'unable'.tr,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(
                                    height: 280.h,
                                    width: 340.w,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(24),
                                      color:
                                      AppColors.colorPrimaryDarker,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: -5.0,
                                          blurRadius: 5.0,
                                          offset: Offset(
                                            1,
                                            1,
                                          ), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Align(
                                              alignment:
                                              Alignment.topCenter,
                                              child: Container(
                                                height: 210.h,
                                                width: 340.w,
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(24),
                                                  gradient:
                                                  const LinearGradient(
                                                    colors: [
                                                      AppColors
                                                          .colorGradient3Start,
                                                      AppColors
                                                          .colorGradient3End
                                                    ],
                                                    begin: Alignment
                                                        .topCenter,
                                                    end: Alignment
                                                        .bottomCenter,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          top:
                                                          12.0),
                                                      child: Container(
                                                        height: 34.h,
                                                        width: 185.w,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                            color: AppColors
                                                                .colorPrimaryDarker),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on,
                                                              color: AppColors
                                                                  .colorPrimaryLighter,
                                                              size:
                                                              16.sp,
                                                            ),
                                                            Text(
                                                              '$location',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .colorPrimaryLighter,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  fontSize:
                                                                  10.sp),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          top: 4.0),
                                                      child: Text(
                                                        'prayer_time'.tr,
                                                        style: TextStyle(
                                                            fontSize:
                                                            18.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                          'd\'${_getDaySuffix(DateTime.now().day)}\' MMMM y')
                                                          .format(DateTime
                                                          .now()),
                                                      style: TextStyle(
                                                          fontSize:
                                                          12.sp,
                                                          color: AppColors
                                                              .colorAlert),
                                                    ),
                                                    SizedBox(
                                                        height: 10.h),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Container(
                                                            height:
                                                            95.h,
                                                            width: 60.w,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16),
                                                                color: AppColors
                                                                    .colorGradient3Start),
                                                            child:
                                                            Column(
                                                              children: [
                                                                if (_prayerTimes
                                                                    .isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 8.0,
                                                                        left: 8.0,
                                                                        right: 8.0,
                                                                        bottom: 0.0),
                                                                    child:
                                                                    Text(
                                                                      _formatPrayerTime(_prayerTimes[0].fajr),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                  height:
                                                                  4.h,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/images/fajr_icon.svg",
                                                                  height:
                                                                  18.h,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(4.0),
                                                                  child:
                                                                  Text(
                                                                    'fajr'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                            95.h,
                                                            width: 60.w,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16),
                                                                color: AppColors
                                                                    .colorGradient3Start),
                                                            child:
                                                            Column(
                                                              children: [
                                                                if (_prayerTimes
                                                                    .isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 8.0,
                                                                        left: 8.0,
                                                                        right: 8.0,
                                                                        bottom: 0.0),
                                                                    child:
                                                                    Text(
                                                                      _formatPrayerTime(_prayerTimes[0].dhuhr),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                  height:
                                                                  4.h,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/images/duhr_icon.svg",
                                                                  height:
                                                                  18.h,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(4.0),
                                                                  child:
                                                                  Text(
                                                                    'duhr'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                            95.h,
                                                            width: 60.w,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16),
                                                                color: AppColors
                                                                    .colorGradient3Start),
                                                            child:
                                                            Column(
                                                              children: [
                                                                if (_prayerTimes
                                                                    .isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 8.0,
                                                                        left: 8.0,
                                                                        right: 8.0,
                                                                        bottom: 0.0),
                                                                    child:
                                                                    Text(
                                                                      _formatPrayerTime(_prayerTimes[0].asr),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                  height:
                                                                  4.h,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/images/asr_icon.svg",
                                                                  height:
                                                                  18.h,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(4.0),
                                                                  child:
                                                                  Text(
                                                                    'asr'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                            95.h,
                                                            width: 60.w,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16),
                                                                color: AppColors
                                                                    .colorGradient3Start),
                                                            child:
                                                            Column(
                                                              children: [
                                                                if (_prayerTimes
                                                                    .isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 8.0,
                                                                        left: 8.0,
                                                                        right: 8.0,
                                                                        bottom: 0.0),
                                                                    child:
                                                                    Text(
                                                                      _formatPrayerTime(_prayerTimes[0].maghrib),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                  height:
                                                                  4.h,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/images/magrib_icon.svg",
                                                                  height:
                                                                  18.h,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(4.0),
                                                                  child:
                                                                  Text(
                                                                    'magrib'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                            95.h,
                                                            width: 60.w,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16),
                                                                color: AppColors
                                                                    .colorGradient3Start),
                                                            child:
                                                            Column(
                                                              children: [
                                                                if (_prayerTimes
                                                                    .isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 8.0,
                                                                        left: 8.0,
                                                                        right: 8.0,
                                                                        bottom: 0.0),
                                                                    child:
                                                                    Text(
                                                                      _formatPrayerTime(_prayerTimes[0].isha),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                  height:
                                                                  4.h,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/images/isha_icon.svg",
                                                                  height:
                                                                  18.h,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(4.0),
                                                                  child:
                                                                  Text(
                                                                    'isha'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            /*SvgPicture.asset(
                                                  "assets/images/lamp_left.svg",
                                                  height: 28.h,
                                                ),*/
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/asr_icon.svg",
                                              height: 28.h,
                                            ),
                                            if (_prayerTimes.isNotEmpty)
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'iftar'.tr,
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .colorAlert),
                                                    ),
                                                    Text(
                                                      _formatPrayerTime(
                                                          _prayerTimes[
                                                          0]
                                                              .maghrib),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          20.sp),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              width: 30.h,
                                            ),
                                            SvgPicture.asset(
                                              "assets/images/fajr_icon.svg",
                                              height: 28.h,
                                            ),
                                            if (_prayerTimes.isNotEmpty)
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'sahri'.tr,
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .colorAlert),
                                                    ),
                                                    Text(
                                                      _formatPrayerTime(
                                                          _prayerTimes[
                                                          0]
                                                              .fajr
                                                              .subtract(const Duration(
                                                              minutes:
                                                              3))),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          20.sp),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
      ),



    );

  }
}

String _getDaySuffix(int day) {
  // Helper function to get the day suffix
  switch (day) {
    case 1:
    case 21:
    case 31:
      return 'st';
    case 2:
    case 22:
      return 'nd';
    case 3:
    case 23:
      return 'rd';
    default:
      return 'th';
  }
}
