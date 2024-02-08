import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../colors.dart';

class CounterSummary extends StatefulWidget {
  const CounterSummary({Key? key}) : super(key: key);

  @override
  State<CounterSummary> createState() => _CounterSummaryState();
}

class _CounterSummaryState extends State<CounterSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/secondary_background.png"),
        fit: BoxFit.fill,
      )),
            child: Stack(children: <Widget>[
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
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'counter_summery'.tr,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                top: 90.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  height: 350.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [AppColors.colorGradient1End, AppColors.colorGradient1Start],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(child: Text('fjkjdh'))
                ),
              ),

            ])));
  }
}

