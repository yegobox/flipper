// import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// class MapboxBackgroundUI extends StatefulWidget {
//   final Widget child;

//   const MapboxBackgroundUI({
//     Key? key,
//     required this.child,
//   }) : super(key: key);

//   @override
//   _MapboxBackgroundUIState createState() => _MapboxBackgroundUIState();
// }

// class _MapboxBackgroundUIState extends State<MapboxBackgroundUI> {
//   MapboxMap? mapboxMap;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           MapWidget(
//             key: ValueKey("mapWidget"),
//             onMapCreated: _onMapCreated,
//           ),
//           SafeArea(
//             child: widget.child,
//           ),
//         ],
//       ),
//     );
//   }

//   void _onMapCreated(MapboxMap mapboxMap) {
//     this.mapboxMap = mapboxMap;
//     mapboxMap.setCamera(
//       CameraOptions(
//           center: Point(coordinates: Position(-98.0, 39.5)),
//           zoom: 2,
//           bearing: 0,
//           pitch: 0),
//     );
//   }
// }

// // Usage:
// // MapboxBackgroundUI(
// //   targetDateTime: DateTime.now().add(Duration(minutes: kDebugMode ? 2 : 10)),
// //   onCycleComplete: () {
// //     talker.warning("We have completed the order");
// //     Navigator.of(context).pop();
// //   },
// //   child: TimeSegmentUI(
// //     targetDateTime: DateTime.now().add(Duration(minutes: kDebugMode ? 2 : 10)),
// //     onCycleComplete: () {
// //       talker.warning("We have completed the order");
// //       Navigator.of(context).pop();
// //     },
// //   ),
// // )
