import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarViewModel extends BaseViewModel {
  final dateTime = DateTime.now();
  //TODO:{telesphore}start from current date
  final DateTime _currentDate = DateTime(2020, 2, 3);
  DateTime _currentDate2 = DateTime(2020, 2, 3);

  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime(2020, 2, 3);

  DateTime get currentDate {
    return _currentDate;
  }

  DateTime get currentDate2 {
    return _currentDate2;
  }

  String get currentMonth {
    return _currentMonth;
  }

  DateTime get targetDateTime {
    return _targetDateTime;
  }

  void todayDate({@required DateTime date}) {
    _currentDate2 = date;
    notifyListeners();
  }

  void calendarChange({@required DateTime date}) {
    _targetDateTime = date;
    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
    notifyListeners();
  }

  void previousMonth() {
    _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
    notifyListeners();
  }

  void nextMonth() {
    _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
    notifyListeners();
  }
}
