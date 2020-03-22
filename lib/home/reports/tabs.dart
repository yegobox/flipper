import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class Tabs extends StatelessWidget {
  const Tabs({
    Key key,
    @required this.tabLenght,
  }) : super(key: key);

  final double tabLenght;

  Widget buildWeekDatePicker(DateTime selectedDate, DateTime firstAllowedDate,
      DateTime lastAllowedDate, ValueChanged<DatePeriod> onNewSelected) {
    // add some colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration:
          BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle),
    );

    return WeekPicker(
        selectedDate: selectedDate,
        onChanged: onNewSelected,
        firstDate: firstAllowedDate,
        lastDate: lastAllowedDate,
        datePickerStyles: styles);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.black,
      isScrollable: true,
      tabs: [
        Container(
          child: FlatButton(
            onPressed: () {},
            child: Text("Date"),
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1D',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1W',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1M',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '3M',
          ),
        ),
        Container(
          width: tabLenght,
          child: Tab(
            text: '1Y',
          ),
        ),
      ],
    );
  }
}
