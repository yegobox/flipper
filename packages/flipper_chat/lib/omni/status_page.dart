import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  late PageController _pageController;
  ValueNotifier<double> currentPage = ValueNotifier<double>(0.0);
  ValueNotifier<int> indexHistory = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(updateCurrentPage);
  }

  updateCurrentPage() => currentPage.value = _pageController.page!;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: currentPage,
      builder: (_, value, __) {
        return Text('Text');
        // return PageView.builder(
        //   itemCount: DataW.listHistory.length,
        //   controller: _pageController,
        //   physics: const BouncingScrollPhysics(),
        //   onPageChanged: (val) => indexHistory.value = 0,
        //   itemBuilder: (_, index) {
        //     if (_pageController.position.haveDimensions == false) {
        //       currentPage.value = index.toDouble();
        //     } else {
        //       currentPage.value = _pageController.page!;
        //     }
        //     final history = DataW.listHistory[index];
        //     return HistorysContainer(
        //       index: index,
        //       pageNotifier: value,
        //       child: Stack(
        //         children: [
        //           //---------------------
        //           // POST IMAGES OF USER
        //           //---------------------
        //           LayoutBuilder(
        //             builder: (_, constraints) => ValueListenableBuilder<int>(
        //               valueListenable: indexHistory,
        //               builder: (_, valueIH, __) {
        //                 return RepaintBoundary(
        //                   child: IndexedStack(
        //                     index: valueIH,
        //                     alignment: Alignment.center,
        //                     children: [
        //                       ...List.generate(
        //                         history.posts.length,
        //                         (indexImg) => Image.asset(
        //                           history.posts[indexImg],
        //                           gaplessPlayback: true,
        //                           alignment: Alignment.center,
        //                           fit: BoxFit.fitHeight,
        //                           height: constraints.maxHeight,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //           //---------------------
        //           //SHADOW TOP
        //           //---------------------
        //           Container(
        //             height: 80,
        //             decoration: BoxDecoration(
        //               gradient: LinearGradient(
        //                 colors: [
        //                   Helpers.principalColor.withOpacity(0.70),
        //                   Colors.transparent
        //                 ],
        //                 begin: Alignment.topCenter,
        //                 end: Alignment.bottomCenter,
        //               ),
        //             ),
        //           ),
        //           //---------------------
        //           //SHADOW BUTTON
        //           //---------------------
        //           Positioned(
        //             bottom: 0,
        //             left: 0,
        //             right: 0,
        //             child: Container(
        //               height: 80,
        //               decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //                   colors: [
        //                     Helpers.principalColor.withOpacity(0.70),
        //                     Colors.transparent
        //                   ],
        //                   begin: Alignment.bottomCenter,
        //                   end: Alignment.topCenter,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           //---------------------
        //           // HISTORIES LINES
        //           //---------------------
        //           HistoryLine(
        //             numPost: history.posts.length,
        //             color: Colors.white,
        //           ),
        //           //---------------------
        //           // USER INFO
        //           //---------------------
        //           Positioned(
        //             top: 5,
        //             left: 0,
        //             right: 0,
        //             child: Container(
        //               height: kToolbarHeight,
        //               padding: const EdgeInsets.symmetric(horizontal: 10),
        //               child: Row(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 children: [
        //                   CircleAvatar(
        //                     backgroundColor: Helpers.greyLigthColor,
        //                     backgroundImage:
        //                         AssetImage(history.user.imgProfile),
        //                   ),
        //                   const SizedBox(width: 10),
        //                   Text(
        //                     '${history.user.name} ${history.user.surname}',
        //                     style: Helpers.txtDefault.copyWith(
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                   const SizedBox(width: 10),
        //                   Text(
        //                     '10 h',
        //                     style: Helpers.txtDefault.copyWith(
        //                       color: Colors.white,
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                   const Spacer(),
        //                   ButtonCircle(
        //                     onPressed: () {},
        //                     icon: Icons.more_vert,
        //                     backgroundColor: Colors.transparent,
        //                     iconColor: Colors.white,
        //                   )
        //                   // Icon(,color: COlors,)
        //                 ],
        //               ),
        //             ),
        //           ),
        //           //---------------------
        //           // TAP LEFT AND RIGTH
        //           //---------------------
        //           Positioned(
        //             right: 0,
        //             top: 0,
        //             bottom: 0,
        //             child: GestureDetector(
        //               onTap: () {
        //                 final view = indexHistory.value + 1;
        //                 indexHistory.value = view.clamp(
        //                   0,
        //                   history.posts.length - 1,
        //                 );
        //               },
        //               child: Container(
        //                 width: 70,
        //                 color: Helpers.greenColor.withOpacity(0.02),
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             left: 0,
        //             top: 0,
        //             bottom: 0,
        //             child: GestureDetector(
        //               onTap: () {
        //                 final view = indexHistory.value - 1;
        //                 indexHistory.value = view.clamp(
        //                   0,
        //                   history.posts.length - 1,
        //                 );
        //               },
        //               child: Container(
        //                 width: 70,
        //                 color: Helpers.greenColor.withOpacity(0.02),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
    );
  }
}
