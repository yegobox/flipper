import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/reports/report_view.dart';
import 'package:flipper/home/reports/tabs.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  double tabLenght = 50.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: CommonAppBar(
            onPop: () {},
            title: 'Report',
            disableButton: false,
            showActionButton: true,
            onPressedCallback: () async {},
            actionButtonName: 'save',
            action: Container(
              width: double.infinity,
              child: Tabs(tabLenght: tabLenght),
            ),
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 96,
          ),
          body: TabBarView(
            children: [
              ReportView(),
              ReportView(),
              ReportView(),
              ReportView(),
              ReportView(),
            ],
          ),
        ),
      ),
    );
  }
}
