import 'dart:convert';

import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the customer is about to order: variant id → quantity. Immutable;
/// every change returns a new cart.
class ShopCart {
  const ShopCart([this.lines = const {}]);

  final Map<String, double> lines;

  bool get isEmpty => lines.isEmpty;

  double qty(String variantId) => lines[variantId] ?? 0;

  /// Number of units, for the "3 items" bar.
  double get count => lines.values.fold(0, (a, b) => a + b);

  /// Sets [variantId] to [qty], capped at [max] (the stock, when the shop
  /// shows it). Zero or less removes the line.
  ShopCart set(String variantId, double qty, {double? max}) {
    var next = qty;
    if (max != null && next > max) next = max;
    final copy = Map<String, double>.from(lines);
    if (next <= 0) {
      copy.remove(variantId);
    } else {
      copy[variantId] = next;
    }
    return ShopCart(copy);
  }

  ShopCart add(String variantId, {double? max}) =>
      set(variantId, qty(variantId) + 1, max: max);

  ShopCart remove(String variantId) => set(variantId, qty(variantId) - 1);

  ShopCart without(Iterable<String> variantIds) {
    final copy = Map<String, double>.from(lines);
    for (final id in variantIds) {
      copy.remove(id);
    }
    return ShopCart(copy);
  }

  /// Drops lines the catalog no longer sells or has run out of, and trims
  /// quantities to the stock shown. A cart saved yesterday can be stale.
  ShopCart reconcile(ShopCatalog catalog) {
    var next = const ShopCart();
    for (final entry in lines.entries) {
      final item = catalog.item(entry.key);
      if (item == null || !item.inStock) continue;
      next = next.set(entry.key, entry.value, max: item.maxQty);
    }
    return next;
  }

  double total(ShopCatalog catalog) {
    var sum = 0.0;
    for (final entry in lines.entries) {
      sum += (catalog.item(entry.key)?.price ?? 0) * entry.value;
    }
    return sum;
  }

  String encode() => jsonEncode(lines);

  static ShopCart decode(String? raw) {
    if (raw == null || raw.isEmpty) return const ShopCart();
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return const ShopCart();
      return ShopCart({
        for (final e in map.entries)
          if (e.value is num && (e.value as num) > 0)
            '${e.key}': (e.value as num).toDouble(),
      });
    } catch (_) {
      return const ShopCart();
    }
  }
}

/// The last order placed from this browser, so a refresh (or coming back
/// later) still finds it. The token is what lets this browser read it.
class ShopOrderLink {
  const ShopOrderLink({required this.id, required this.token});

  final String id;
  final String token;
}

/// Cart and order link per shop, in the browser's localStorage (through
/// shared_preferences). Every call swallows storage errors: private windows
/// and blocked storage must still be able to order.
class ShopStore {
  const ShopStore();

  static String cartKey(String slug) => 'shop_cart_$slug';
  static String orderKey(String slug) => 'shop_order_$slug';

  Future<ShopCart> loadCart(String slug) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return ShopCart.decode(prefs.getString(cartKey(slug)));
    } catch (_) {
      return const ShopCart();
    }
  }

  Future<void> saveCart(String slug, ShopCart cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (cart.isEmpty) {
        await prefs.remove(cartKey(slug));
      } else {
        await prefs.setString(cartKey(slug), cart.encode());
      }
    } catch (_) {
      // In-memory cart still works.
    }
  }

  Future<ShopOrderLink?> loadOrder(String slug) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(orderKey(slug));
      if (raw == null) return null;
      final map = jsonDecode(raw);
      if (map is! Map || map['id'] is! String || map['token'] is! String) {
        return null;
      }
      return ShopOrderLink(
        id: map['id'] as String,
        token: map['token'] as String,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveOrder(String slug, ShopOrderLink link) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        orderKey(slug),
        jsonEncode({'id': link.id, 'token': link.token}),
      );
    } catch (_) {
      // The order page URL still carries the token.
    }
  }

  Future<void> clearOrder(String slug) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(orderKey(slug));
    } catch (_) {}
  }
}

/// Which checkout field is wrong. The page maps these to messages.
enum ShopCheckoutError {
  nameRequired,
  phoneInvalid,
  payerPhoneInvalid,
  addressRequired,
  fulfilmentRequired,
  cartEmpty,
}

/// A phone number: 9 to 15 digits, optionally with a leading `+`
/// (spaces, dashes and brackets allowed). Shops are not only in Rwanda, so
/// no country format is enforced; the shop calls this number back.
bool isValidShopPhone(String phone) {
  final compact = phone.trim().replaceAll(RegExp(r'[\s\-()]'), '');
  return RegExp(r'^\+?\d{9,15}$').hasMatch(compact);
}

/// Checks the checkout form. Empty map means it can be submitted.
Map<String, ShopCheckoutError> validateShopCheckout({
  required String name,
  required String phone,
  required String payerPhone,
  required String? fulfilment,
  required String address,
  required bool cartEmpty,
}) {
  final errors = <String, ShopCheckoutError>{};
  if (cartEmpty) errors['cart'] = ShopCheckoutError.cartEmpty;
  if (name.trim().length < 2) errors['name'] = ShopCheckoutError.nameRequired;
  if (!isValidShopPhone(phone)) {
    errors['phone'] = ShopCheckoutError.phoneInvalid;
  }
  if (payerPhone.trim().isNotEmpty && !isValidShopPhone(payerPhone)) {
    errors['payerPhone'] = ShopCheckoutError.payerPhoneInvalid;
  }
  if (fulfilment == null) {
    errors['fulfilment'] = ShopCheckoutError.fulfilmentRequired;
  } else if (fulfilment == 'delivery' && address.trim().length < 3) {
    errors['address'] = ShopCheckoutError.addressRequired;
  }
  return errors;
}
