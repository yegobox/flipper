import 'package:flipper/datamodels/api.dart';
import 'package:flipper/services/abstractions/api.dart';

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
              'phone':'+250783054874',
              'last-payment':'12/30/30',
              'total_paid':230303,
              'type':'recurring',
              'next_pay':null //| can be a date to show when a next payment will be made.
            },
            {
              'name': 'Richie',
              'phone':'+250783054874',
              'last-payment':'12/30/30',
              'total_paid':230303,
              'type':'recurring',
              'next_pay':null //| can be a date to show when a next payment will be made.
            }
          ]
    },
  ]
  
};

class FakeApi implements Api {
  @override
  // ignore: always_specify_types
  Future payroll()async {
     // ignore: always_specify_types
     await Future.delayed(const Duration(microseconds: 2000));
    return ApiResponse(success: true, data: mockData['payrolls']);
  }

}

