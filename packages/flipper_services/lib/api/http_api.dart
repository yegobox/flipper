// import 'package:flipper/services/abstractions/api.dart';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/customer.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_models/view_models/Queries.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;

  // ignore: sort_constructors_first
  ExtendedClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    const String customValue = '';
    // you may want to pickup the value from tshared preferences, like:
    // customValue = await LocalStorage.getStringItem('token');
    request.headers['custom-header-here'] = customValue;
    return _inner.send(request);
  }
}

@lazySingleton
class HttpApi implements Api {
  static const String endPoint = 'https://jsonplaceholder.typicode.com';
  ExtendedClient client = ExtendedClient(http.Client());
  double totalSaleCount;
  final List<Order> _currentSale = [];
  final List<PColor> _colors = [];
  final List<Customer> _customers = [];

  @override
  // ignore: always_specify_types
  Future payroll() {
    // TODO(richard): implement payroll
    return null;
  }

  @override
  List<Order> currentOrders() {
    _currentSale.clear();
    final q = Query(ProxyService.database.db, Queries.Q_3);
    q.parameters = {'T': AppTables.order, 'S': 'pending'};

    final counts = q.execute();
    for (Map map in counts.allResults) {
      _currentSale.add(Order.fromMap(map));
    }
    return _currentSale;
  }

  @override
  List<Ticket> currentTickets() {
    // TODO: implement currentTickets
    throw UnimplementedError();
  }

  @override
  List<Customer> customers() {
    _customers.clear();
    final q = Query(ProxyService.database.db, Queries.Q_11);
    q.parameters = {'T': AppTables.customers};

    final counts = q.execute();
    for (Map map in counts.allResults) {
      _customers.add(Customer.fromMap(map));
    }
    return _customers;
  }

  @override
  List<PColor> colors() {
    _colors.clear();
    final q = Query(ProxyService.database.db, Queries.Q_12);
    q.parameters = {'T': AppTables.color};

    final results = q.execute();
    for (Map value in results.allResults) {
      _colors.add(PColor.fromMap(value));
    }
    return _colors;
  }

  @override
  Customer create({Map<dynamic, dynamic> customer, String id}) {
    final Document doc = ProxyService.database.insert(id: id, data: customer);
    return Customer.fromMap(doc.map);
  }
}
