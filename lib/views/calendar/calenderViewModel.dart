import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarViewModel extends BaseViewModel {
  final dateTime = DateTime.now();
  //TODO:{telesphore}start from current date
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;

  String get selectedDate {
    return _selectedDate;
  }

  String get dateCount {
    return _dateCount;
  }

  String get range {
    return _range;
  }

  String get rangeCount {
    return _rangeCount;
  }
  

  void onSelectionChanged(DateRangePickerSelectionChangedArgs  args) {
    if (args.value is PickerDateRange) {
      _range =DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
              ' - ' +
              DateFormat('dd/MM/yyyy')
                  .format(args.value.endDate ?? args.value.startDate)
                  .toString();
    } else if (args.value is DateTime) {
      _selectedDate = args.value;
    } else if (args.value is List<DateTime>) {
      _dateCount = args.value.length.toString();
    } else {
      _rangeCount = args.value.length.toString();
    }
    notifyListeners();
  }
}
