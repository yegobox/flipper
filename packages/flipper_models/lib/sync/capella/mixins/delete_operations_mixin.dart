import 'dart:async';

import 'package:flipper_models/sync/utils/cart_line_doc_cache.dart';
import 'package:flipper_models/sync/utils/catalog_delete.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync/interfaces/delete_operations_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

import 'package:flipper_web/services/ditto_service.dart';

mixin CapellaDeleteOperationsMixin implements DeleteOperationsInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  // TODO(ditto-migration): port `deleteBranch` to Ditto.
  @override
  Future<void> deleteBranch({
    required String branchId,
    required HttpClientInterface flipperHttpClient,
  }) async {
    return ProxyService.legacyStrategy.deleteBranch(
      branchId: branchId,
      flipperHttpClient: flipperHttpClient,
    );
  }

  // Implemented Ditto-natively in [CapellaFavoriteMixin]; abstract here so this
  // mixin still satisfies its interface without shadowing that with a Brick
  // delegation.
  @override
  Future<int> deleteFavoriteByIndex({required String favIndex});

  Future<void> deleteAllTransactionItems({
    required String transactionId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for deleteAllTransactionItems');
      return;
    }

    try {
      await ditto.store.execute(
        'DELETE FROM transaction_items WHERE transactionId = :tid',
        arguments: {'tid': transactionId},
      );

      final now = DateTime.now().toIso8601String();
      await ditto.store.execute(
        'UPDATE transactions SET subTotal = 0, updatedAt = :ua, lastTouched = :lt '
        'WHERE _id = :tid OR id = :tid',
        arguments: {'ua': now, 'lt': now, 'tid': transactionId},
      );
      talker.info('Deleted all items for transaction $transactionId');
    } catch (e) {
      talker.error('Error deleting all transaction items: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteItemFromCart({
    required TransactionItem transactionItemId,
    String? transactionId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for deleteItemFromCart');
      return;
    }

    try {
      final id = transactionItemId.id;
      const query = "DELETE FROM transaction_items WHERE _id = :id OR id = :id";
      await ditto.store.execute(query, arguments: {'id': id});
      talker.info('Deleted transaction item $id from Ditto');

      final txnId = transactionId ?? transactionItemId.transactionId;
      // The add path caches this cart's lines; a deleted row left cached makes
      // the next tap on that product update a document that no longer exists,
      // so the line never comes back.
      cartLineDocCache.forget(txnId ?? '');
      if (txnId != null) {
        final contrib =
            transactionItemId.price.toDouble() *
            transactionItemId.qty.toDouble();
        await _adjustTransactionSubtotalByDelta(ditto, txnId, -contrib);
      }
    } catch (e) {
      talker.error('Error deleting item from cart in Capella: $e');
    }
  }

  Future<void> _adjustTransactionSubtotalByDelta(
    dynamic ditto,
    String transactionId,
    double delta,
  ) async {
    if (delta == 0) return;

    final tid = transactionId;
    final row = await ditto.store.execute(
      'SELECT subTotal FROM transactions WHERE _id = :tid OR id = :tid LIMIT 1',
      arguments: {'tid': tid},
    );
    if (row.items.isEmpty) return;

    final current =
        (Map<String, dynamic>.from(row.items.first.value)['subTotal'] as num?)
            ?.toDouble() ??
        0.0;
    final newSubTotal = current + delta;

    final now = DateTime.now().toIso8601String();
    await ditto.store.execute(
      'UPDATE transactions SET subTotal = :subTotal, updatedAt = :ua, lastTouched = :lt WHERE _id = :tid OR id = :tid',
      arguments: {'subTotal': newSubTotal, 'ua': now, 'lt': now, 'tid': tid},
    );
  }

  // TODO(ditto-migration): port `deleteTransactionByIndex` to Ditto.
  @override
  Future<int> deleteTransactionByIndex({
    required String transactionIndex,
  }) async {
    return ProxyService.legacyStrategy.deleteTransactionByIndex(
      transactionIndex: transactionIndex,
    );
  }

  @override
  Future<bool> flipperDelete({
    required String id,
    String? endPoint,
    HttpClientInterface? flipperHttpClient,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error("Ditto not initialized");
      return false;
    }

    if (endPoint == 'customer') {
      // The customer list is a live Ditto observer, so the row only disappears
      // once it leaves the Ditto store. Delete from Supabase (best effort) and
      // Ditto, mirroring the variant dual-store delete.
      try {
        await Supabase.instance.client.from('customers').delete().eq('id', id);
        talker.info('Deleted customer $id from Supabase');
      } catch (e) {
        talker.warning('Supabase customer delete skipped or failed: $e');
      }

      try {
        await ditto.store.execute(
          'DELETE FROM customers WHERE _id = :id OR id = :id',
          arguments: {'id': id},
        );
        talker.info('Deleted customer $id from Ditto');
        return true;
      } catch (e) {
        talker.error('Error deleting customer from Ditto: $e');
        return false;
      }
    }

    if (endPoint == 'transactionItem') {
      try {
        // Fetch the item first to get transactionId and line total for subTotal delta
        final fetchResult = await ditto.store.execute(
          "SELECT * FROM transaction_items WHERE _id = :id OR id = :id",
          arguments: {'id': id},
        );
        String? transactionId;
        double subtotalDelta = 0;
        if (fetchResult.items.isNotEmpty) {
          final data = Map<String, dynamic>.from(fetchResult.items.first.value);
          transactionId = data['transactionId'] as String?;
          final qty = (data['qty'] as num?)?.toDouble() ?? 0.0;
          final price = (data['price'] as num?)?.toDouble() ?? 0.0;
          subtotalDelta = -(price * qty);
        }

        const query =
            "DELETE FROM transaction_items WHERE _id = :id OR id = :id";
        await ditto.store.execute(query, arguments: {'id': id});

        if (transactionId != null) {
          await _adjustTransactionSubtotalByDelta(
            ditto,
            transactionId,
            subtotalDelta,
          );
        }
        return true;
      } catch (e) {
        talker.error("Error deleting transaction item: $e");
        return false;
      }
    }

    // 'variant' removes the variant and its stock only: product entry deletes
    // variant rows of a product it is about to save. 'catalogItem' is the POS
    // catalog's delete — the tile is the item, so a product left with no
    // variants goes too instead of lingering invisible but still syncing.
    if (endPoint == 'variant' || endPoint == 'catalogItem') {
      try {
        final removed = await deleteVariantDocs(ditto.store, variantId: id);
        final docs = [removed];
        String? emptiedProductId;
        final productId = removed.productId;
        if (endPoint == 'catalogItem' &&
            productId != null &&
            !await productHasVariants(ditto.store, productId)) {
          docs.addAll(
            await deleteProductDocs(ditto.store, productId: productId),
          );
          emptiedProductId = productId;
        }
        _forgetDeletedCatalogDocs(docs);
        talker.info('Deleted variant $id from Ditto');
        unawaited(
          _deleteCatalogRowsFromSupabase(docs, productId: emptiedProductId),
        );
        return true;
      } catch (e, s) {
        talker.error('Error deleting variant $id from Ditto: $e\n$s');
        return false;
      }
    }

    if (endPoint == 'product') {
      try {
        final docs = await deleteProductDocs(ditto.store, productId: id);
        _forgetDeletedCatalogDocs(docs);
        talker.info(
          'Deleted product $id and ${docs.length} variant(s) from Ditto',
        );
        unawaited(_deleteCatalogRowsFromSupabase(docs, productId: id));
        return true;
      } catch (e, s) {
        talker.error('Error deleting product $id from Ditto: $e\n$s');
        return false;
      }
    }

    if (endPoint == 'composite') {
      // `saveComposite` writes composites to Ditto.
      try {
        await ditto.store.execute(
          'DELETE FROM composites WHERE _id = :id OR id = :id',
          arguments: {'id': id},
        );
        return true;
      } catch (e) {
        talker.error('Error deleting composite $id from Ditto: $e');
        return false;
      }
    }
    return false;
  }

  void _forgetDeletedCatalogDocs(List<DeletedVariantDocs> docs) {
    deletedCatalogIds.addAll(docs.expand((d) => [d.variantId, d.stockId]));
  }

  /// Supabase keeps its own copy of the catalog: data-connector only forwards
  /// Ditto inserts, never deletes, and its imports/purchases approval reloads a
  /// variant from Supabase by id and writes it back into Ditto. Best effort and
  /// off the UI's path — the Ditto delete above is what the catalog reads.
  Future<void> _deleteCatalogRowsFromSupabase(
    List<DeletedVariantDocs> docs, {
    String? productId,
  }) async {
    try {
      final client = Supabase.instance.client;
      final stockIds = [
        for (final d in docs)
          if (d.stockId != null) d.stockId!,
      ];
      final variantIds = [for (final d in docs) d.variantId];
      if (stockIds.isNotEmpty) {
        await client.from('stocks').delete().inFilter('id', stockIds);
      }
      if (variantIds.isNotEmpty) {
        await client.from('variants').delete().inFilter('id', variantIds);
      }
      if (productId != null) {
        await client.from('variants').delete().eq('product_id', productId);
        await client.from('products').delete().eq('id', productId);
      }
      talker.info(
        'Deleted ${variantIds.length} variant(s)'
        '${productId != null ? ' and product $productId' : ''} from Supabase',
      );
    } catch (e) {
      talker.warning('Supabase catalog delete skipped or failed: $e');
    }
  }
}
