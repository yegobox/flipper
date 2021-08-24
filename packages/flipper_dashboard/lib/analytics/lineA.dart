import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';

class Line extends StatefulWidget {
  const Line({Key? key}) : super(key: key);

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);

    final items = [barGroup1];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(04.0),
        color: purpleDark,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: BarChart(
            // start stealing the code
            BarChartData(
              maxY: 20,
              barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey,
                    getTooltipItem: (_a, _b, _c, _d) => null,
                  ),
                  touchCallback: (response) {
                    if (response.spot == null) {
                      setState(() {
                        touchedGroupIndex = -1;
                        showingBarGroups = List.of(rawBarGroups);
                      });
                      return;
                    }

                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                    setState(() {
                      if (response.touchInput is PointerExitEvent ||
                          response.touchInput is PointerUpEvent) {
                        touchedGroupIndex = -1;
                        showingBarGroups = List.of(rawBarGroups);
                      } else {
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (var rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.y;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(y: avg);
                            }).toList(),
                          );
                        }
                      }
                    });
                  }),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  margin: 20,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mn';
                      case 1:
                        return 'Te';
                      case 2:
                        return 'Wd';
                      case 3:
                        return 'Tu';
                      case 4:
                        return 'Fr';
                      case 5:
                        return 'St';
                      case 6:
                        return 'Sn';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Color(0xff7589a2),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  margin: 20,
                  reservedSize: 14,
                  getTitles: (value) {
                    if (value == 0) {
                      return '1K';
                    } else if (value == 10) {
                      return '5K';
                    } else if (value == 19) {
                      return '10K';
                    } else {
                      return '';
                    }
                  },
                ),
              ),
              borderData: FlBorderData(
                show: true,
              ),
              barGroups: showingBarGroups,
            ),
          ),
        ),
      ),
    );
  }
}
