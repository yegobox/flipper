import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchQueryControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final supplierListProvider =
    FutureProvider.autoDispose<List<Branch>>((ref) async {
  final keyword = ref.read(searchQueryProvider.notifier).state;

  // Check if the keyword is null or empty, and return an empty list if true
  if (keyword.isEmpty) {
    return [];
  }
  String token = ProxyService.box.getBearerToken()!;

  final response = await http.get(
    Uri.parse('https://178.62.206.133/searchAlike?name=$keyword'),
    headers: {'Authorization': '${token}'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<Branch>((item) {
      return Branch(
        id: item['id'],
        businessId: item['business']['id'],
        name: item['business']['name'],
      );
    }).toList();
  } else {
    throw Exception('Failed to load suppliers');
  }
});
