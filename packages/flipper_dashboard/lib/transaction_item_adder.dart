import 'package:flipper_dashboard/providers/pos_cart_add_service.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Thin wrapper kept for scanner / legacy call sites.
class TransactionItemAdder {
  TransactionItemAdder(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  Future<bool> addItemToTransaction({
    required Variant variant,
    required bool isOrdering,
    Product? productHint,
    bool isCompositeProduct = false,
  }) async {
    ref.read(posCartAddServiceProvider).tapAdd(
      context: context,
      variant: variant,
      isOrdering: isOrdering,
      product: productHint,
      isComposite: isCompositeProduct,
    );
    return true;
  }
}
