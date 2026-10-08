import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/services/purchase_supplier_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;

/// Approved purchases' bills by purchase id: what is still owed to each
/// supplier. One live query for the whole list, not one per row.
final purchaseBillsProvider =
    StreamProvider.autoDispose<Map<String, PurchaseBill>>((ref) {
      final businessId = PurchaseApprovalDeps.fromProxy().businessId;
      if (businessId == null || businessId.isEmpty) {
        return Stream.value(const {});
      }
      return PurchaseSupplierPayment.watchBills(businessId);
    });

/// Text typed into the purchases list's search box (mobile and desktop).
final purchaseSearchQueryProvider = StateProvider<String>((ref) => '');

/// Whether [purchase] matches [query]: every word must appear in the
/// supplier's name or TIN, the invoice number, or an item's name. Case is
/// ignored; an empty query matches everything.
bool purchaseMatchesQuery(model.Purchase purchase, String query) {
  final words = query.toLowerCase().split(RegExp(r'\s+'))
    ..removeWhere((w) => w.isEmpty);
  if (words.isEmpty) return true;
  final haystack = [
    purchase.spplrNm,
    purchase.spplrTin,
    '${purchase.spplrInvcNo}',
    for (final v in purchase.variants ?? const <model.Variant>[]) ...[
      v.name,
      v.itemNm ?? '',
    ],
  ].join(' ').toLowerCase();
  return words.every(haystack.contains);
}

/// Filters the purchases list by supplier, invoice number, TIN or item.
class PurchaseSearchField extends ConsumerStatefulWidget {
  const PurchaseSearchField({super.key});

  @override
  ConsumerState<PurchaseSearchField> createState() =>
      PurchaseSearchFieldState();
}

class PurchaseSearchFieldState extends ConsumerState<PurchaseSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(purchaseSearchQueryProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _set(String value) =>
      ref.read(purchaseSearchQueryProvider.notifier).state = value;

  @override
  Widget build(BuildContext context) {
    final hasText = ref.watch(purchaseSearchQueryProvider).isNotEmpty;
    return TextField(
      controller: _controller,
      onChanged: _set,
      textInputAction: TextInputAction.search,
      style: ImportPurchaseHelpers.text(size: 14, weight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: context.flipperL10n.purchaseSearchHint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: hasText
            ? IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  _controller.clear();
                  _set('');
                },
              )
            : null,
        isDense: true,
        filled: true,
        fillColor: ImportPurchaseTokens.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          borderSide: const BorderSide(color: ImportPurchaseTokens.line2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          borderSide: const BorderSide(color: ImportPurchaseTokens.line2),
        ),
      ),
    );
  }
}
