import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Store Books bill payments are written to.
final billPaymentStoreProvider = Provider<AccountingDittoStore>(
  (ref) => ref.watch(dittoServiceProvider),
);

/// Where a Books "Pay bill" on a bill shows as a cash-out: a purchase's bill
/// shows with that purchase's branch's expenses (else the selected branch),
/// like a payment made on the till. Null for bills not raised from a
/// purchase.
final booksBillCashOutProvider =
    Provider<Future<BillPaymentCashOut?> Function(String billDocId)>(
      (ref) =>
          (billDocId) => BillPaymentPoster(ref.read(billPaymentStoreProvider))
              .purchaseCashOut(
                billDocId,
                agentId: ref.read(userProfileCacheProvider)?.id,
                fallbackBranchId: ref.read(selectedBranchProvider)?.id,
              ),
    );
