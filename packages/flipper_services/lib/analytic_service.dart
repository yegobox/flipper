import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/order.dart';

class AnalyticService with ReactiveServiceMixin {
  final _customers = ReactiveValue<int>(0);
  int? get customers => _customers.value;

  final _groupedData = ReactiveValue<List<List<int>>>([]);
  List<List<int>> get groupedData => _groupedData.value;

  final _revenue = ReactiveValue<int>(0);
  int? get revenue => _revenue.value;

  final _orders = ReactiveValue<List<OrderF>>([]);
  List<OrderF> get orders => _orders.value;

  countLifeTimeCustomers() {
    int branchId = ProxyService.box.read(key: 'branchId');
    int customersCount =
        ProxyService.api.lifeTimeCustomersForbranch(branchId: branchId);
    _customers.value = customersCount;
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  /// If we are today, then go back one week
  /// then show the report of that previous week.
  countOrdersByThisWeek() {
    _revenue.value = 0;
    //get today date using DateTime
    DateTime today = new DateTime.now();
    //get the date of start of the week
    DateTime startWeekDate =
        getDate(today.subtract(Duration(days: today.weekday - 1)));
    // DateTime endWeekDate = getDate(
    //     today.add(Duration(days: DateTime.daysPerWeek - today.weekday)));
    int branchId = ProxyService.box.read(key: 'branchId');
    _orders.value = ProxyService.api.weeklyOrdersReport(
        weekStartDate: startWeekDate.subtract(Duration(days: 7)),
        //this will help to go back in a week
        weekEndDate: today,
        branchId: branchId);
    List<int> revenues = [];
    for (OrderF order in orders) {
      revenues.add(order.cashReceived.toInt());
    }
    // transform data list to be [[0,1], [1,2], [2,3], [3,4], [4,5]]
    _groupedData.value = [];
    for (int i = 0; i < revenues.length; i++) {
      //apply modulo to have a graph of the week that is not exceeding the viewpoint
      _groupedData.value.add([revenues[i] % 10, i % 10]);
    }
    if (orders.isNotEmpty) {
      _revenue.value += orders.fold(0,
          (a, b) => a + (b.cashReceived.toInt() - b.customerChangeDue.toInt()));
    }
  }
}
