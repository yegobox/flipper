import 'dart:convert';

import 'package:dio/dio.dart';
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

  var data = json.encode({
    "structuredQuery": {
      "from": [
        {"collectionId": AppSecrets.queryableModel}
      ],
      "where": {
        "fieldFilter": {
          "field": {"fieldPath": "branch_id"},
          "op": "EQUAL",
          "value": {"integerValue": supplier.value?.serverId}
        }
      }
    }
  });

  var dio = Dio();
  try {
    var response = await dio.post(
      AppSecrets.apiEndPoints,
      data: data,
    );

    final List<dynamic> documents = response.data ?? [];

    // Filtering out any documents that don't have a 'document' field
    List<Variant> variants = documents
        .where(
            (item) => item['document'] != null) // Safeguard for null documents
        .map<Variant>((item) {
      var fields = item['document']?['fields'] ?? {};

      // Safely retrieve values with null checks
      String name = fields['name']?['stringValue'] ?? 'Unknown';
      String productName = fields['product_name']?['stringValue'] ?? 'Unknown';
      String productId =
          fields['product_id']?['integerValue']?.toString() ?? '';
      int branchId = int.tryParse(
              fields['branch_id']?['integerValue']?.toString() ?? '0') ??
          0;
      int id =
          int.tryParse(fields['id']?['integerValue']?.toString() ?? '0') ?? 0;
      String color = fields['color']?['stringValue'] ?? '#FFFFFF';

      int retailPrice = fields['retail_price']?['doubleValue'] ?? 0.0;
      int supplyPrice = fields['supply_price']?['doubleValue'] ?? 0.0;

      return Variant(
        ObjectId(),
        name: name,
        productName: productName,
        productId: int.parse(productId),
        branchId: branchId,
        id: id,
        color: color,
        retailPrice: retailPrice.toDouble(),
        supplyPrice: supplyPrice.toDouble(),
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
