import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Cart line list only — rebuilds on [posCartDisplayItemsProvider] without
/// repainting the rest of [QuickSellingView] (form, headers, payment).
class PosCartTableHost extends ConsumerWidget {
  const PosCartTableHost({
    super.key,
    required this.builder,
  });

  final Widget Function(List<TransactionItem> cartLines) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartLines = ref.watch(posCartDisplayItemsProvider);
    return builder(cartLines);
  }
}
