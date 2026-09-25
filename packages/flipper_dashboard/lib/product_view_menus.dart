import 'package:flipper_dashboard/product_sort_labels.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/product_sort_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Header menus and the stock-filter empty state for the POS product grid
/// ([ProductView]). Split out of product_view.dart to keep it reviewable; the
/// grid still owns the state — these widgets only report the chosen option.

/// The dropdown face shared by the header's sort and stock-filter menus.
class ProductHeaderMenuChip extends StatelessWidget {
  const ProductHeaderMenuChip({
    super.key,
    required this.label,
    required this.compact,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: compact ? Colors.white : PosTokens.surface,
        border: Border.all(
          color: compact
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15)
              : PosTokens.line,
        ),
        borderRadius: BorderRadius.circular(compact ? 10 : PosTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: compact ? FontWeight.w700 : FontWeight.w500,
              fontSize: compact ? 13 : 12.5,
              color: compact ? null : PosTokens.ink2,
            ),
          ),
          SizedBox(width: compact ? 4 : 6),
          Icon(
            FluentIcons.chevron_down_20_regular,
            size: compact ? 14 : 14,
            color: compact
                ? Theme.of(context).colorScheme.onSurface
                : PosTokens.ink3,
          ),
        ],
      ),
    );
  }
}

String posStockFilterLabel(BuildContext context, PosStockFilter filter) {
  final l10n = context.flipperL10n;
  switch (filter) {
    case PosStockFilter.inStock:
      return l10n.posStockFilterInStock;
    case PosStockFilter.outOfStock:
      return l10n.posStockFilterOutOfStock;
    case PosStockFilter.all:
      return l10n.posStockFilterAll;
  }
}

/// The POS stock view picker. [onSelected] is the grid's switch, which also
/// resets its paging.
class PosStockFilterMenu extends ConsumerWidget {
  const PosStockFilterMenu({
    super.key,
    required this.onSelected,
    this.compact = false,
  });

  final ValueChanged<PosStockFilter> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(posCatalogStockFilterProvider);
    return PopupMenuButton<PosStockFilter>(
      key: const Key('pos-stock-filter-menu'),
      child: ProductHeaderMenuChip(
        label: posStockFilterLabel(context, current),
        compact: compact,
      ),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return PosStockFilter.values.map((PosStockFilter filter) {
          return PopupMenuItem<PosStockFilter>(
            value: filter,
            child: Row(
              children: [
                if (filter == current)
                  Icon(
                    FluentIcons.checkmark_20_filled,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    posStockFilterLabel(context, filter),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

/// Shown when the stock filter, not an empty catalog, leaves nothing to
/// list — saying "no products yet" there would send the cashier off to add
/// products that already exist.
class PosStockFilterEmptyState extends StatelessWidget {
  const PosStockFilterEmptyState({
    super.key,
    required this.filter,
    required this.onSelected,
  });

  /// The stock view that came up empty.
  final PosStockFilter filter;
  final ValueChanged<PosStockFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.box_20_regular,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              filter == PosStockFilter.outOfStock
                  ? l10n.posStockFilterNoneOutOfStock
                  : l10n.posStockFilterNoneInStock,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.posStockFilterEmptyHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                PosStockFilterMenu(onSelected: onSelected),
                FilledButton.icon(
                  key: const Key('pos-stock-filter-show-all'),
                  onPressed: () => onSelected(PosStockFilter.all),
                  icon: const Icon(FluentIcons.apps_list_20_regular),
                  label: Text(l10n.posStockFilterShowAll),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSortMenu extends ConsumerWidget {
  const ProductSortMenu({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(productSortProvider);
    final l10n = context.flipperL10n;
    final label = compact
        ? currentSort.compactLabel(l10n)
        : currentSort.localizedLabel(l10n);
    return PopupMenuButton<ProductSortOption>(
      child: ProductHeaderMenuChip(label: label, compact: compact),
      onSelected: (ProductSortOption option) {
        ref.read(productSortProvider.notifier).set(option);
      },
      itemBuilder: (BuildContext context) {
        return ProductSortOption.values.map((ProductSortOption option) {
          return PopupMenuItem<ProductSortOption>(
            value: option,
            child: Row(
              children: [
                if (option == currentSort)
                  Icon(
                    FluentIcons.checkmark_20_filled,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    option.localizedLabel(context.flipperL10n),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
