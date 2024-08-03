import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

final productColorsProvider =
    StateNotifierProvider<ProductColorsNotifier, List<Color>>((ref) {
  return ProductColorsNotifier();
});

class ProductColorsNotifier extends StateNotifier<List<Color>> {
  ProductColorsNotifier() : super([]);

  Future<void> fetchColors(List<Variant> variants) async {
    final colors =
        variants.map((variant) => hexToColor(variant.color!)).toList();
    state = colors;
  }

  Color hexToColor(String code) {
    if (code.isNotEmpty) {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return Color(
          int.parse("#FF0000".substring(1, 7), radix: 16) + 0xFF000000);
    }
  }
}

final cartListProvider = StateNotifierProvider<CartListNotifier, List<Variant>>(
    (ref) => CartListNotifier());

class CartListNotifier extends StateNotifier<List<Variant>> {
  CartListNotifier() : super([]);

  void addToCart(Variant item) {
    final currentList = state;
    currentList.add(item);
    state = [...currentList];
  }

  void removeFromCart(Variant item) {
    final currentList = state;
    currentList.remove(item);
    state = [...currentList];
  }
}

final productFromSupplier =
    FutureProvider.autoDispose<List<Variant>>((ref) async {
  final supplier = ref.watch(selectedSupplierProvider);
  var headers = {
    'api-key': AppSecrets.apikey,
    'Content-Type': 'application/json'
  };
  var data = json.encode({
    "collection": "Variant",
    "database": "flipper",
    "dataSource": "Cluster0",
    "filter": {"branchId": supplier.value?.serverId}
  });

  var dio = Dio();
  try {
    var response = await dio.post(
      'https://ap-south-1.aws.data.mongodb-api.com/app/data-kbpgj/endpoint/data/v1/action/find',
      options: Options(headers: headers),
      data: data,
    );

    final List<dynamic> documents = response.data['documents'] ?? [];

    List<Variant> variants = documents.map<Variant>((item) {
      print("retailPrice ${item['retailPrice']}");
      print("supplyPrice ${item['supplyPrice']}");

      // Check data types if known to be integers

      // Handle potential decimals otherwise
      double retailPrice = item['retailPrice'].toDouble();
      double supplyPrice = item['supplyPrice'].toDouble();

      return Variant(
        ObjectId(),
        name: item['name'],
        productName: item['productName'],
        productId: item['productId'],
        branchId: item['branchId'],
        id: item['id'] as int,
        color: item['color'],
        retailPrice: retailPrice,
        supplyPrice: supplyPrice,
      );
    }).toList();

    return variants;
  } on DioException catch (e) {
    Talker().error('DioException in productFromSupplier: ${e.message}');
    return []; // Return an empty list instead of throwing
  } catch (e, s) {
    Talker().error('Error in productFromSupplier: $e');
    Talker().error('Stack trace: $s');
    return []; // Return an empty list for any other errors
  }
});
