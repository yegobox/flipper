import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_cart.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flipper_web/features/shop/shop_providers.dart';
import 'package:flipper_web/features/shop/shop_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// `/shop/:slug`: a business's public catalog. Anyone with the link can
/// browse and fill a cart; no sign-in.
class ShopCatalogPage extends ConsumerStatefulWidget {
  const ShopCatalogPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<ShopCatalogPage> createState() => _ShopCatalogPageState();
}

class _ShopCatalogPageState extends ConsumerState<ShopCatalogPage> {
  String _search = '';
  String? _category;
  ShopOrderLink? _openOrder;

  @override
  void initState() {
    super.initState();
    ref.read(shopStoreProvider).loadOrder(widget.slug).then((link) {
      if (mounted && link != null) setState(() => _openOrder = link);
    });
  }

  List<ShopItem> _visible(ShopCatalog catalog) {
    final q = _search.toLowerCase();
    return catalog.items.where((i) {
      if (_category != null && i.categoryId != _category) return false;
      return q.isEmpty || i.name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final catalog = ref.watch(shopCatalogProvider(widget.slug));
    ref.listen(shopCatalogProvider(widget.slug), (_, next) {
      final value = next.value;
      if (value != null) {
        ref.read(shopCartProvider(widget.slug).notifier).reconcile(value);
      }
    });
    return Scaffold(
      backgroundColor: kShopCanvas,
      body: catalog.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kShopBlue)),
        error: (e, _) => ShopMessage(
          text: e is ShopApiException && e.notFound
              ? l10n.shopNotFound
              : l10n.shopLoadFailed,
          onRetry: () => ref.invalidate(shopCatalogProvider(widget.slug)),
        ),
        data: (c) => _content(context, c),
      ),
      bottomNavigationBar: catalog.value == null
          ? null
          : _CartBar(slug: widget.slug, catalog: catalog.value!),
    );
  }

  Widget _content(BuildContext context, ShopCatalog catalog) {
    final l10n = context.flipperL10n;
    final items = _visible(catalog);
    return SafeArea(
      child: ShopBody(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ShopHeader(shop: catalog.shop)),
            if (_openOrder != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Material(
                    color: kShopBlueTint,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      key: const Key('shop_open_order'),
                      leading: const Icon(
                        Icons.receipt_long_outlined,
                        color: kShopBlue,
                      ),
                      title: Text(l10n.shopYourOrderInProgress),
                      trailing: Text(
                        l10n.shopViewOrder,
                        style: const TextStyle(
                          color: kShopBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => context.go(
                        shopOrderLocation(
                          widget.slug,
                          _openOrder!.id,
                          _openOrder!.token,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  key: const Key('shop_search'),
                  decoration: InputDecoration(
                    hintText: l10n.shopSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kShopLine),
                    ),
                  ),
                  onChanged: (v) => setState(() => _search = v.trim()),
                ),
              ),
            ),
            if (catalog.categories.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _chip(l10n.shopAllCategories, null),
                      for (final c in catalog.categories) _chip(c.name, c.id),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ItemCard(
                    slug: widget.slug,
                    item: items[i],
                    currency: catalog.shop.currency,
                  ),
                  childCount: items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String? id) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _category == id,
        selectedColor: kShopBlueTint,
        labelStyle: TextStyle(
          color: _category == id ? kShopBlue : kShopInk,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) => setState(() => _category = id),
      ),
    );
  }
}

/// `/shop/<slug>/order/<id>?t=<token>`.
String shopOrderLocation(String slug, String id, String token) => Uri(
  path: '/shop/$slug/order/$id',
  queryParameters: {'t': token},
).toString();

/// Logo, name and description at the top of every shop page.
class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key, required this.shop});

  final ShopInfo shop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shop.logoUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                shop.logoUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(width: 56),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kShopInk,
                  ),
                ),
                if (shop.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    shop.description!,
                    style: const TextStyle(fontSize: 14, color: kShopMuted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends ConsumerWidget {
  const _ItemCard({
    required this.slug,
    required this.item,
    required this.currency,
  });

  final String slug;
  final ShopItem item;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final qty = ref.watch(
      shopCartProvider(slug).select((cart) => cart.qty(item.id)),
    );
    final cart = ref.read(shopCartProvider(slug).notifier);
    final max = item.maxQty;
    return Container(
      key: ValueKey('shop_item_${item.id}'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kShopLine),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: item.imageUrl == null
                ? const _ImagePlaceholder()
                : Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kShopInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  shopMoney(item.price, currency),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kShopInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  !item.inStock
                      ? l10n.shopOutOfStock
                      : max != null
                      ? l10n.shopStockLeft(shopQty(max))
                      : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.inStock ? kShopMuted : Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                if (item.inStock)
                  ShopStepper(
                    qty: qty,
                    addLabel: l10n.shopAdd,
                    canAdd: max == null || qty < max,
                    onAdd: () => cart.add(item),
                    onRemove: () => cart.remove(item),
                    editLabel: l10n.shopQtyEdit,
                    onEditQty: item.soldByMeasure
                        ? () => editShopQty(context, ref, slug, item, qty)
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: kShopCanvas,
    child: Center(
      child: Icon(Icons.shopping_bag_outlined, color: kShopMuted, size: 32),
    ),
  );
}

class _CartBar extends ConsumerWidget {
  const _CartBar({required this.slug, required this.catalog});

  final String slug;
  final ShopCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(shopCartProvider(slug));
    if (cart.isEmpty) return const SizedBox.shrink();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ShopBody(
          shrinkHeight: true,
          child: FilledButton(
            key: const Key('shop_view_cart'),
            style: shopPrimaryButton(),
            onPressed: () => context.go('/shop/$slug/checkout'),
            child: Text(
              context.flipperL10n.shopViewCart(
                shopQty(cart.count),
                shopMoney(cart.total(catalog), catalog.shop.currency),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Asks how much of [item] (sold by weight or volume) to order, e.g. 1.5,
/// and puts that in the cart.
Future<void> editShopQty(
  BuildContext context,
  WidgetRef ref,
  String slug,
  ShopItem item,
  double current,
) async {
  final qty = await showDialog<double>(
    context: context,
    builder: (_) => _QtyDialog(item: item, current: current),
  );
  if (qty != null) {
    ref.read(shopCartProvider(slug).notifier).setQty(item, qty);
  }
}

class _QtyDialog extends StatefulWidget {
  const _QtyDialog({required this.item, required this.current});

  final ShopItem item;
  final double current;

  @override
  State<_QtyDialog> createState() => _QtyDialogState();
}

class _QtyDialogState extends State<_QtyDialog> {
  late final _text = TextEditingController(text: shopQty(widget.current));
  bool _invalid = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _save() {
    final qty = double.tryParse(_text.text.trim().replaceAll(',', '.'));
    if (qty == null || !widget.item.allowsQty(qty)) {
      setState(() => _invalid = true);
      return;
    }
    Navigator.of(context).pop(qty);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return AlertDialog(
      title: Text(l10n.shopQtyTitle),
      content: TextField(
        key: const Key('shop_qty_field'),
        controller: _text,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: widget.item.name,
          errorText: _invalid ? l10n.shopQtyInvalid : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          key: const Key('shop_qty_save'),
          style: FilledButton.styleFrom(backgroundColor: kShopBlue),
          onPressed: _save,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}

/// Full-page message with an optional retry.
class ShopMessage extends StatelessWidget {
  const ShopMessage({super.key, required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront_outlined, size: 40, color: kShopMuted),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: kShopInk),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: kShopBlue),
                onPressed: onRetry,
                child: Text(context.flipperL10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
