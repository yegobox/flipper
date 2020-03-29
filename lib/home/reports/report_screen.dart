import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/reports/report_view.dart';
import 'package:flipper/home/reports/tabs.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

//TODO: work on report
class _ReportScreenState extends State<ReportScreen> {
  double tabLenght = 50.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Router.navigator.pop();
            },
            title: 'Report',
            disableButton: false,
            showActionButton: true,
            onPressedCallback: () async {},
            actionButtonName: 'save',
            action: Container(
              width: double.infinity,
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        Router.navigator.pushNamed(Router.dateScreen);
                      },
                      child: Text("From Date"),
                    ),
                  ),
                  Tabs(tabLenght: tabLenght)
                ],
              ),
            ),
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 146,
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
