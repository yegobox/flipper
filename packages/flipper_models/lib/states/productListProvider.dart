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

/// Supplier catalog search (distinct from POS [searchStringProvider] in scan_mode).
final supplierCatalogSearchProvider = StateProvider<String>((ref) => '');

/// The supplier's stock on hand for one catalogue row, from the embedded
/// `stocks` relation.
///
/// PostgREST returns a to-one embed as an object, but answers with a list when
/// it resolves the relationship the other way, so both shapes are accepted.
/// Returns null when the embed is absent (it was dropped, or the variant has no
/// stock row) — distinct from a row that genuinely reads zero, which the
/// purchase-order screen marks "none" rather than "unknown".
Stock? _supplierStock(dynamic item, String branchId) {
  if (item is! Map) return null;
  final embed = item['stocks'];
  final row = switch (embed) {
    Map() => embed,
    List() when embed.isNotEmpty && embed.first is Map =>
      embed.first as Map,
    _ => null,
  };
  if (row == null) return null;
  final current = row['current_stock'];
  if (current is! num) return null;
  return Stock(
    id: item['stock_id']?.toString(),
    branchId: branchId,
    currentStock: current.toDouble(),
  );
}

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
        // The purchase-order screen shows the supplier's stock on hand beside
        // their cost, so the row is fetched with `stocks` embedded over
        // `variants.stock_id` (constraint `fk_stock`, the only relationship
        // between the two tables). The embed is the *only* source of stock
        // here — the supplier's stock rows are not on this device.
        //
        // An embed is also the one part of this query that can fail for a
        // reason unrelated to the catalogue (RLS on `stocks`, a schema-cache
        // miss). Losing stock is survivable; losing the catalogue is not, so a
        // failed embed falls back to the plain row set and the screen renders
        // stock as unknown.
        Response<dynamic>? response;
        for (final select in const ['*,stocks(current_stock)', null]) {
          final url = select == null
              ? supabaseUrl
              : '$supabaseUrl&select=${Uri.encodeQueryComponent(select)}';
          try {
            response = await dio.get(url, options: Options(headers: headers));
            break;
          } on DioException catch (e) {
            if (select == null) rethrow;
            talker.warning(
              'productFromSupplier: stock embed failed (${e.response?.statusCode}); '
              'retrying without it',
            );
          }
        }

        // Parse the response data
        final List<dynamic> data = response?.data ?? [];

        // Map the data to the Variant model
        List<Variant> variants = data.map<Variant>((item) {
          final branchId = item['branch_id']?.toString() ?? '0';
          return Variant(
            itemCd: item['item_cd'],
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown',
            productName: item['product_name'] ?? 'Unknown',
            productId: item['product_id']?.toString() ?? '',
            branchId: branchId,
            color: item['color'] ?? '#FFFFFF',
            sku: item['sku']?.toString(),
            bcd: item['bcd']?.toString(),
            categoryId: item['category_id']?.toString(),
            categoryName: item['category_name']?.toString(),
            unit: item['unit']?.toString(),
            qtyUnitCd: item['qty_unit_cd']?.toString(),
            imageUrl: item['image_url']?.toString(),
            stockId: item['stock_id']?.toString() ?? "",
            stock: _supplierStock(item, branchId),
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
  final searchString = ref.watch(supplierCatalogSearchProvider);

  return await ref.watch(
    productFromSupplier((
      supplierId: supplier?.id,
      searchString: searchString,
    )).future,
  );
});
