// import 'package:flipper/services/abstractions/api.dart';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/customer.dart';
import 'package:flipper_models/g_customer.dart';
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
    // const String customValue = '';
    // you may want to pickup the value from tshared preferences, like:
    // customValue = await LocalStorage.getStringItem('token');
    // request.headers['custom-header-here'] = customValue;
    return _inner.send(request);
  }
}

@lazySingleton
class HttpApi implements Api {
  //TODO: send userID to DB for auth can override another client who sent the request so need to find proper auth.
  HttpApi() {
    //TODO: check if we have internet then call api otherwise continue
    post(endPoint: 'auth', body: {'userId': ProxyService.sharedState.user.id});

    customers();
  }
  ExtendedClient client = ExtendedClient(http.Client());
  double totalSaleCount;

  final List<PColor> _colors = [];

  @override
  // ignore: always_specify_types
  Future payroll() {
    return null;
  }

  @override
  List<Order> currentOrders() {
    // ignore: prefer_final_locals
    List<Order> _currentSale = [];
    final q = Query(ProxyService.database.db, Queries.Q_3);

    q.parameters = {'T': AppTables.order, 'S': 'pending'};

    final counts = q.execute();
    for (Map map in counts.allResults) {
      _currentSale.add(Order.fromMap(map));
    }
    return _currentSale;
  }

  Future<http.Response> get(
      {String endPoint, Map<String, dynamic> body}) async {
    final http.Response response =
        await http.get('https://apihub.yegobox.com/' + endPoint);
    return response;
  }

  Future<http.Response> post(
      {String endPoint, Map<String, dynamic> body}) async {
    final http.Response response = await http
        .post('https://apihub.yegobox.com/' + endPoint, body: body, headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    return response;
  }

  @override
  List<Ticket> currentTickets() {
    // TODO: implement currentTickets
    throw UnimplementedError();
  }

  @override
  Future<List<GCustomer>> customers() async {
    final http.Response response = await get(endPoint: 'api/customers');

    final List<GCustomer> customers = customerFromJson(response.body);
    // final List<Customer> customers = data
    //     .map<Customer>((Map<String, dynamic> map) => standardSerializers
    //         .deserializeWith<Customer>(Customer.serializer, map))
    //     .toList();
    print(customers);
    return customers;
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
