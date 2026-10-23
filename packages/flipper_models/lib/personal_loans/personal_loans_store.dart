import 'dart:async';

import 'package:flipper_models/account_mode/account_mode_providers.dart'
    show accountModeStoreProvider;
import 'package:flipper_models/personal_loans/loan_math.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart'
    show usableDittoProvider;
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Writes loans and repayments. Tests override [personalLoansStoreProvider].
abstract interface class PersonalLoansStore {
  Future<void> saveLoan(PersonalLoan loan);
  Future<void> deleteLoan(PersonalLoan loan);
  Future<void> addPayment(PersonalLoanPayment payment);
  Future<void> deletePayment(PersonalLoanPayment payment);
}

class DittoPersonalLoansStore implements PersonalLoansStore {
  const DittoPersonalLoansStore();

  Future<void> _upsert(String collection, Map<String, dynamic> doc) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) throw StateError('Ditto is not ready');
    await ditto.store.execute(
      'INSERT INTO $collection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  Future<void> _delete(String collection, String id) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) throw StateError('Ditto is not ready');
    // A soft delete, so the removal syncs to every device of the business.
    await ditto.store.execute(
      'UPDATE $collection SET deletedAt = :at WHERE _id = :id',
      arguments: {'id': id, 'at': DateTime.now().toUtc().toIso8601String()},
    );
  }

  @override
  Future<void> saveLoan(PersonalLoan loan) =>
      _upsert(kPersonalLoansCollection, loan.toDitto());

  @override
  Future<void> deleteLoan(PersonalLoan loan) =>
      _delete(kPersonalLoansCollection, loan.id);

  @override
  Future<void> addPayment(PersonalLoanPayment payment) =>
      _upsert(kPersonalLoanPaymentsCollection, payment.toDitto());

  @override
  Future<void> deletePayment(PersonalLoanPayment payment) =>
      _delete(kPersonalLoanPaymentsCollection, payment.id);
}

final personalLoansStoreProvider = Provider<PersonalLoansStore>(
  (ref) => const DittoPersonalLoansStore(),
);

/// The business whose loans are shown: the active one.
final personalLoansBusinessIdProvider = Provider<String?>(
  (ref) => ref.watch(accountModeStoreProvider).activeBusinessId(),
);

Stream<List<Map<String, dynamic>>> _observe(
  Ref ref,
  String collection,
  String businessId,
) {
  final ditto = ref.watch(usableDittoProvider).value;
  if (ditto == null) return Stream.value(const []);
  final query =
      'SELECT * FROM $collection WHERE businessId = :businessId '
      'AND (deletedAt IS NULL OR deletedAt IS MISSING)';
  final args = {'businessId': businessId};
  try {
    final prepared = prepareDqlSyncSubscription(query, args);
    ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
  } catch (_) {
    // The observer still reads what is already on this device.
  }
  final controller = StreamController<List<Map<String, dynamic>>>();
  final observer = ditto.store.registerObserver(
    query,
    arguments: args,
    onChange: (result) {
      if (controller.isClosed) return;
      controller.add([
        for (final i in result.items) Map<String, dynamic>.from(i.value),
      ]);
    },
  );
  ref.onDispose(() async {
    observer.cancel();
    await controller.close();
  });
  return controller.stream;
}

final personalLoansProvider = StreamProvider.autoDispose<List<PersonalLoan>>((
  ref,
) {
  final businessId = ref.watch(personalLoansBusinessIdProvider);
  if (businessId == null) return Stream.value(const []);
  return _observe(ref, kPersonalLoansCollection, businessId).map(
    (docs) =>
        docs.map(PersonalLoan.fromDitto).where((l) => l.id.isNotEmpty).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
  );
});

final personalLoanPaymentsProvider =
    StreamProvider.autoDispose<List<PersonalLoanPayment>>((ref) {
      final businessId = ref.watch(personalLoansBusinessIdProvider);
      if (businessId == null) return Stream.value(const []);
      return _observe(ref, kPersonalLoanPaymentsCollection, businessId).map(
        (docs) =>
            docs
                .map(PersonalLoanPayment.fromDitto)
                .where((p) => p.id.isNotEmpty && p.amount > 0)
                .toList()
              ..sort((a, b) => b.paidAt.compareTo(a.paidAt)),
      );
    });

/// Every loan with its balance and outlook, as of now.
final personalLoansOverviewProvider = Provider.autoDispose<LoansOverview>((
  ref,
) {
  final loans = ref.watch(personalLoansProvider).value ?? const [];
  final payments = ref.watch(personalLoanPaymentsProvider).value ?? const [];
  final now = DateTime.now();
  return loansOverview([for (final l in loans) loanStatus(l, payments, now)]);
});
