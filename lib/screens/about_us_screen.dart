import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/secondary_background.png"), fit: BoxFit.fill)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 34),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.colorWhiteHighEmp),
                  Text(
                    'about_us'.tr,
                    style: TextStyle(
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.colorPrimaryLight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'about_us'.tr,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'about1'.tr,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: AppColors.colorWhiteMidEmp,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'about2'.tr,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: AppColors.colorWhiteMidEmp,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'about3'.tr,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: AppColors.colorWhiteMidEmp,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}