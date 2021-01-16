// import 'package:flipper/services/abstractions/api.dart';

import 'package:flipper_services/abstractions/api.dart';
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

  @override
  // ignore: always_specify_types
  Future payroll() {
    // TODO(richard): implement payroll
    return null;
  }
}
