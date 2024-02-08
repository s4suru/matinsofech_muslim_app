import 'package:flutter/material.dart';
import 'package:tasbih/helper/db_helper.dart';
import '../helper/helper_function.dart';
import '../models/zikir_db_model.dart';

class ZikirProvider extends ChangeNotifier {
  List<ZikirModel> zikirList = [];
  List<int> last7DaysTotalCounts = [];
  int LastWeekTotalCount = 0;

  Future<int> insertZikir(ZikirModel zikirModel) =>
      DbHelper.insertZikir(zikirModel);

  void getAllZikirs() async {
    zikirList = await DbHelper.getAllZikirs();
    notifyListeners();
  }

  Future<int> getTotalCount(String name) async {
    final dbHelper = DbHelper();
    return await dbHelper.getTotalCountByName(name);
  }


  Future<List<int>> getLast7DaysTotalCounts() async {
    for (int i = 6; i >=0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String formattedDate = getFormattedDate(date, 'dd/MM/yyyy');
      int totalCount = await DbHelper.getTotalCountByDate(formattedDate);
      last7DaysTotalCounts.add(totalCount);
    }
    return last7DaysTotalCounts;
  }

  Future<int> getTotalCountLast7Days() async {
    int totalCount = 0;
    for (int i = 0; i < 7; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String formattedDate = getFormattedDate(date, 'dd/MM/yyyy');
      int count = await DbHelper.getTotalCountByDate(formattedDate);
      totalCount += count??0;
    }
    LastWeekTotalCount = totalCount;
    return LastWeekTotalCount;
  }



}