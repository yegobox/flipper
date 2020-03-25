import 'package:flipper/home/reports/date_widget/event.dart';
import 'package:flutter/material.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class RangePickerPage extends StatefulWidget {
  final List<Event> events;

  const RangePickerPage({Key key, this.events}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RangePickerPageState();
}

class _RangePickerPageState extends State<RangePickerPage> {
  DateTime _firstDate;
  DateTime _lastDate;
  DatePeriod _selectedPeriod;

  Color selectedPeriodStartColor;
  Color selectedPeriodLastColor;
  Color selectedPeriodMiddleColor;

  @override
  void initState() {
    super.initState();

    _firstDate = DateTime.now().subtract(Duration(days: 45));
    _lastDate = DateTime.now().add(Duration(days: 45));

    DateTime selectedPeriodStart = DateTime.now().subtract(Duration(days: 4));
    DateTime selectedPeriodEnd = DateTime.now().add(Duration(days: 8));
    _selectedPeriod = DatePeriod(selectedPeriodStart, selectedPeriodEnd);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // defaults for styles
    selectedPeriodLastColor = Theme.of(context).accentColor;
    selectedPeriodMiddleColor = Theme.of(context).accentColor;
    selectedPeriodStartColor = Theme.of(context).accentColor;
  }

  @override
  Widget build(BuildContext context) {
    // add selected colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: selectedPeriodLastColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: selectedPeriodStartColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration: BoxDecoration(
          color: selectedPeriodMiddleColor, shape: BoxShape.rectangle),
    );

    return Flex(
      direction: MediaQuery.of(context).orientation == Orientation.portrait
          ? Axis.vertical
          : Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: RangePicker(
            selectedPeriod: _selectedPeriod,
            onChanged: _onSelectedDateChanged,
            firstDate: _firstDate,
            lastDate: _lastDate,
            datePickerStyles: styles,
            eventDecorationBuilder: _eventDecorationBuilder,
          ),
        ),
      ],
    );
  }

  void _onSelectedDateChanged(DatePeriod newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
  }

  EventDecoration _eventDecorationBuilder(DateTime date) {
    List<DateTime> eventsDates =
        widget.events?.map<DateTime>((Event e) => e.date)?.toList();
    bool isEventDate = eventsDates?.any((DateTime d) =>
            date.year == d.year &&
            date.month == d.month &&
            d.day == date.day) ??
        false;

    BoxDecoration roundedBorder = BoxDecoration(
        border: Border.all(
          color: Colors.green,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));

    return isEventDate ? EventDecoration(boxDecoration: roundedBorder) : null;
  }
}
