import 'dart:convert';
import 'package:flipper/datamodels/api.dart';
import 'package:flipper/services/abstractions/api.dart';
import 'package:flipper_login/loginResponse.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;

  ExtendedClient(this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    String customValue = '';
    // you may want to pickup the value from tshared preferences, like:
    // customValue = await LocalStorage.getStringItem('token');
    request.headers['custom-header-here'] = customValue;
    return _inner.send(request);
  }
}

@lazySingleton
class HttpApi implements Api {
  static const endPoint = 'https://jsonplaceholder.typicode.com';

  var client = ExtendedClient(http.Client());


  @override
  Future payroll() {
    // TODO: implement payroll
    return null;
  }
}
