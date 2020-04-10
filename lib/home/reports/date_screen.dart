import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/reports/date_widget/event.dart';
import 'package:flipper/home/reports/date_widget/range_picker_page.dart';
import 'package:flutter/material.dart';

class DateScreen extends StatefulWidget {
  final String title;

  DateScreen({Key key, this.title}) : super(key: key);

  @override
  _DateScreenState createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> with TickerProviderStateMixin {
  int _selectedTab;

  DateTime startOfPeriod;
  DateTime endOfPeriod;
  DateTime firstDate;
  DateTime lastDate;

  final List<Widget> datePickers = <Widget>[
    RangePickerPage(
      events: events,
    )
  ];

  @override
  void initState() {
    super.initState();

    _selectedTab = 0;
    startOfPeriod = firstDate;
    endOfPeriod = lastDate;

    print(startOfPeriod);
    print(endOfPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {},
        title: 'Customize Report',
        disableButton: false,
        showActionButton: true,
        onPressedCallback: () async {},
        actionButtonName: 'save',
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 49,
      ),
      body: Center(child: datePickers[_selectedTab]),
    );
  }
}

final List<Event> events = [
  Event(DateTime.now(), "Today event"),
];
