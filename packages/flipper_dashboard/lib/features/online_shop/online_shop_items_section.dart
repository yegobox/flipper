import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_widgets.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart' show Variant;
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The branch's local variants matching a search, for the hide/show list.
/// Tests override it.
final onlineShopVariantsProvider = FutureProvider.autoDispose
    .family<List<Variant>, String>((ref, search) {
      final branchId = ref.watch(onlineShopBranchIdProvider);
      if (branchId.isEmpty) return const <Variant>[];
      return ref.watch(
        variantProvider(
          branchId: branchId,
          key: search.isEmpty ? null : search,
        ).future,
      );
    });

/// How many rows the list draws; searching narrows it down.
const int kOnlineShopItemsShown = 60;

/// Searchable list of this branch's items with a "Show in online shop"
/// switch each. Hiding keeps the item in the catalog; only the public shop
/// leaves it out.
class OnlineShopItemsSection extends ConsumerStatefulWidget {
  const OnlineShopItemsSection({
    super.key,
    required this.hiddenVariantIds,
    required this.canEdit,
    required this.onHiddenChanged,
  });

  final Set<String> hiddenVariantIds;
  final bool canEdit;
  final ValueChanged<Set<String>> onHiddenChanged;

  @override
  ConsumerState<OnlineShopItemsSection> createState() =>
      _OnlineShopItemsSectionState();
}

class _OnlineShopItemsSectionState
    extends ConsumerState<OnlineShopItemsSection> {
  String _search = '';
  final Set<String> _saving = {};
  String? _error;

  Future<void> _toggle(Variant variant, bool show) async {
    final l10n = context.flipperL10n;
    setState(() {
      _saving.add(variant.id);
      _error = null;
    });
    try {
      final hidden = await ref
          .read(onlineShopClientProvider)
          .setHidden(
            branchId: ref.read(onlineShopBranchIdProvider),
            variantIds: [variant.id],
            hidden: !show,
          );
      widget.onHiddenChanged(hidden);
    } catch (e) {
      if (mounted) setState(() => _error = l10n.onlineShopError('$e'));
    } finally {
      if (mounted) setState(() => _saving.remove(variant.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final variants = ref.watch(onlineShopVariantsProvider(_search));
    return OnlineShopCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.onlineShopItemsHint,
            style: const TextStyle(fontSize: 13.5, color: PosTokens.ink2),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.onlineShopHiddenCount(widget.hiddenVariantIds.length),
            key: const Key('online_shop_hidden_count'),
            style: const TextStyle(fontSize: 13, color: PosTokens.ink3),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('online_shop_item_search'),
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              hintText: l10n.onlineShopSearchItems,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (v) => setState(() => _search = v.trim()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: PosTokens.lossInk)),
          ],
          const SizedBox(height: 8),
          variants.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: PosTokens.blue),
              ),
            ),
            error: (e, _) => Text(
              l10n.onlineShopError('$e'),
              style: const TextStyle(color: PosTokens.lossInk),
            ),
            data: (list) => Column(
              children: [
                for (final v in list.take(kOnlineShopItemsShown))
                  SwitchListTile.adaptive(
                    key: ValueKey('online_shop_item_${v.id}'),
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: PosTokens.blue,
                    title: Text(
                      _label(v),
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: PosTokens.ink1,
                      ),
                    ),
                    value: !widget.hiddenVariantIds.contains(v.id),
                    onChanged: widget.canEdit && !_saving.contains(v.id)
                        ? (show) => _toggle(v, show)
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _label(Variant v) {
    final product = v.productName?.trim() ?? '';
    if (product.isEmpty || product == v.name) return v.name;
    return '$product · ${v.name}';
  }
}
