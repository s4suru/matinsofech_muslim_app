import 'package:flutter/material.dart';

import '../bar graph/bar_graph.dart';
import '../provider/zikir_provider.dart';

class Last7DaysTotalCounts extends StatelessWidget {

  List<double> weeklySummary = [
    2.25,
    5.65,
    5.48,
    120.56,
    78.6,
    74.2,
    59.3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last 7 Days Total Counts'),
      ),
      body: FutureBuilder<List<int>>(
        future: ZikirProvider().getLast7DaysTotalCounts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final last7DaysTotalCounts = snapshot.data!;
            //final weeklySummary = last7DaysTotalCounts?.map((count) => count.toDouble()).toList();
            return Center(
              child: SizedBox(
                height: 400,
                child: BarGraph(
                  weeklySummary: last7DaysTotalCounts
                      .map((count) => count != null ? count.toDouble() : 0.0)
                      .toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}