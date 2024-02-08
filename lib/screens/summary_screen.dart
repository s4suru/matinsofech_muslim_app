import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../bar graph/bar_graph.dart';
import '../colors.dart';
import '../provider/zikir_provider.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;

  void _onButtonTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  List<String> leftNumbers = ['1000', '800', '600', '400', '200', '0'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body :Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/secondary_background.png"),
                fit: BoxFit.fill,
              )
          ),
          child: Stack(
            children: <Widget>[
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(height: 150.h,),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0,right: 24.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 200.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [AppColors.colorGradient2Start, AppColors.colorGradient2End],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 130.h,
                                          width: 40.w,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: leftNumbers.length,
                                              itemBuilder: (BuildContext context, int index){
                                                return SizedBox(
                                                    height: 22.h,
                                                    child: Text(leftNumbers[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp
                                                      ),));
                                              }
                                          ),
                                        ),
                                        FutureBuilder<List<int>>(
                                          future: ZikirProvider().getLast7DaysTotalCounts(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final last7DaysTotalCounts = snapshot.data!;
                                              //final weeklySummary = last7DaysTotalCounts?.map((count) => count.toDouble()).toList();
                                              return SizedBox(
                                                  height: 130.h,
                                                  width: 200.w,
                                                  child: BarGraph(
                                                    weeklySummary: last7DaysTotalCounts
                                                        .map((count) => count != null ? (count > 1000 ? 1000.0 : count.toDouble()) : 0.0)
                                                        .toList(),
                                                  )
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text('Error: ${snapshot.error}'),
                                              );
                                            } else {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                child: const Center(child: Text('Not Available!!',style: TextStyle(color: Colors.white),),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 150.h,),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0,right: 24.0),
                          child: Container(
                            height: 340.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [AppColors.colorGradient2Start, AppColors.colorGradient2End],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('yyyy/MM/dd').format(DateTime.now()),
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.linear_scale,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy/MM/dd').format(DateTime.now()),
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],),
                                SizedBox(height: 20.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 130.h,
                                      width: 40.w,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: leftNumbers.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return SizedBox(
                                                height: 22.h,
                                                child: Text(leftNumbers[index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp
                                                  ),));
                                          }
                                      ),
                                    ),
                                    FutureBuilder<List<int>>(
                                      future: ZikirProvider().getLast7DaysTotalCounts(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final last7DaysTotalCounts = snapshot.data!;
                                          //final weeklySummary = last7DaysTotalCounts?.map((count) => count.toDouble()).toList();
                                          return SizedBox(
                                              height: 130.h,
                                              width: 200.w,
                                              child: BarGraph(
                                                weeklySummary: last7DaysTotalCounts
                                                    .map((count) => count != null ? (count > 1000 ? 1000.0 : count.toDouble()) : 0.0)
                                                    .toList(),
                                              )
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text('Error: ${snapshot.error}'),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.h,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(Icons.access_time,color: Colors.white,),
                                              ),
                                              Text(
                                                'total_count'.tr,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                ),)
                                            ],
                                          ),
                                          FutureBuilder<int>(
                                            future: Provider.of<ZikirProvider>(context).getTotalCountLast7Days(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else {
                                                int totalCount = snapshot.data ?? 0;
                                                return Text(
                                                  totalCount.toString(),
                                                  style: TextStyle(
                                                      fontSize: 36.sp,
                                                      color: AppColors.colorAlert,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 40.w,),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(Icons.access_time,color: Colors.white,),
                                              ),
                                              Text( 'daily_count'.tr,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                ),)
                                            ],
                                          ),
                                          FutureBuilder<int>(
                                            future: Provider.of<ZikirProvider>(context).getTotalCountLast7Days(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else {
                                                int totalCount = snapshot.data ?? 0;
                                                return Text(
                                                  (totalCount/7).toInt().toString(),
                                                  style: TextStyle(
                                                      fontSize: 36.sp,
                                                      color: AppColors.colorAlert,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 150.h,),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0,right: 24.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 200.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [AppColors.colorGradient2Start, AppColors.colorGradient2End],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 130.h,
                                          width: 40.w,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: leftNumbers.length,
                                              itemBuilder: (BuildContext context, int index){
                                                return SizedBox(
                                                    height: 22.h,
                                                    child: Text(leftNumbers[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp
                                                      ),));
                                              }
                                          ),
                                        ),
                                        FutureBuilder<List<int>>(
                                          future: ZikirProvider().getLast7DaysTotalCounts(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final last7DaysTotalCounts = snapshot.data!;
                                              //final weeklySummary = last7DaysTotalCounts?.map((count) => count.toDouble()).toList();
                                              return SizedBox(
                                                  height: 130.h,
                                                  width: 200.w,
                                                  child: BarGraph(
                                                    weeklySummary: last7DaysTotalCounts
                                                        .map((count) => count != null ? (count > 1000 ? 1000.0 : count.toDouble()) : 0.0)
                                                        .toList(),
                                                  )
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text('Error: ${snapshot.error}'),
                                              );
                                            } else {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                child: const Center(child: Text('Not Available!!',style: TextStyle(color: Colors.white),),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 150.h,),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0,right: 24.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 200.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [AppColors.colorGradient2Start, AppColors.colorGradient2End],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 130.h,
                                          width: 40.w,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: leftNumbers.length,
                                              itemBuilder: (BuildContext context, int index){
                                                return SizedBox(
                                                    height: 22.h,
                                                    child: Text(leftNumbers[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp
                                                      ),));
                                              }
                                          ),
                                        ),
                                        FutureBuilder<List<int>>(
                                          future: ZikirProvider().getLast7DaysTotalCounts(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final last7DaysTotalCounts = snapshot.data!;
                                              //final weeklySummary = last7DaysTotalCounts?.map((count) => count.toDouble()).toList();
                                              return SizedBox(
                                                  height: 130.h,
                                                  width: 200.w,
                                                  child: BarGraph(
                                                    weeklySummary: last7DaysTotalCounts
                                                        .map((count) => count != null ? (count > 1000 ? 1000.0 : count.toDouble()) : 0.0)
                                                        .toList(),
                                                  )
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text('Error: ${snapshot.error}'),
                                              );
                                            } else {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                child: const Center(child: Text('Not Available!!',style: TextStyle(color: Colors.white),),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  top: 45.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0,right: 12),
                        child: Text(
                          'counter_summery'.tr,
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
                top: 90.h,
                left: 26.w,
                right: 26.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){_onButtonTapped(0);},
                      child: Container(
                        height: 35.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _currentIndex == 0 ? AppColors.colorAlert : Colors.white),
                        child:  Center(child: Text(
                          'all'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: (){_onButtonTapped(1);},
                      child: Container(
                        height: 35.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _currentIndex == 1 ? AppColors.colorAlert : Colors.white),
                        child:  Center(child: Text(
                          'week'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: (){_onButtonTapped(2);},
                      child: Container(
                        height: 35.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _currentIndex == 2 ? AppColors.colorAlert : Colors.white),
                        child:  Center(child: Text(
                          'month'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: (){_onButtonTapped(3);},
                      child: Container(
                        height: 35.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _currentIndex == 3 ? AppColors.colorAlert : Colors.white),
                        child:  Center(child: Text(
                          'year'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
