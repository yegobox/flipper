// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_ui/google_ui.dart';

// import 'custom_tab.dart';
// import 'data/report_mock.dart';
// import 'page/sortable_page.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   static const String title = 'Daily Report';

//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: GThemeGenerator.generate(),
//         darkTheme: GThemeGenerator.generateDark(),
//         title: title,
//         home: const MainPage(),
//       );
// }

// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   // @override
//   // Widget build(BuildContext context) => Scaffold(body: CustomTabs());
//   // @override
//   // Widget build(BuildContext context) => TabBarWidget(
//   //       title: MyApp.title,
//   //       tabs: const [
//   //         Tab(icon: Icon(Icons.sort_by_alpha), text: 'Report'),
//   //       ],
//   //       children: [
//   //         SortablePage(),
//   //       ],
//   //     );
//   @override
//   Widget build(BuildContext context) => SortablePage(
//         columns: const [
//           'Item',
//           'price',
//           'Discount',
//           'Stock',
//           'Payment',
//           'Date'
//         ],
//         data: List.of(reports),
//       );
//   // Widget build(BuildContext context) => GErrorMessage(
//   //       icon: const Icon(Icons.wifi_off_outlined),
//   //       title: "No internet",
//   //       subtitle:
//   //           "Can't connect to the internet.\nPlease check your internet connection",
//   //       onPressed: () {},
//   //     );
// }
