import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/provider/note_provider.dart';
import 'package:tasbih/provider/zikir_provider.dart';
import 'package:tasbih/screens/splash_screen.dart';
import 'constant/app_constant.dart';
import 'constant/messages.dart';
import 'controllers/language_controller.dart';
import 'constant/dep.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> _languages = await dep.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  MobileAds.instance.initialize();
  Map? sdkConfiguration = await AppLovinMAX.initialize(
      "fm3JuPfG8PEp2lL9vnixg0Ler02ck8LX62PPKTWz8TJp0FALb9pPFOgGZD7fDV0Zvepqv0ObTDJZRGOSQ6LzLJ");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NoteProvider()),
      ChangeNotifierProvider(create: (context) => ZikirProvider()),
    ],
    child: MyApp(
      languages: _languages,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.languages});
  final Map<String, Map<String, String>> languages;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<LocalizationController>(
          builder: (localizationController) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ستایش',
              theme: ThemeData(
                fontFamily: 'Barlow',
                primarySwatch: Colors.blue,
              ),
              locale: localizationController.locale,
              translations: Messages(languages: widget.languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
