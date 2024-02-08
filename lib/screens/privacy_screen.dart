import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
                    'privacy_policy'.tr,
                    style: TextStyle(
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.colorPrimaryLight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'privacy_intro'.tr,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'information_collect'.tr,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'create_maintain'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'provide_access'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'personalize_exp'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'communicate'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'improve'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'sharing_info'.tr,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'we_dont_sell'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'we_may_share'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'we_may_share2'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'security'.tr,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'reasonable'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'change_policy'.tr,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'we_may_update'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'contact_us'.tr,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\u2022",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'question'.tr,
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'effective_date'.tr,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
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