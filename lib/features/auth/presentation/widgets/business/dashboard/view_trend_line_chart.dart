import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/deshboard_model.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/styles.dart';

// class ViewsTrendLineChart extends StatelessWidget {
//   const ViewsTrendLineChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return fl.LineChart(
//       fl.LineChartData(
//         lineBarsData: [
//           fl.LineChartBarData(
//             spots: [
//               fl.FlSpot(0, 1),  // January
//               fl.FlSpot(1, 2),  // February
//               fl.FlSpot(2, 3),  // March
//               fl.FlSpot(3, 5),  // April (peak)
//               fl.FlSpot(4, 2),  // May
//             ],
//             isCurved: true,
//             color: AppColors.white,
//             barWidth: 2,
//             belowBarData: fl.BarAreaData(
//               show: true,
//               color: AppColors.primary.withOpacity(0.2),
//             ),
//             dotData: fl.FlDotData(
//               show: true,
//               getDotPainter: (spot, percent, barData, index) {
//                 if (index == 3) {
//                   return fl.FlDotCirclePainter(
//                     radius: 6,
//                     color: AppColors.primary,
//                     strokeWidth: 2,
//                     strokeColor: Colors.white,
//                   );
//                 }
//                 return fl.FlDotCirclePainter(radius: 0);
//               },
//             ),
//           ),
//         ],
//         gridData: fl.FlGridData(
//           show: false,
//         ),
//         titlesData: fl.FlTitlesData(
//           leftTitles: fl.AxisTitles(
//             sideTitles: fl.SideTitles(showTitles: false),
//           ),
//           rightTitles: fl.AxisTitles(
//             sideTitles: fl.SideTitles(showTitles: false),
//           ),
//           topTitles: fl.AxisTitles(
//             sideTitles: fl.SideTitles(showTitles: false),
//           ),
//           bottomTitles: fl.AxisTitles(
//             sideTitles: fl.SideTitles(
//               showTitles: true,
//               reservedSize: 30,
//               getTitlesWidget: (value, meta) {

//                 // Only show months for the first index of each month
//                 switch (value.toInt()) {
//                   case 0:
//                     return Text('JAN', style: styleForNormalText.copyWith(fontSize: 14));
//                   case 1:
//                     return Text('FEB',style: styleForNormalText.copyWith(fontSize: 14));
//                   case 2:
//                     return Text('MAR', style: styleForNormalText.copyWith(fontSize: 14));
//                   case 3:
//                     return Text('APR',style: styleForNormalText.copyWith(fontSize: 14));
//                   case 4:
//                     return Text('MAY', style: styleForNormalText.copyWith(fontSize: 14));
//                   default:
//                     return Container(); // Empty for any other index
//                 }
//               },
//             ),
//           ),
//         ),
//         borderData: fl.FlBorderData(show: false),
//         extraLinesData: fl.ExtraLinesData(
//           verticalLines: [
//             for (int i = 0; i < 5; i++)
//               fl.VerticalLine(
//                 x: i.toDouble(),
//                 color: Colors.grey,
//                 strokeWidth: 1,
//                 dashArray: [5, 5],
//               ),
//           ],
//         ),
//         minX: 0,
//         maxX: 4,
//         minY: 0,
//         maxY: 6,
//       ),
//     );
//   }
// }

class ViewsTrendLineChart extends StatelessWidget {
  final List<MonthlyView> monthlyViews;

  const ViewsTrendLineChart({super.key, required this.monthlyViews});

  @override
  Widget build(BuildContext context) {
    // Convert MonthlyView objects to FlSpot list
    final List<fl.FlSpot> spots = [];
    for (int i = 0; i < monthlyViews.length; i++) {
      spots.add(fl.FlSpot(i.toDouble(), monthlyViews[i].totalViews.toDouble()));
    }

    // Find peak (highest view) to highlight
    int peakIndex = 0;
    double maxViews = 0;
    for (int i = 0; i < spots.length; i++) {
      if (spots[i].y > maxViews) {
        maxViews = spots[i].y;
        peakIndex = i;
      }
    }

    return fl.LineChart(
      fl.LineChartData(
        lineBarsData: [
          fl.LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.white,
            barWidth: 2,
            belowBarData: fl.BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.2),
            ),
            dotData: fl.FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                if (index == peakIndex) {
                  return fl.FlDotCirclePainter(
                    radius: 6,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return fl.FlDotCirclePainter(radius: 0);
              },
            ),
          ),
        ],
        gridData: fl.FlGridData(show: false),
        titlesData: fl.FlTitlesData(
          leftTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          rightTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          topTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          bottomTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < monthlyViews.length) {
                  final month = monthlyViews[index].month;
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      month.substring(0, 3).toUpperCase(),
                      style: styleForNormalText.copyWith(fontSize: 12),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
        borderData: fl.FlBorderData(show: false),
        extraLinesData: fl.ExtraLinesData(
          verticalLines: [
            for (int i = 0; i < monthlyViews.length; i++)
              fl.VerticalLine(
                x: i.toDouble(),
                color: Colors.grey,
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
          ],
        ),
        minX: 0,
        maxX: monthlyViews.length - 1,
        minY: 0,
        maxY: (maxViews * 1.2).clamp(6, double.infinity),
      ),
    );
  }
}
