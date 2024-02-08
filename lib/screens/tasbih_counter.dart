import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/colors.dart';
import 'package:tasbih/helper/helper_function.dart';
import 'package:tasbih/models/note_model.dart';
import 'package:tasbih/provider/note_provider.dart';

import '../constants.dart';
import '../models/ad_platform.dart';


class TasbihCounter extends StatefulWidget {

  const TasbihCounter({Key? key}) : super(key: key);

  @override
  State<TasbihCounter> createState() => _TasbihCounterState();
}

int countNumber = 0;

class _TasbihCounterState extends State<TasbihCounter> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  late NoteProvider noteProvider;
  final noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _showSimpleDialogForAddNotes() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 340.h,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Image.asset(
                      'assets/images/popupBg.png',
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'What are you reading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.colorBlackHighEmp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: noteController,
                          decoration: InputDecoration(
                              hintText: "Subhanallah - 33 Times",
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                      color: AppColors.colorWhiteLowEmp,
                                      width: 1))),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field must not be empty';
                            }
                          },
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      saveNote();
                      Navigator.pop(context);
                      showMsg(context, 'Added Successfully');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 80, right: 80),
                      height: 36.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.colorButtonGradientStart,
                            AppColors.colorButtonGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          "Add ",
                          style: TextStyle(
                              color: AppColors.colorBlackHighEmp,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: TextButton(
                        onPressed: () {
                          String adPlatform = adPlatfrom;

                          if (adPlatform == adMob) {
                            rewardedAdManager.loadRewardedAd();
                            rewardedAdManager.showRewardedAdWithDelay();
                          }

                          else if (adPlatform == appLovin) {
                            adManager.initializeInterstitialAds();
                            adManager.showInterstitialAd();
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Close",
                          style: TextStyle(
                              color: AppColors.colorDisabled,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _showSimpleDialogForAllNotes() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 380.h,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    'assets/images/popupBg.png',
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tasbih Note',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100.h,
                  child: Consumer<NoteProvider>(
                    builder: (context, provider, child) => ListView.builder(
                      itemCount: provider.noteList.length,
                      itemBuilder: (context, index) {
                        final note = provider.noteList[index];
                        return Column(
                          children: [
                            Container(
                              height: 30.h,
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: AppColors.colorWhiteLowEmp),
                              ),
                              child: Center(
                                child: Text(
                                  note.note,
                                  style: TextStyle(
                                    color: AppColors.colorBlackHighEmp,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    deleteNotes(context, noteProvider);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 80, right: 80),
                    height: 36.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.colorButtonGradientStart,
                          AppColors.colorButtonGradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Text(
                        "Clear Note ",
                        style: TextStyle(
                          color: AppColors.colorBlackHighEmp,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: AppColors.colorDisabled,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  final List<Color> colors = [
    Colors.lightGreen,
    Colors.blue,
    Colors.deepPurpleAccent,
    Colors.orange,
    Colors.greenAccent,
    Colors.white,
    Colors.deepOrangeAccent,
    Colors.limeAccent,
  ];

  Color getRandomColor() {
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  static final AppLovin adManager = AppLovin();
  static final AdMob rewardedAdManager = AdMob();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
    _stopwatch.start();
    countNumber = 0;
    rewardedAdManager.loadRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
    _timer.cancel();
  }

  @override
  void didChangeDependencies() {
    noteProvider = Provider.of<NoteProvider>(context, listen: false);
    Provider.of<NoteProvider>(context, listen: false).getAllNotes();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = _stopwatch.elapsed;
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

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
                  fit: BoxFit.fill,
                )),
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: 45.h,
                    left: 20.w,
                    right: 16.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            String adPlatform = adPlatfrom;

                            if (adPlatform == adMob) {
                              rewardedAdManager.loadRewardedAd();
                              rewardedAdManager.showRewardedAdWithDelay();
                            }

                            else if (adPlatform == appLovin) {
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
                          padding: const EdgeInsets.only(left: 12.0,right: 12),
                          child: Text(
                              'tasbih'.tr,
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Positioned(
                  top: 200.h,
                  left: 6.w,
                  right: 6.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${hours > 0 ? hours.toString() + ':' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Text('tasbih'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                        ),
                      ),
                      Text('$countNumber',
                        style: TextStyle(
                            color: AppColors.colorAlert,
                            fontSize: 100.sp,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 70.h,),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 80.h,
                              width: 300.w,
                              decoration: BoxDecoration(
                                color: AppColors.colorGradient1Start,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          Center(
                            child: ClipRRect(
                               borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 80.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  color: AppColors.colorGradient1Start,
                                  //shape: RoundedShape(20),
                                  //borderRadius: BorderRadius.circular(100),
                                  /*boxShadow: const [
                                BoxShadow(
                                  color: Colors.green,
                                ),
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: -0.0,
                                  blurRadius: 20.0,
                                  offset: Offset(1, 1,), // changes position of shadow
                                ),
                              ],*/
                                ),
                                child: Swiper(
                                  loop: true,
                                  scrollDirection: Axis.horizontal,
                                  duration: 1000,
                                  itemCount: 100,
                                  itemBuilder: (context, index){
                                    return Row(
                                      children: [
                                        SizedBox(width: 120.w,),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            height: 60.h,
                                            width: 65.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.white,
                                              /*boxShadow: const [
                                            BoxShadow(
                                              //color: getRandomColor(),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: Offset(0, 2,), // changes position of shadow
                                            ),
                                          ],*/
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  onIndexChanged: (int demo){
                                    setState(() {
                                      countNumber++;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 75.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.colorGradient1Start,
                              borderRadius: BorderRadius.circular(100),
                              /*boxShadow: const [
                                BoxShadow(
                                  color: Colors.green,
                                ),
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: -0.0,
                                  blurRadius: 20.0,
                                  offset: Offset(1, 1,), // changes position of shadow
                                ),
                              ],*/
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          countNumber = 0;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 35,
                                      )),
                                  InkWell(
                                      onTap: (){
                                        _showSimpleDialogForAddNotes();
                                      },
                                      child: const Icon(
                                        Icons.save,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                  InkWell(
                                      onTap: (){
                                        _showSimpleDialogForAllNotes();
                                      },
                                      child: const Icon(
                                        Icons.history,
                                        color: Colors.white,
                                        size: 33 ,)),
                                  const Icon(Icons.mode_night,color: Colors.white,size: 30,),
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ));
  }

  void saveNote(){
    if(_formKey.currentState!.validate()) {
      final note = NoteModel(
          note: noteController.text
      );
      noteProvider
          .insertNote(note)
          .then((value) {
        noteProvider.getAllNotes();
      }).catchError((error) {
        print(error.toString());
      });
    }
    noteController.text = '';
  }

  void deleteNotes(BuildContext context, NoteProvider provider) {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.colorPrimaryDark,
      title: const Text('Clear All Notes?',style: TextStyle(color: AppColors.colorAlert),),
      content: const Text('Are you sure to clear all notes?',style: TextStyle(color: Colors.white),),
      actions: [
        TextButton(onPressed: () =>
            Navigator.pop(context),
            child: const Text('No',style: TextStyle(color: Colors.white))),
        TextButton(onPressed: (){
          Navigator.pop(context);
          provider.deleteNotes().then((value) {
            Navigator.pop(context);
            provider.getAllNotes();
          });
        }, child: const Text('Yes',style: TextStyle(color: AppColors.colorAlert)))

      ],
    ));
  }
}