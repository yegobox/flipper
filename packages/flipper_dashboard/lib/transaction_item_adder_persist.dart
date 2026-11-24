import 'dart:async';
import 'package:flipper_localize/flipper_localize.dart';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pending_cart_sale_session_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/sync/utils/combo_stock_lines.dart';
import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:synchronized/synchronized.dart';

final _persistLock = Lock();

/// When the last cart write released the persist lock.
///
/// The gap between one write finishing and the next starting is the number
/// that separates "the store is slow" from "the main isolate is busy": the
/// writes are serialized, so an idle queue means nothing was competing for the
/// lock, while a long gap with taps outstanding means the isolate was doing
/// something else (rebuilding the cart, converting every row an observer
/// replayed) instead of running the next write.
DateTime? _lastCartWriteFinishedAt;

/// Resolves once every cart write queued before this call has finished.
///
/// [Lock] is FIFO, so taking a turn behind the queued adds is the same thing as
/// waiting for them — no polling, no timeout, no dependency on the item stream
/// having replayed anything back to us.
Future<void> awaitQueuedCartWrites() => _persistLock.synchronized(() async {});

String? readPendingCartTransactionId(Ref ref, {required bool isExpense}) {
  final settlingId = readSettlingCartTransaction(ref, isExpense: isExpense)?.id;
  if (settlingId != null) return settlingId;

  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final fromStream = ref.read(pendingProv).value?.id;
  if (fromStream != null && fromStream.isNotEmpty) return fromStream;

  final fromCache = readCachedPendingCartTransaction(
    ref,
    isExpense: isExpense,
  )?.id;
  if (fromCache != null && fromCache.isNotEmpty) return fromCache;

  return ref.read(optimisticCartProvider).activeTransactionId;
}

Future<ITransaction?> resolvePendingTransactionForPersist({
  required Ref ref,
  required dynamic pendingProv,
  required bool isOrdering,
}) async {
  // A till ticket being collected owns every add until it is paid or parked.
  final settlingTxn = readSettlingCartTransaction(ref, isExpense: isOrdering);
  if (settlingTxn != null) return settlingTxn;

  var pendingTransaction = readCachedPendingCartTransaction(
    ref,
    isExpense: isOrdering,
  );
  pendingTransaction ??= ref.read(pendingProv).value;
  if (pendingTransaction == null || pendingTransaction.id.isEmpty) {
    pendingTransaction = await ref.read(pendingProv.future);
  }
  if (pendingTransaction != null && pendingTransaction.id.isNotEmpty) {
    writeCachedPendingCartTransaction(
      ref,
      isExpense: isOrdering,
      transaction: pendingTransaction,
    );
    ref
        .read(optimisticCartProvider.notifier)
        .bindPendingTransaction(pendingTransaction.id);
  }
  return pendingTransaction;
}

/// Combo recipes resolved for one cart, so later taps don't read them again.
///
/// Scoped to the pending transaction (with its branch and business): a new
/// cart starts empty. Holds each product's components (empty when it is not
/// a combo) and the product of each cart line read from its variant; bounded
/// so a long-lived cart can't grow it without limit. Stock is never cached.
class ComboRecipeCache {
  ComboRecipeCache({this.maxProducts = 64});

  /// Products kept at most; the least recently used go first.
  final int maxProducts;

  String? _scope;
  final _recipes = <String, List<Composite>>{};
  final _productOfVariant = <String, String?>{};

  /// Starts over unless [scope] is the cart the cache holds.
  void useScope(String scope) {
    if (_scope == scope) return;
    _scope = scope;
    _recipes.clear();
    _productOfVariant.clear();
  }

  List<Composite>? recipe(String productId) {
    final hit = _recipes.remove(productId);
    if (hit != null) _recipes[productId] = hit; // most recently used last
    return hit;
  }

  void putRecipe(String productId, List<Composite> components) {
    _recipes.remove(productId);
    _recipes[productId] = components;
    while (_recipes.length > maxProducts) {
      _recipes.remove(_recipes.keys.first);
    }
  }

  bool knowsProductOf(String variantId) =>
      _productOfVariant.containsKey(variantId);

  String? productOf(String variantId) => _productOfVariant[variantId];

  void putProductOf(String variantId, String? productId) {
    if (_productOfVariant.length >= maxProducts * 4) _productOfVariant.clear();
    _productOfVariant[variantId] = productId;
  }

  @visibleForTesting
  void clear() {
    _scope = null;
    _recipes.clear();
    _productOfVariant.clear();
  }
}

/// The till's [ComboRecipeCache] (one cart is open at a time).
@visibleForTesting
final comboRecipeCache = ComboRecipeCache();

/// What every combo in the cart takes of each stocked component
/// ([comboComponentNeeds]), with those components' variants. [tapped] counts
/// as in the cart even before its line shows. Local reads only (Ditto, then
/// Brick `localOnly`): a tap never waits on the network. A cart with no
/// service lines reads nothing. Recipes come from [comboRecipeCache] after
/// the first tap; each product is read once, and the component variants in
/// one batch.
Future<({Map<String, double> needs, Map<String, Variant> variants})>
_cartComboNeeds({
  required Ref ref,
  required dynamic capella,
  required String transactionId,
  required String? branchId,
  required String? businessId,
  Variant? tapped,
}) async {
  const none = (needs: <String, double>{}, variants: <String, Variant>{});
  if (branchId == null || businessId == null) return none;

  final productOfService = <String, String?>{};
  for (final line in ref.read(posCartDisplayItemsProvider)) {
    final vid = line.variantId;
    if (line.active == false || vid == null || vid.isEmpty) continue;
    if (!isServiceItemType(line.itemTyCd)) continue;
    final pid = line.productId;
    productOfService[vid] = pid != null && pid.isNotEmpty ? pid : null;
  }
  if (tapped != null) productOfService[tapped.id] = tapped.productId;
  if (productOfService.isEmpty) return none;

  final cache = comboRecipeCache
    ..useScope('$businessId/$branchId/$transactionId');
  final unknown = <String>[];
  for (final e in productOfService.entries) {
    if (e.value != null) continue;
    if (cache.knowsProductOf(e.key)) {
      productOfService[e.key] = cache.productOf(e.key);
    } else {
      unknown.add(e.key);
    }
  }
  if (unknown.isNotEmpty) {
    final Map<String, Variant> lineVariants = await capella
        .batchGetVariantsByIds(unknown);
    for (final vid in unknown) {
      final pid = lineVariants[vid]?.productId;
      productOfService[vid] = pid;
      cache.putProductOf(vid, pid);
    }
  }

  // One lookup per distinct product, then never again for this cart. A
  // combo with no components here yet is not cached: they may still sync.
  final recipes = <String, List<Composite>>{};
  for (final productId in productOfService.values.toSet()) {
    if (productId == null || productId.isEmpty) continue;
    var components = cache.recipe(productId);
    if (components == null) {
      final Product? product = await capella.getProduct(
        id: productId,
        branchId: branchId,
        businessId: businessId,
      );
      if (product?.isComposite != true) {
        components = const <Composite>[];
        cache.putRecipe(productId, components);
      } else {
        final List<Composite> read = await capella.composites(
          productId: productId,
          localOnly: true,
        );
        components = read;
        if (read.isNotEmpty) cache.putRecipe(productId, read);
      }
    }
    recipes[productId] = components;
  }

  final componentsByCombo = <String, List<Composite>>{
    for (final e in productOfService.entries)
      if ((recipes[e.value] ?? const <Composite>[]).isNotEmpty)
        e.key: recipes[e.value]!,
  };
  if (componentsByCombo.isEmpty) return none;

  final ids = componentsByCombo.values
      .expand((c) => c)
      .map((c) => c.variantId)
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  final Map<String, Variant> variants = await capella.batchGetVariantsByIds(
    ids,
  );
  final inCart = ref.read(posCartQtyByVariantIdProvider);
  return (
    needs: comboComponentNeeds(
      componentsByCombo: componentsByCombo,
      combosInCart: {
        for (final vid in componentsByCombo.keys)
          vid: (inCart[vid] ?? 0).toDouble(),
      },
      variantsById: variants,
    ),
    variants: variants,
  );
}

/// How much of [variantId] the combos already in the cart take.
Future<double> _takenByCartCombos({
  required Ref ref,
  required dynamic capella,
  required String transactionId,
  required String variantId,
  required String? branchId,
  required String? businessId,
}) async {
  final cart = await _cartComboNeeds(
    ref: ref,
    capella: capella,
    transactionId: transactionId,
    branchId: branchId,
    businessId: businessId,
  );
  return cart.needs[variantId] ?? 0;
}

/// Whether the components cover every combo now in the cart, tapped [variant]
/// included ([comboComponentsInStock]). True for a service that is not a
/// combo.
Future<bool> _comboComponentsInStock({
  required Ref ref,
  required dynamic capella,
  required String transactionId,
  required Variant variant,
  required String? branchId,
  required String? businessId,
}) async {
  final cart = await _cartComboNeeds(
    ref: ref,
    capella: capella,
    transactionId: transactionId,
    branchId: branchId,
    businessId: businessId,
    tapped: variant,
  );
  if (cart.needs.isEmpty) return true;
  final stockIds = cart.variants.values
      .map((v) => v.stockId)
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toList();
  final Map<String, Stock> stocks = stockIds.isEmpty
      ? <String, Stock>{}
      : await capella.batchGetStocksByIds(stockIds);
  return comboComponentsInStock(
    needs: cart.needs,
    variantsById: cart.variants,
    stocksById: stocks,
    inCartAlone: (id) => ref.read(posCartQtyForVariantProvider(id)).toDouble(),
  );
}

Future<bool> persistItemToTransaction({
  required Ref ref,
  required BuildContext context,
  required Variant variant,
  required bool isOrdering,
  required dynamic pendingProv,
  required ITransaction pendingTransaction,
  required int sessionAtStart,
  required bool cartOptimismApplied,
  String? businessId,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final branchId = pendingTransaction.branchId;

  // The product is not read here: a combo sells as one line like any item.
  final cachedStock = await _resolveStockForAdd(
    capella: capella,
    variant: variant,
    isOrdering: isOrdering,
  );

  if (!isOrdering) {
    final currentStock =
        cachedStock?.currentStock ?? variant.stock?.currentStock;
    if (variant.taxTyCd != "D" && !isServiceItemType(variant.itemTyCd)) {
      final allowSellingBelowStock = await locator<SettingsService>()
          .isAllowSellingBelowStock();
      final inCartQty = ref.read(posCartQtyForVariantProvider(variant.id));
      if (!allowSellingBelowStock &&
          (currentStock == null ||
              currentStock <= 0 ||
              currentStock < inCartQty ||
              currentStock <
                  inCartQty +
                      await _takenByCartCombos(
                        ref: ref,
                        capella: capella,
                        transactionId: pendingTransaction.id,
                        variantId: variant.id,
                        branchId: branchId,
                        businessId: businessId,
                      ))) {
        if (cartOptimismApplied) {
          ref
              .read(optimisticCartProvider.notifier)
              .rollbackPending(
                transactionId: pendingTransaction.id,
                variantId: variant.id,
              );
        }
        if (context.mounted) {
          showErrorNotification(
            context,
            context.flipperL10n.cartNotEnoughStock,
          );
        }
        return false;
      }
    }
    // A combo is a service, so the check above skips it; its components'
    // stock is what it sells (see expandComboLinesForStock).
    if (variant.taxTyCd != "D" &&
        isServiceItemType(variant.itemTyCd) &&
        !await locator<SettingsService>().isAllowSellingBelowStock() &&
        !await _comboComponentsInStock(
          ref: ref,
          capella: capella,
          transactionId: pendingTransaction.id,
          variant: variant,
          branchId: branchId,
          businessId: businessId,
        )) {
      if (cartOptimismApplied) {
        ref
            .read(optimisticCartProvider.notifier)
            .rollbackPending(
              transactionId: pendingTransaction.id,
              variantId: variant.id,
            );
      }
      if (context.mounted) {
        showErrorNotification(context, context.flipperL10n.cartNotEnoughStock);
      }
      return false;
    }
  }

  var itemAddAbortedStale = false;

  void rollbackStaleAddAttempt() {
    if (cartOptimismApplied) {
      ref
          .read(optimisticCartProvider.notifier)
          .rollbackPending(
            transactionId: pendingTransaction.id,
            variantId: variant.id,
          );
    }
  }

  var itemAddCancelled = false;
  // A `return` inside the lock leaves only its callback; the result is read
  // after it.
  var itemSaveFailed = false;

  final queuedAtLock = DateTime.now();
  await _persistLock.synchronized(() async {
    final lockSw = Stopwatch()..start();
    final grantedAt = DateTime.now();
    // Time this write spent behind the ones ahead of it...
    final lockWaitMs = grantedAt.difference(queuedAtLock).inMilliseconds;
    // ...as against time the queue sat idle with nothing running, which no
    // store call can account for.
    final idleMs = _lastCartWriteFinishedAt == null
        ? -1
        : grantedAt.difference(_lastCartWriteFinishedAt!).inMilliseconds;
    var storeMs = -1;
    // A `-` on the still-unsaved line asked for this add back. It already took
    // the qty out of the optimistic cart, so abort *without* rolling back again
    // — writing the row here is exactly what would re-inflate the qty.
    if (cartOptimismApplied &&
        ref
            .read(optimisticCartProvider.notifier)
            .consumeCancelledAdd(variant.id)) {
      itemAddCancelled = true;
      return;
    }

    if (ref.read(pendingCartSaleSessionProvider) != sessionAtStart) {
      rollbackStaleAddAttempt();
      itemAddAbortedStale = true;
      return;
    }

    final freshPending = ref.read(pendingProv).value;
    final streamMatchesTarget =
        freshPending != null &&
        freshPending.id == pendingTransaction.id &&
        freshPending.status == PENDING;

    if (!streamMatchesTarget) {
      // After Send-for-Review / Pay the pending stream can briefly still hold
      // the completed ticket (or loading). Rolling back here made the first
      // tap on the new cart appear then vanish. Trust the PENDING cart this
      // add was resolved against when it is still pending.
      if (pendingTransaction.status != PENDING ||
          pendingTransaction.id.isEmpty) {
        rollbackStaleAddAttempt();
        itemAddAbortedStale = true;
        return;
      }
    }

    final stock = cachedStock;

    // A combo (composite product) is one line at its own price, like any
    // item. Its components' stock moves when the sale is paid
    // (`expandComboLinesForStock`), not here.
    final storeSw = Stopwatch()..start();
    final saved = await capella.saveTransactionItem(
      variation: variant,
      doneWithTransaction: false,
      ignoreForReport: false,
      amountTotal: variant.retailPrice ?? 0,
      customItem: false,
      currentStock: stock?.currentStock ?? 0,
      pendingTransaction: pendingTransaction,
      partOfComposite: false,
    );
    storeMs = storeSw.elapsedMilliseconds;
    if (!saved) {
      // The write did not happen, so the ghost must not survive it. Left
      // standing it is a line the cashier can see, believes is in the cart,
      // and that no row backs — it inflates the on-screen total and the
      // reconciliation that retires ghosts can never fire for it.
      talker.warning(
        'saveTransactionItem returned false for variant=${variant.id} on '
        'txn=${pendingTransaction.id}; rolling the cart line back',
      );
      rollbackStaleAddAttempt();
      itemSaveFailed = true;
      return;
    }

    // Ghost clears only when transactionItemsStreamProvider itself reflects
    // the save (via the passive onStreamEmitted reconciliation) — a direct
    // Ditto read here used to confirm-and-clear faster, but that raced ahead
    // of the live stream the cart actually renders from: the ghost would
    // disappear before the real row was visible, flashing the cart empty.
    _lastCartWriteFinishedAt = DateTime.now();
    _logCartWriteTiming(
      ref: ref,
      storeMs: storeMs,
      lockHoldMs: lockSw.elapsedMilliseconds,
      lockWaitMs: lockWaitMs,
      idleMs: idleMs,
    );
  });

  if (itemAddCancelled) return false;
  if (itemAddAbortedStale) return false;
  if (itemSaveFailed) return false;
  return true;
}

/// Reports what one cart write cost, and what happened between writes.
///
/// A backlog that will not drain is either slow writes or a busy isolate, and
/// the two want opposite fixes. `store_ms` is the write itself, `wait_ms` is
/// time queued behind earlier writes, and `idle_ms` is dead time with nothing
/// running at all — which no store call can account for.
void _logCartWriteTiming({
  required Ref ref,
  required int storeMs,
  required int lockHoldMs,
  required int lockWaitMs,
  required int idleMs,
}) {
  final queued = ref.read(optimisticCartProvider.notifier).queuedAddCount;
  final lines = ref.read(posCartDisplayItemsProvider).length;
  final message =
      '[cart_write] store_ms=$storeMs lock_hold_ms=$lockHoldMs '
      'wait_ms=$lockWaitMs idle_ms=$idleMs queued=$queued lines=$lines';
  // A cart write is a handful of local store calls; a second is not a slow
  // write, it is a symptom, and it is what stalls Pay on a large cart.
  if (storeMs >= 1000 || idleMs >= 1000) {
    talker.warning(message);
  } else {
    talker.debug(message);
  }
}

Future<bool> handlePersistFailure({
  required Ref ref,
  required BuildContext context,
  required Object e,
  required StackTrace s,
  required Variant variant,
  required ITransaction? txn,
  required bool cartOptimismApplied,
}) async {
  var persistedForVariant = false;
  if (txn != null && txn.id.isNotEmpty && variant.id.isNotEmpty) {
    try {
      final existing = await ProxyService.getStrategy(
        Strategy.capella,
      ).getTransactionItem(transactionId: txn.id, variantId: variant.id);
      persistedForVariant =
          existing != null && existing.active != false && existing.qty > 0;
    } catch (_) {}
  }

  if (context.mounted) {
    if (txn != null && cartOptimismApplied) {
      ref
          .read(optimisticCartProvider.notifier)
          .rollbackPending(transactionId: txn.id, variantId: variant.id);
    }
  }

  if (persistedForVariant) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    return true;
  }

  if (!context.mounted) return false;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  GlobalErrorHandler.logError(
    s,
    type: 'ITEM-ADD-EXCEPTION',
    context: {
      'resultCode': e.toString(),
      'businessId': ProxyService.box.getBusinessId(),
      'variantId': variant.id,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
  showErrorNotification(context, context.flipperL10n.cartFailedToAddItem);
  return false;
}

Future<Stock?> _resolveStockForAdd({
  required dynamic capella,
  required Variant variant,
  required bool isOrdering,
}) {
  if (isOrdering || variant.id.isEmpty || variant.stockId == null) {
    return Future<Stock?>.value(null);
  }
  return capella.getStockById(id: variant.stockId!);
}
