import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_cart.dart';
import 'package:flipper_web/features/shop/shop_catalog_page.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flipper_web/features/shop/shop_providers.dart';
import 'package:flipper_web/features/shop/shop_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

/// `/shop/:slug/checkout`: the cart, the customer's details, place order.
class ShopCheckoutPage extends ConsumerStatefulWidget {
  const ShopCheckoutPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<ShopCheckoutPage> createState() => _ShopCheckoutPageState();
}

class _ShopCheckoutPageState extends ConsumerState<ShopCheckoutPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _payer = TextEditingController();
  final _address = TextEditingController();
  final _note = TextEditingController();
  String? _fulfilment;
  bool _payerEdited = false;
  bool _busy = false;
  String? _error;
  Map<String, ShopCheckoutError> _errors = const {};

  /// One key per checkout attempt: a retry after a lost response reuses it,
  /// so the server returns the same order instead of making a second one.
  /// Reset whenever the cart changes.
  String? _idempotencyKey;

  @override
  void dispose() {
    for (final c in [_name, _phone, _payer, _address, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit(ShopCatalog catalog, ShopCart cart) async {
    final l10n = context.flipperL10n;
    final shop = catalog.shop;
    final fulfilment =
        _fulfilment ??
        (shop.pickup && !shop.delivery
            ? 'pickup'
            : (!shop.pickup && shop.delivery ? 'delivery' : null));
    final errors = validateShopCheckout(
      name: _name.text,
      phone: _phone.text,
      payerPhone: _payer.text,
      fulfilment: fulfilment,
      address: _address.text,
      cartEmpty: cart.isEmpty,
    );
    setState(() {
      _errors = errors;
      _error = null;
    });
    if (errors.isNotEmpty) return;
    _idempotencyKey ??= const Uuid().v4();
    setState(() => _busy = true);
    try {
      final order = await ref
          .read(shopApiProvider)
          .placeOrder(
            widget.slug,
            ShopOrderRequest(
              customerName: _name.text,
              customerPhone: _phone.text,
              fulfilment: fulfilment!,
              deliveryAddress: fulfilment == 'delivery' ? _address.text : null,
              note: _note.text,
              payerPhone: _payer.text.trim().isEmpty
                  ? _phone.text
                  : _payer.text,
              items: [
                for (final e in cart.lines.entries)
                  ShopOrderRequestLine(variantId: e.key, qty: e.value),
              ],
              idempotencyKey: _idempotencyKey!,
            ),
          );
      // The link's secret is the server's, from this answer only; never the
      // checkout key.
      final token = order.token;
      if (token == null || token.isEmpty) throw const ShopApiException(500);
      await ref
          .read(shopStoreProvider)
          .saveOrder(widget.slug, ShopOrderLink(id: order.id, token: token));
      ref.read(shopCartProvider(widget.slug).notifier).clear();
      if (!mounted) return;
      context.go(shopOrderLocation(widget.slug, order.id, token));
    } on ShopApiException catch (e) {
      if (!mounted) return;
      if (e.itemUnavailable) {
        ref.read(shopCartProvider(widget.slug).notifier).drop(e.variantIds);
        ref.invalidate(shopCatalogProvider(widget.slug));
        _idempotencyKey = null;
      }
      setState(() => _error = shopCheckoutErrorText(l10n, e));
    } catch (_) {
      if (mounted) setState(() => _error = l10n.shopErrGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final catalog = ref.watch(shopCatalogProvider(widget.slug));
    ref.listen(shopCartProvider(widget.slug), (_, __) {
      _idempotencyKey = null;
    });
    return Scaffold(
      backgroundColor: kShopCanvas,
      appBar: AppBar(
        backgroundColor: kShopCanvas,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.shopCheckoutTitle),
        leading: IconButton(
          tooltip: l10n.shopBackToShop,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/shop/${widget.slug}'),
        ),
      ),
      body: catalog.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kShopBlue)),
        error: (e, _) => ShopMessage(
          text: l10n.shopLoadFailed,
          onRetry: () => ref.invalidate(shopCatalogProvider(widget.slug)),
        ),
        data: (c) => _form(context, c),
      ),
    );
  }

  Widget _form(BuildContext context, ShopCatalog catalog) {
    final l10n = context.flipperL10n;
    final cart = ref.watch(shopCartProvider(widget.slug));
    final notifier = ref.read(shopCartProvider(widget.slug).notifier);
    final shop = catalog.shop;
    final currency = shop.currency;
    String? err(String field) => switch (_errors[field]) {
      ShopCheckoutError.nameRequired => l10n.shopErrName,
      ShopCheckoutError.phoneInvalid ||
      ShopCheckoutError.payerPhoneInvalid => l10n.shopErrPhone,
      ShopCheckoutError.addressRequired => l10n.shopErrAddress,
      ShopCheckoutError.fulfilmentRequired => l10n.shopErrFulfilment,
      _ => null,
    };
    final fulfilment =
        _fulfilment ??
        (shop.pickup && !shop.delivery
            ? 'pickup'
            : (!shop.pickup && shop.delivery ? 'delivery' : null));

    return SafeArea(
      child: ShopBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _SectionTitle(l10n.shopYourCart),
            if (cart.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.shopCartEmpty),
              ),
            for (final entry in cart.lines.entries)
              if (catalog.item(entry.key) case final item?)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              shopMoney(item.price * entry.value, currency),
                              style: const TextStyle(color: kShopMuted),
                            ),
                          ],
                        ),
                      ),
                      ShopStepper(
                        qty: entry.value,
                        addLabel: l10n.shopAdd,
                        canAdd:
                            item.maxQty == null || entry.value < item.maxQty!,
                        onAdd: () => notifier.add(item),
                        onRemove: () => notifier.remove(item),
                        editLabel: l10n.shopQtyEdit,
                        onEditQty: item.soldByMeasure
                            ? () => editShopQty(
                                context,
                                ref,
                                widget.slug,
                                item,
                                entry.value,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.shopTotal,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  shopMoney(cart.total(catalog), currency),
                  key: const Key('shop_checkout_total'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            _SectionTitle(l10n.shopYourDetails),
            _field(_name, l10n.shopName, key: 'shop_name', error: err('name')),
            _field(
              _phone,
              l10n.shopPhone,
              key: 'shop_phone',
              phone: true,
              error: err('phone'),
              onChanged: (v) {
                if (!_payerEdited) _payer.text = v;
              },
            ),
            if (shop.pickup && shop.delivery) ...[
              SegmentedButton<String>(
                key: const Key('shop_fulfilment'),
                segments: [
                  ButtonSegment(value: 'pickup', label: Text(l10n.shopPickup)),
                  ButtonSegment(
                    value: 'delivery',
                    label: Text(l10n.shopDelivery),
                  ),
                ],
                emptySelectionAllowed: true,
                selected: {if (fulfilment != null) fulfilment},
                onSelectionChanged: (s) =>
                    setState(() => _fulfilment = s.isEmpty ? null : s.first),
              ),
              if (err('fulfilment') != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    err('fulfilment')!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),
            ],
            if (fulfilment == 'delivery') ...[
              _field(
                _address,
                l10n.shopDeliveryAddress,
                key: 'shop_address',
                error: err('address'),
                hint: shop.deliveryNote,
              ),
            ],
            _field(_note, l10n.shopNote, key: 'shop_note', lines: 2),
            if (shop.payment.momo)
              _field(
                _payer,
                l10n.shopPayerPhone,
                key: 'shop_payer_phone',
                phone: true,
                hint: l10n.shopPayerPhoneHint,
                error: err('payerPhone'),
                onChanged: (_) => _payerEdited = true,
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  key: const Key('shop_checkout_error'),
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('shop_place_order'),
              style: shopPrimaryButton(),
              onPressed: _busy || cart.isEmpty
                  ? null
                  : () => _submit(catalog, cart),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.shopPlaceOrder),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    required String key,
    String? error,
    String? hint,
    bool phone = false,
    int lines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        key: Key(key),
        controller: controller,
        keyboardType: phone ? TextInputType.phone : null,
        maxLines: lines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          helperText: hint,
          helperMaxLines: 3,
          errorText: error,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

/// What to tell the customer when placing the order failed. The server's
/// messages are generic, so the status says what happened.
String shopCheckoutErrorText(FlipperAppLocalizations l10n, ShopApiException e) {
  if (e.itemUnavailable) return l10n.shopErrUnavailable;
  if (e.tooManyOpen) return l10n.shopErrTooManyOpen;
  if (e.rateLimited) return l10n.shopErrRateLimited;
  if (e.tooLarge) return l10n.shopErrTooLarge;
  if (e.alreadyPlaced) return l10n.shopErrAlreadyPlaced;
  if (e.busy) return l10n.shopErrBusy;
  if (e.invalid) return l10n.shopErrInvalid;
  if (e.offline) return l10n.shopErrOffline;
  return l10n.shopErrGeneric;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: kShopInk,
        ),
      ),
    );
  }
}
