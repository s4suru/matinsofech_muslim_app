import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/languageSelectionScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  late GeolocatorPlatform _geolocator;
  late LocationPermission _permission;

  @override
  void initState() {
    super.initState();
    _geolocator = GeolocatorPlatform.instance;
    _getLocationPermission();
    _getLangPageState();
  }

  _getLangPageState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_selected', "unselected");
  }

  _getLocationPermission() async {
    _permission = await _geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await _geolocator.requestPermission();
      if (_permission != LocationPermission.whileInUse &&
          _permission != LocationPermission.always) {
        // Handle the case where the user grants permission
        // but location services are disabled
        _permission = await _geolocator.requestPermission();
      }
    }
    if (_permission == LocationPermission.deniedForever) {
      // Handle the case where the user has previously denied
      // permission and chose to never ask again
      // You can show a dialog here explaining why the permission is needed
      // and guide the user to app settings to enable it manually.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Onboarding_Background.png"),
              fit: BoxFit.fill,
            )),
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                // Page 1
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        "assets/images/on_boarding1.svg",
                        height: 360.h,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      'onboarding_text1'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'onboarding_text2'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    )
                  ],
                ),
                // Page 2
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        "assets/images/on_boarding2.svg",
                        height: 360.h,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      'onboarding_text3'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'onboarding_text4'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    )
                  ],
                ),
                // Page 3
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        "assets/images/on_boarding3.svg",
                        height: 360.h,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      'onboarding_text5'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'onboarding_text6'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 380.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () async {
                    if (_currentPage == 2) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_completed_onboarding', true);
                      // Navigate to the next screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetLanguage()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/images/OnBoardingButton.svg",
                    height: 36.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

