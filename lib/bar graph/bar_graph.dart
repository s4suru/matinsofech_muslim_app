import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tasbih/colors.dart';

import 'bar_data.dart';

class BarGraph extends StatelessWidget {
  final List weeklySummary;
  const BarGraph({Key? key, required this.weeklySummary}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    BarData barData = BarData(
        sunAmount: weeklySummary[0],
        monAmount: weeklySummary[1],
        tueAmount: weeklySummary[2],
        wedAmount: weeklySummary[3],
        thuAmount: weeklySummary[4],
        friAmount: weeklySummary[5],
        satAmount: weeklySummary[6]
    );
    barData.initializeBarData();
    return BarChart(
        BarChartData(
            maxY: 1000,
            minY: 0,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getBottomTitles
                  )),
            ),
            barGroups: barData.barData.map((data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: Colors.white,
                      width: 15,
                      borderRadius: BorderRadius.circular(24),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 1000,
                        color: AppColors.colorPrimary,
                      )

                  )
                ]
            )).toList()
        )
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta){

  const style = TextStyle(
      color: Colors.white,
      fontSize: 10
  );

  Widget text;
  switch(value.toInt()) {
    case 0 :
      text = Text(DateFormat('EEEE').format(DateTime.now().subtract(Duration(days: 6))).substring(0, 3), style: style,);
      break;
    case 1 :
      text = Text(DateFormat('EEEE').format(DateTime.now().subtract(Duration(days: 5))).substring(0, 3), style: style,);
      break;
    case 2 :
      text = Text(DateFormat('EEEE').format(DateTime.now().subtract(Duration(days: 4))).substring(0, 3), style: style,);
      break;
    case 3 :
      text = Text(DateFormat('EEEE').format(DateTime.now().subtract(Duration(days: 3))).substring(0, 3), style: style,);
      break;
    case 4 :
      text = Text(DateFormat('EEEE').format(DateTime.now().subtract(Duration(days: 2))).substring(0, 3), style: style,);
      break;
    case 5 :
      text = Text(DateFormat('EEEE').format(DateTime.now().subtract(Duration(days: 1))).substring(0, 3), style: style,);
      break;
    case 6 :
      text = Text(DateFormat('EEEE').format(DateTime.now()).substring(0, 3), style: TextStyle(color: AppColors.colorAlert,fontSize: 10.sp),);
      break;
    default :
      text = Text(DateFormat('EEEE').format(DateTime.now()).substring(0, 3), style: style,);
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}