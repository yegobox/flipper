import 'dart:async';

import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_cart.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopApiProvider = Provider<ShopApi>((ref) => ShopApi());

final shopStoreProvider = Provider<ShopStore>((ref) => const ShopStore());

/// The public catalog of the shop at [slug].
final shopCatalogProvider = FutureProvider.autoDispose
    .family<ShopCatalog, String>(
      (ref, slug) => ref.watch(shopApiProvider).catalog(slug),
    );

/// The cart for the shop at [slug]. Starts empty, picks up what this browser
/// saved, and saves every change.
final shopCartProvider =
    NotifierProvider.family<ShopCartNotifier, ShopCart, String>(
      ShopCartNotifier.new,
    );

class ShopCartNotifier extends Notifier<ShopCart> {
  ShopCartNotifier(this.slug);

  final String slug;
  bool _touched = false;

  @override
  ShopCart build() {
    final store = ref.watch(shopStoreProvider);
    unawaited(
      store.loadCart(slug).then((saved) {
        // A tap before storage answered wins over the saved cart.
        if (!_touched && ref.mounted) state = saved;
      }),
    );
    return const ShopCart();
  }

  void _set(ShopCart cart) {
    _touched = true;
    state = cart;
    unawaited(ref.read(shopStoreProvider).saveCart(slug, cart));
  }

  void add(ShopItem item) =>
      _set(state.add(item.id, max: item.maxQty, whole: !item.soldByMeasure));

  void remove(ShopItem item) =>
      _set(state.remove(item.id, whole: !item.soldByMeasure));

  /// A typed amount, for items sold by weight or volume (1.5 kg).
  void setQty(ShopItem item, double qty) => _set(
    state.set(item.id, qty, max: item.maxQty, whole: !item.soldByMeasure),
  );

  void drop(Iterable<String> variantIds) => _set(state.without(variantIds));

  void reconcile(ShopCatalog catalog) {
    final next = state.reconcile(catalog);
    if (next.lines.length != state.lines.length || next.count != state.count) {
      _set(next);
    }
  }

  void clear() => _set(const ShopCart());
}
