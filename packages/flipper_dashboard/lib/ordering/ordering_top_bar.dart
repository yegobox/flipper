import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_widgets.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Chrome above the three panes: where the order is going, and what it is.
class OrderingTopBar extends ConsumerWidget {
  const OrderingTopBar({
    super.key,
    required this.transaction,
    required this.supplier,
    required this.onBack,
    required this.onClearSupplier,
  });

  final ITransaction transaction;
  final Branch? supplier;
  final VoidCallback onBack;
  final VoidCallback onClearSupplier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branch = ref.watch(activeBranchProvider).value;
    final branchLabel = branch?.name?.trim().isNotEmpty == true
        ? branch!.name!
        : 'This branch';

    return Container(
      decoration: const BoxDecoration(
        color: OrderingTokens.surface,
        border: Border(bottom: BorderSide(color: OrderingTokens.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      // The hints are measured first as a fixed trailing child and the rest of
      // the bar shares one Expanded, so the title and a long supplier name
      // both elide instead of pushing the row past its width.
      child: Row(
        children: [
          OrderingIconButton(
            icon: Icons.chevron_left,
            tooltip: 'Back',
            onPressed: onBack,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New purchase order',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: OrderingTokens.screenTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_orderRef(transaction)} · $branchLabel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: OrderingTokens.monoMeta,
                      ),
                    ],
                  ),
                ),
                if (supplier != null) ...[
                  const SizedBox(width: 18),
                  Flexible(
                    child: _SupplierChip(
                      supplier: supplier!,
                      onClear: onClearSupplier,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Shortcut hints are only true where there is a keyboard to press,
          // and only shown where there is room for them.
          if (MediaQuery.sizeOf(context).width >= 1180) ...[
            const SizedBox(width: 18),
            const _ShortcutHint(key_: '/', label: 'search'),
            const SizedBox(width: 8),
            const _ShortcutHint(key_: '↵', label: 'add top match'),
          ],
        ],
      ),
    );
  }

  /// A reference the operator can quote back to the supplier.
  ///
  /// The pending purchase transaction is the order, so its number is the
  /// reference; a row minted without one falls back to the head of its id,
  /// which is stable for the life of the cart.
  static String _orderRef(ITransaction transaction) {
    final number = transaction.transactionNumber?.trim();
    if (number != null && number.isNotEmpty) return 'PO-$number';
    final id = transaction.id.replaceAll('-', '');
    final year = (transaction.createdAt ?? DateTime.now()).year;
    final tail = id.length >= 6 ? id.substring(0, 6) : id;
    return 'PO-$year-${tail.toUpperCase()}';
  }
}

class _SupplierChip extends StatelessWidget {
  const _SupplierChip({required this.supplier, required this.onClear});

  final Branch supplier;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final meta = _supplierMeta(supplier);
    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        right: 8,
        top: 7,
        bottom: 7,
      ),
      decoration: BoxDecoration(
        color: OrderingTokens.supplierBg,
        border: Border.all(color: OrderingTokens.supplierBorder),
        borderRadius: OrderingTokens.controlRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 16,
            color: OrderingTokens.supplierIcon,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              supplier.name ?? 'Supplier',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: OrderingTokens.sans,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: OrderingTokens.supplierInk,
                height: 1.2,
              ),
            ),
          ),
          if (meta != null) ...[
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                meta,
                overflow: TextOverflow.ellipsis,
                style: OrderingTokens.monoStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: OrderingTokens.supplierMeta,
                ),
              ),
            ),
          ],
          const SizedBox(width: 10),
          OrderingIconButton(
            icon: Icons.close,
            iconSize: 13,
            size: 22,
            radius: OrderingTokens.rMd,
            bordered: false,
            background: const Color(0x1A0E7490),
            hoverBackground: const Color(0x380E7490),
            foreground: OrderingTokens.supplierIcon,
            hoverForeground: OrderingTokens.supplierIcon,
            tooltip: 'Change supplier',
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

/// The handoff shows a TIN here. Branches carry no TIN on device, so the chip
/// and the picker both fall back to where the supplier is.
String? _supplierMeta(Branch supplier) {
  for (final candidate in [supplier.location, supplier.description]) {
    final value = candidate?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return null;
}

class _ShortcutHint extends StatelessWidget {
  const _ShortcutHint({required this.key_, required this.label});

  final String key_;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: const BoxDecoration(
        color: OrderingTokens.bg,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderingKbd(key_),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: OrderingTokens.sans,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: OrderingTokens.ink3,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
