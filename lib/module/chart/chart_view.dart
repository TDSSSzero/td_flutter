import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/pages.dart';
import 'chart_logic.dart';

class ChartPage extends StatelessWidget {
  ChartPage({Key? key}) : super(key: key);

  final logic = Get.put(ChartLogic());
  final state = Get.find<ChartLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 400,
              child: LineChart(
                LineChartData(
                  //轴线data
                    titlesData: FlTitlesData(

                    ),
                    //网格data
                    gridData: FlGridData(
                      horizontalInterval: 1,
                      verticalInterval: 1,
                      drawVerticalLine: false,
                      drawHorizontalLine: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [FlSpot(1, 1),FlSpot(1.5, 1.5),FlSpot(1.8, 1.5),FlSpot(2, 1.2),FlSpot(5, 1.2),],
                        barWidth: 5,
                        // isCurved: true,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: false
                        ),
                      ),
                    ]
                  // read about it in the LineChartData section
                ),
                swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear, // Optional
              ),
            ),
          ],
        ),
      ),
    );
  }
}
