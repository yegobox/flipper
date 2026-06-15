import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';

class FloBarChart extends StatelessWidget {
  const FloBarChart({super.key, required this.data});

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    final maxVal = data
        .map((d) => (d['value'] as num?)?.toDouble().abs() ?? 0)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.15,
          minY: -maxVal * 0.15,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      data[i]['label']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        color: FloTheme.ink3,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: (data[i]['value'] as num?)?.toDouble() ?? 0,
                    color: _toneColor(data[i]['tone']?.toString()),
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _toneColor(String? tone) {
    switch (tone) {
      case 'gain':
        return FloTheme.gain;
      case 'loss':
        return FloTheme.loss;
      default:
        return FloTheme.blue;
    }
  }
}

class FloAreaChart extends StatelessWidget {
  const FloAreaChart({
    super.key,
    required this.points,
    required this.labels,
    this.peak = 0,
  });

  final List<num> points;
  final List<String> labels;
  final int peak;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].toDouble()),
    ];
    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                  return Text(
                    labels[i],
                    style: const TextStyle(fontSize: 10, color: FloTheme.ink3),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: FloTheme.blue,
              barWidth: 2,
              dotData: FlDotData(
                getDotPainter: (spot, _, __, ___) {
                  final isPeak = spot.x.toInt() == peak;
                  return FlDotCirclePainter(
                    radius: isPeak ? 4 : 0,
                    color: FloTheme.blue,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: FloTheme.blue.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
