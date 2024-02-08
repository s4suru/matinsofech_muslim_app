import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tasbih/colors.dart';
import 'package:tasbih/screens/surah_page.dart';

import '../models/surah_list_model.dart';

class SurahListScreen extends StatefulWidget {
  @override
  _SurahListScreenState createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  List<Data> surahList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.quran.gading.dev/surah'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final surahListModel = SurahListModel.fromJson(jsonResponse);

      setState(() {
        surahList = surahListModel.data ?? [];
        isLoading = false;
      });
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg",),
            fit: BoxFit.cover,
            
            
          ),
          // color: Color(0xffD2FED9)
        ),
        child: Stack(
          children: [
            Positioned(
              top: 45.h,
              left: 20.w,
              right: 16.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 20, 19, 19),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Text(
                      'alquran'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 23, 22, 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 70.h,
              left: 8.w,
              right: 8.w,
              child: Container(
                height: 700.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListView.builder(
                  itemCount: surahList.length,
                  itemBuilder: (context, index) {
                    final surah = surahList[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SurahListPage(
                                          index: index,
                                          surahNameAr: surah.name!.long!,
                                          surahNameEn: surah.name!.transliteration!.en!,
                                        )));
                          },
                          child: Container(
                            height: 64.h,
                            width: 328.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 37, 39, 38),
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 45.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  color: Color.fromARGB(255, 97, 255, 181),
                                ),
                                child: Center(
                                  child: Text(
                                      surah.number.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                surah.name?.long ?? '',
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              subtitle: Text(
                                  surah.name?.transliteration?.en ?? '',
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            if (isLoading)
               Center(
                child: Center(
                    child: Container(
                      height: 96,
                      width: 96,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: AppColors.colorPrimaryDark,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                    ))
              ),
          ],
        ),
      ),
    );
  }
}
