import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../colors.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage("assets/images/secondary_background.png"),
                      fit: BoxFit.fill)),
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
                          'donation'.tr,
                          style: TextStyle(
                              color: AppColors.colorWhiteHighEmp,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.colorPrimaryLight),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'donation_text'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.colorWhiteMidEmp,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/donationWhite.svg',
                                height: 14.h),
                            SizedBox(width: 8.w),
                            Text(
                              "017XXXXXXXX",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: AppColors.colorWhiteMidEmp,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  //   margin: const EdgeInsets.only(left: 16, right: 16),
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(24),
                  //       color: AppColors.colorPrimaryDark),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "To Support Us",
                  //         textAlign: TextAlign.justify,
                  //         style: TextStyle(
                  //             color: AppColors.colorWhiteHighEmp,
                  //             fontSize: 20.sp,
                  //             fontWeight: FontWeight.w600),
                  //       ),
                  //       SizedBox(height: 16.h),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 16, horizontal: 16),
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(24),
                  //             color: AppColors.colorPrimaryLight),
                  //         child: Row(children: const [
                  //           Icon(
                  //             Icons.account_balance,
                  //             color: AppColors.colorWhiteHighEmp,
                  //           ),
                  //           SizedBox(width: 16),
                  //           Text(
                  //             "Bank Transfer",
                  //             style: TextStyle(
                  //                 color: AppColors.colorWhiteHighEmp,
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //         ]),
                  //       ),
                  //       SizedBox(height: 16.h),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 16, horizontal: 16),
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(24),
                  //             color: AppColors.colorPrimaryLight),
                  //         child: Row(children: const [
                  //           Icon(
                  //             Icons.coffee,
                  //             color: AppColors.colorWhiteHighEmp,
                  //           ),
                  //           SizedBox(width: 16),
                  //           Text(
                  //             "Buy Me  a Coffee",
                  //             style: TextStyle(
                  //                 color: AppColors.colorWhiteHighEmp,
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //         ]),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            //   child: Container(
            //     color: Colors.black.withOpacity(0.3),
            //   ),
            // ),
            // Center(
            //   child: Container(
            //     height: 200.h,
            //     width: 200.w,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(24)
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Image.asset(
            //           "assets/images/donation.png",
            //           height: 50.h,
            //           width: 50.w,
            //         ),
            //         SizedBox(height: 10.h,),
            //         const Text('Upcoming feature',textAlign: TextAlign.center,),
            //         SizedBox(height: 10.h,),
            //         InkWell(
            //           onTap: (){
            //             Navigator.pop(context);
            //           },
            //           child: Container(
            //             height: 50.h,
            //             width: double.infinity,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children:  [
            //                 Icon(Icons.arrow_back,size: 14,color: AppColors.colorAlert),
            //                 SizedBox(width: 4.w,),
            //                 Text('Go Back',style: TextStyle(color: AppColors.colorAlert),),
            //               ],
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
