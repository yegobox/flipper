import 'dart:convert';

import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchQueryControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final supplierListProvider =
    FutureProvider.autoDispose<List<Supplier>>((ref) async {
  final keyword = ref.read(searchQueryProvider.notifier).state;

  // Check if the keyword is null or empty, and return an empty list if true
  if (keyword.isEmpty) {
    return [];
  }
  String token = ProxyService.box.getBearerToken()!;

  final response = await http.get(
    Uri.parse('https://apihub.yegobox.com/searchAlike?name=$keyword'),
    headers: {'Authorization': '${token}'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<Supplier>((item) {
      return Supplier(
        businessId: item['business']['id'],
        branchId: item['branch']['id'],
        name: item['business']['name'],
      );
    }).toList();
  } else {
    throw Exception('Failed to load suppliers');
  }
});
