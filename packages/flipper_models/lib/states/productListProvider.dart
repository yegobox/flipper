import 'package:dio/dio.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final searchStringProvider = StateProvider<String>((ref) => '');

// Create a family provider to cache results by supplier and search parameters
final productFromSupplier = FutureProvider.autoDispose
    .family<List<Variant>, ({int? supplierId, String searchString})>(
        (ref, params) async {
  if (params.supplierId == null) throw Exception("Select a supplier");

  talker.warning("Supplier Id: ${params.supplierId}");

  // Get the Supabase URL and headers
  var headers = {
    'Content-Type': 'application/json',
    'apikey': AppSecrets.supabaseAnonKey,
  };

  // Construct the Supabase URL with query parameters
  String supabaseUrl =
      '${AppSecrets.newApiEndPoints}${params.supplierId}&limit=100&or=(pchs_stts_cd.is.null,pchs_stts_cd.neq.01,pchs_stts_cd.neq.04)&or=(impt_item_stts_cd.is.null,impt_item_stts_cd.neq.2,impt_item_stts_cd.neq.4)';

  if (params.searchString.isNotEmpty) {
    supabaseUrl += '&name=ilike.*${params.searchString}*';
  }

  var dio = Dio();
  try {
    // Make the GET request to Supabase
    var response = await dio.get(
      supabaseUrl,
      options: Options(headers: headers),
    );

    // Parse the response data
    final List<dynamic> data = response.data ?? [];

    // Map the data to the Variant model
    List<Variant> variants = data.map<Variant>((item) {
      return Variant(
        itemCd: item['item_cd'],
        id: item['id']?.toString() ?? '',
        name: item['name'] ?? 'Unknown',
        productName: item['product_name'] ?? 'Unknown',
        productId: item['product_id']?.toString() ?? '',
        branchId: item['branch_id'] ?? 0,
        color: item['color'] ?? '#FFFFFF',
        stockId: item['stock_id'] ?? 0,
        retailPrice: (item['retail_price'] as num?)?.toDouble() ?? 0.0,
        supplyPrice: (item['supply_price'] as num?)?.toDouble() ?? 0.0,
        // Add other fields as needed
      );
    }).toList();

    return variants;
  } on DioException catch (e) {
    Talker().error('DioException in productFromSupplier: ${e.message}');
    return []; // Return an empty list on error
  } catch (e, s) {
    Talker().error('Error in productFromSupplier: $e');
    Talker().error('Stack trace: $s');
    return []; // Return an empty list for any other errors
  }
});

// Create a wrapper provider that gets supplier and search string and calls the family provider
final productFromSupplierWrapper =
    FutureProvider.autoDispose<List<Variant>>((ref) async {
  final supplier = ref.watch(selectedSupplierProvider);
  final searchString = ref.watch(searchStringProvider);

  return await ref.watch(
    productFromSupplier(
      (supplierId: supplier?.serverId, searchString: searchString),
    ).future,
  );
});
