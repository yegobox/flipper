// import 'package:ant_icons/ant_icons.dart';
// import 'package:feather_icons/feather_icons.dart';
// import 'package:flipper_models/isar_models.dart';
// import 'package:flipper_dashboard/customappbar.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';

// import 'package:stacked/stacked.dart';
//
// import 'analytics/lineF.dart';

// // ignore: use_key_in_widget_constructors
// class Analytics extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var currentWidth = MediaQuery.of(context).size.width;
//     var extraLargeScreenGrid = currentWidth > 1536;
//     var tabScreenGrid = currentWidth > 769;

//     return Scaffold(
//       appBar: CustomAppBar(
//         onPop: () async {
//           _routerService.pop();
//         },
//         title: 'Analytics',
//         disableButton: false,
//         showActionButton: false,
//         onPressedCallback: () async {},
//         rightActionButtonName: 'Save',
//         icon: Icons.close,
//         multi: 3,
//         bottomSpacer: 50,
//       ),
//       body: ViewModelBuilder<AnalyticViewModel>.reactive(
//         viewModelBuilder: () => AnalyticViewModel(),
//         onViewModelReady: (model) {
//           model.analytic.countLifeTimeCustomers();
//           model.analytic.countOrdersByThisWeek();
//         },
//         builder: (context, model, child) {
//           return ListView(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(
//                   left: 2,
//                   top: 1,
//                   right: 2,
//                   bottom: 2,
//                 ),
//                 child: GridView.count(
//                   crossAxisCount: extraLargeScreenGrid
//                       ? 4
//                       : tabScreenGrid
//                           ? 2
//                           : 1,
//                   childAspectRatio: 3.5,
//                   mainAxisSpacing: 2.0,
//                   crossAxisSpacing: 20.0,
//                   padding: const EdgeInsets.all(02.0),
//                   shrinkWrap: true,
//                   children: [
//                     Container(
//                       color: Colors.blue[300],
//                       height: 120,
//                       padding: const EdgeInsets.all(0.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: const Text(
//                                         'Revenue',
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: Text(
//                                         'RWF' +
//                                             model.analytic.revenue.toString(),
//                                         style: const TextStyle(
//                                           fontSize: 40,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 120,
//                             height: 120,
//                             child: Icon(
//                               AntIcons.dollar,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       color: Colors.red[300],
//                       height: 120,
//                       padding: const EdgeInsets.all(0.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: const Text(
//                                         'Total Orders',
//                                         style: TextStyle(
//                                           fontSize: 15.0,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: Text(
//                                         model.analytic.orders.length.toString(),
//                                         style: const TextStyle(
//                                           fontSize: 40,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 120,
//                             height: 120,
//                             child: Icon(
//                               FeatherIcons.tag,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       color: Colors.indigo[300],
//                       height: 120,
//                       padding: const EdgeInsets.all(0.0),
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(
//                           border:
//                               Border.all(color: Colors.black12, width: 01.0),
//                           borderRadius: BorderRadius.circular(03.0),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         padding:
//                                             const EdgeInsets.only(left: 15),
//                                         child: const Text(
//                                           'Customers',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         padding:
//                                             const EdgeInsets.only(left: 15),
//                                         child: Text(
//                                           model.analytic.customers.toString(),
//                                           style: const TextStyle(
//                                             fontSize: 40,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 120,
//                               height: 120,
//                               child: Icon(
//                                 Ionicons.people_outline,
//                                 size: 50,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               LineF(
//                 xValues: model.analytic.groupedData,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
