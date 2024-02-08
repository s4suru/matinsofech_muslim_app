import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../colors.dart';
import '../models/alquran_surah_model.dart';

class SurahListPage extends StatefulWidget {
  final int index;
  final String surahNameAr, surahNameEn;
  const SurahListPage({super.key, required this.index, required this.surahNameAr, required this.surahNameEn});

  @override
  _SurahListPageState createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  List<Verses>? versesList;

  Future<void> fetchSurahData() async {
    final response = await http.get(Uri.parse('https://api.quran.gading.dev/surah/${widget.index+1}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = AlQuranSurahModel.fromJson(jsonData);

      setState(() {
        versesList = data.data?.verses;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSurahData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/secondary_background.png"),
            fit: BoxFit.fill,
          ),
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
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      children: [
                        Text(
                          widget.surahNameEn,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Text(
                          '(${widget.surahNameAr})',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp
                          ),
                        ),
                      ],
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
                  child: versesList == null
                      ?  Center(child: Center(
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
                      )))
                      : ListView.builder(
                    itemCount: versesList!.length,
                    itemBuilder: (context, index) {
                      final verse = versesList![index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                                verse.text?.arab ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp
                              ),
                            ),
                            subtitle: Text(
                                verse.translation?.en ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h,)
                        ],
                      );
                    },
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}
