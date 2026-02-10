import 'package:dio/dio.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productColorsProvider =
    StateNotifierProvider<ProductColorsNotifier, List<Color>>((ref) {
      return ProductColorsNotifier();
    });

class ProductColorsNotifier extends StateNotifier<List<Color>> {
  ProductColorsNotifier() : super([]);

  Future<void> fetchColors(List<Variant> variants) async {
    // Filter variants to only include those with valid color strings
    final colors = variants
        .where((v) => v.color != null && v.color!.isNotEmpty)
        .map((variant) => hexToColor(variant.color))
        .toList();
    state = colors;
  }

  /// Safely converts a hex color string to a Color object.
  /// Returns a default grey color if the input is invalid.
  ///
  /// Valid format: "#RRGGBB" where RR, GG, BB are hex digits (0-9, A-F)
  Color hexToColor(String? code) {
    // Default fallback color (grey)
    const defaultColor = Color(0xFF9E9E9E);

    // Null or empty check
    if (code == null || code.isEmpty) {
      return defaultColor;
    }

    // Remove any whitespace
    final trimmedCode = code.trim();

    // Check if it starts with '#'
    if (!trimmedCode.startsWith('#')) {
      return defaultColor;
    }

    // Check minimum length (#RRGGBB = 7 characters)
    if (trimmedCode.length < 7) {
      return defaultColor;
    }

    // Extract hex string (skip the '#')
    final hexString = trimmedCode.substring(1, 7);

    // Validate that all characters are valid hex digits
    final hexPattern = RegExp(r'^[0-9A-Fa-f]{6}$');
    if (!hexPattern.hasMatch(hexString)) {
      return defaultColor;
    }

    // Parse and return the color
    try {
      return Color(int.parse(hexString, radix: 16) + 0xFF000000);
    } catch (e) {
      // If parsing fails for any reason, return default
      return defaultColor;
    }
  }
}

final cartListProvider = StateNotifierProvider<CartListNotifier, List<Variant>>(
  (ref) => CartListNotifier(),
);

class CartListNotifier extends StateNotifier<List<Variant>> {
  CartListNotifier() : super([]);

  void addToCart(Variant item) {
    state = [...state, item];
  }

  void removeFromCart(Variant item) {
    state = state.where((element) => element != item).toList();
  }
}

final searchStringProvider = StateProvider<String>((ref) => '');

// Create a family provider to cache results by supplier and search parameters
final productFromSupplier = FutureProvider.autoDispose
    .family<List<Variant>, ({String? supplierId, String searchString})>((
      ref,
      params,
    ) async {
      if (params.supplierId == null) throw Exception("Select a supplier");

      talker.warning("Supplier Id: ${params.supplierId}");

      // Get the Supabase URL and headers
      var headers = {
        'Content-Type': 'application/json',
        'apikey': AppSecrets.supabaseAnonKey,
      };

      // Construct the Supabase URL with query parameters
      String supabaseUrl =
          '${AppSecrets.newApiEndPoints}${params.supplierId}&limit=100&or=(pchs_stts_cd.is.null,pchs_stts_cd.not.in.("01","04"))&or=(impt_item_stts_cd.is.null,impt_item_stts_cd.not.in.("2","4"))';

      if (params.searchString.isNotEmpty) {
        supabaseUrl +=
            '&name=ilike.*${Uri.encodeQueryComponent(params.searchString)}*';
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
            branchId: item['branch_id']?.toString() ?? '0',
            color: item['color'] ?? '#FFFFFF',
            stockId: item['stock_id']?.toString() ?? "",
            retailPrice: (item['retail_price'] as num?)?.toDouble() ?? 0.0,
            supplyPrice: (item['supply_price'] as num?)?.toDouble() ?? 0.0,
            // Add other fields as needed
          );
        }).toList();

        return variants;
      } on DioException catch (e) {
        talker.error('DioException in productFromSupplier: ${e.message}');
        return []; // Return an empty list on error
      } catch (e, s) {
        talker.error('Error in productFromSupplier: $e');
        talker.error('Stack trace: $s');
        return []; // Return an empty list for any other errors
      }
    });

// Create a wrapper provider that gets supplier and search string and calls the family provider
final productFromSupplierWrapper = FutureProvider.autoDispose<List<Variant>>((
  ref,
) async {
  final supplier = ref.watch(selectedSupplierProvider);
  final searchString = ref.watch(searchStringProvider);

  return await ref.watch(
    productFromSupplier((
      supplierId: supplier?.id,
      searchString: searchString,
    )).future,
  );
});
