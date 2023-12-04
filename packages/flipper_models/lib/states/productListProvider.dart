// ignore_for_file: unused_result
import 'dart:convert';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';

import 'package:flutter/foundation.dart' as found;
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productListProvider =
    FutureProvider.autoDispose<List<Variant>?>((ref) async {
  final supplier = ref.watch(selectedSupplierProvider);
  String? token;
  String? url;
  if (found.kDebugMode) {
    token = await ProxyService.remote.getToken(AppSecrets.apiUrlDebug,
        AppSecrets.debugPassword, AppSecrets.debugEmail);
    url = AppSecrets.apiUrlDebug;
  } else {
    token = await ProxyService.remote.getToken(
        AppSecrets.apiUrlProd, AppSecrets.prodPassword, AppSecrets.prodEmail);
    url = AppSecrets.apiUrlProd;
  }
  final response = await http.get(
    Uri.parse(
        '${url}/api/collections/variants/records?filter=(branchId=\'${supplier.value!.branchId}\')'),
    headers: {
      'Authorization': 'Bearer ${token}',
    },
  );
  if (response.statusCode == 200) {
    // Successful response with status code 200
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['items'] is List && data['items']?.isEmpty) {
      throw Exception('No product added yet for this supplier');
    }
    final List<dynamic> items = data['items'];

    // Map the list of items to Variant objects using Variant.fromJson
    List<Variant> variants = items.map<Variant>((item) {
      print(item);
      return Variant.fromJson(item);
    }).toList();
    // Return the list of Variant objects
    return variants;
  } else {
    // Failed response with a status code other than 200
    throw Exception(
        'Failed to load products. Status Code: ${response.statusCode}');
  }
});
