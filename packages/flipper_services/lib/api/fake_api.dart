import 'package:flipper_models/customer.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_services/abstractions/api.dart';

final List<Map<String, String>> mockUnits = [
  {'name': 'Per Item', 'value': ''},
  {'name': 'Per Kilogram (kg)', 'value': 'kg'},
  {'name': 'Per Cup (c)', 'value': 'c'},
  {'name': 'Per Liter (l)', 'value': 'l'},
  {'name': 'Per Pound (lb)', 'value': 'lb'},
  {'name': 'Per Pint (pt)', 'value': 'pt'},
  {'name': 'Per Acre (ac)', 'value': 'ac'},
  {'name': 'Per Centimeter (cm)', 'value': 'cm'},
  {'name': 'Per Cubic Footer (cu ft)', 'value': 'cu ft'},
  {'name': 'Per Day (day)', 'value': 'day'},
  {'name': 'Footer (ft)', 'value': 'ft'},
  {'name': 'Per Gram (g)', 'value': 'g'},
  {'name': 'Per Hour (hr)', 'value': 'hr'},
  {'name': 'Per Minute (min)', 'value': 'min'},
  {'name': 'Per Acre (ac)', 'value': 'ac'},
  {'name': 'Per Cubic Inch (cu in)', 'value': 'cu in'},
  {'name': 'Per Cubic Yard (cu yd)', 'value': 'cu yd'},
  {'name': 'Per Fluid Ounce (fl oz)', 'value': 'fl oz'},
  {'name': 'Per Gallon (gal)', 'value': 'gal'},
  {'name': 'Per Inch (in)', 'value': 'in'},
  {'name': 'Per Kilometer (km)', 'value': 'km'},
  {'name': 'Per Meter (m)', 'value': 'm'},
  {'name': 'Per Mile (mi)', 'value': 'mi'},
  {'name': 'Per Milligram (mg)', 'value': 'mg'},
  {'name': 'Per Milliliter (mL)', 'value': 'mL'},
  {'name': 'Per Millimeter (mm)', 'value': 'mm'},
  {'name': 'Per Millisecond (ms)', 'value': 'ms'},
  {'name': 'Per Ounce (oz)', 'value': 'oz'},
  {'name': 'Per  Quart (qt)', 'value': 'qt'},
  {'name': 'Per Second (sec)', 'value': 'sec'},
  {'name': 'Per Shot (sh)', 'value': 'sh'},
  {'name': 'Per Square Centimeter (sq cm)', 'value': 'sq cm'},
  {'name': 'Per Square Foot (sq ft)', 'value': 'sq ft'},
  {'name': 'Per Square Inch (sq in)', 'value': 'sq in'},
  {'name': 'Per Square Kilometer (sq km)', 'value': 'sq km'},
  {'name': 'Per Square Meter (sq m)', 'value': 'sq m'},
  {'name': 'Per Square Mile (sq mi)', 'value': 'sq mi'},
  {'name': 'Per Square Yard (sq yd)', 'value': 'sq yd'},
  {'name': 'Per Stone (st)', 'value': 'st'},
  {'name': 'Per Yard (yd)', 'value': 'yd'}
];
final Map<String, dynamic> mockData = {
  // ignore: always_specify_types
  'payrolls': [
    // ignore: always_specify_types
    {
      'title': 'souce-supplier',
      'list':
          // ignore: always_specify_types
          [
        // ignore: always_specify_types
        {
          'name': 'Richie',
          'phone': '+250783054874',
          'last-payment': '12/30/30',
          'total_paid': 230303,
          'type': 'recurring',
          'next_pay':
              null //| can be a date to show when a next payment will be made.
        },
        {
          'name': 'Richie',
          'phone': '+250783054874',
          'last-payment': '12/30/30',
          'total_paid': 230303,
          'type': 'recurring',
          'next_pay':
              null //| can be a date to show when a next payment will be made.
        }
      ]
    },
  ]
};

class ApiResponse {
  final bool success;
  dynamic data;
  // ignore: sort_constructors_first
  ApiResponse({this.success, this.data});
}

class FakeApi implements Api {
  @override
  // ignore: always_specify_types
  Future payroll() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(microseconds: 2000));
    return ApiResponse(success: true, data: mockData['payrolls']);
  }

  @override
  List<Order> currentOrders() {
    // TODO: implement currentOrders
    throw UnimplementedError();
  }

  @override
  List<Ticket> currentTickets() {
    // TODO: implement currentTickets
    throw UnimplementedError();
  }

  @override
  List<Customer> customers() {
    // TODO: implement customers
    throw UnimplementedError();
  }

  @override
  List<PColor> colors() {
    // TODO: implement colors
    throw UnimplementedError();
  }
}
