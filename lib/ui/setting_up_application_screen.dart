// import 'dart:math' as Math;

// import 'package:flutter/material.dart';
// // import 'package:flutter_circular_chart/flutter_circular_chart.dart';

// class SettingUpApplicationScreen extends StatefulWidget {
//   @override
//   _SettingUpApplicationScreenState createState() =>
//       _SettingUpApplicationScreenState();
// }

// class _SettingUpApplicationScreenState extends State<SettingUpApplicationScreen>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;

//   final GlobalKey<AnimatedCircularChartState> _chartKey =
//       GlobalKey<AnimatedCircularChartState>();
//   final _chartSize = const Size(100.0, 100.0);
//   final Math.Random random = Math.Random();
//   List<CircularStackEntry> data;

//   double value = 50.0;
//   Color labelColor = Colors.blue[200];

//   @override
//   void initState() {
//     _controller = AnimationController(vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _increment() {
//     setState(() {
//       value += 10;
//       List<CircularStackEntry> data = _generateChartData(value);
//       _chartKey.currentState.updateData(data);
//     });
//   }

//   void _decrement() {
//     setState(() {
//       value -= 10;
//       List<CircularStackEntry> data = _generateChartData(value);
//       _chartKey.currentState.updateData(data);
//     });
//   }

//   List<CircularStackEntry> _generateChartData(double value) {
//     Color dialColor = Colors.blue[200];
//     if (value < 0) {
//       dialColor = Colors.red[200];
//     } else if (value < 50) {
//       dialColor = Colors.yellow[200];
//     }
//     labelColor = dialColor;

//     List<CircularStackEntry> data = <CircularStackEntry>[
//       CircularStackEntry(
//         <CircularSegmentEntry>[
//           CircularSegmentEntry(
//             value,
//             dialColor,
//             rankKey: 'percentage',
//           )
//         ],
//         rankKey: 'percentage',
//       ),
//     ];

//     if (value > 100) {
//       labelColor = Colors.green[200];

//       data.add(CircularStackEntry(
//         <CircularSegmentEntry>[
//           CircularSegmentEntry(
//             value - 100,
//             Colors.green[200],
//             rankKey: 'percentage',
//           ),
//         ],
//         rankKey: 'percentage2',
//       ));
//     }

//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextStyle _labelStyle =
//         Theme.of(context).textTheme.title.merge(TextStyle(color: labelColor));

//     return Scaffold(
//       body: Center(
//         child: AnimatedCircularChart(
//           key: _chartKey,
//           size: _chartSize,
//           initialChartData: _generateChartData(value),
//           chartType: CircularChartType.Radial,
//           edgeStyle: SegmentEdgeStyle.round,
//           percentageValues: false,
//           holeLabel: '$value%',
//           labelStyle: _labelStyle,
//         ),
//       ),
//     );
//   }
// }
