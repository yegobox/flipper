import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show coreTransactionsStream;
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The branch the personal app reads and writes. A personal account has one.
final personalBranchIdProvider = Provider<String?>((ref) {
  final box = ref.watch(branchServicesProvider).box;
  final id = box.branchIdString() ?? box.getBranchId();
  return id == null || id.trim().isEmpty ? null : id.trim();
});

/// The month the personal app shows; starts at this month.
class PersonalMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => personalMonthStart(DateTime.now());

  void previous() => state = DateTime(state.year, state.month - 1);

  void next() {
    final now = personalMonthStart(DateTime.now());
    final candidate = DateTime(state.year, state.month + 1);
    if (!candidate.isAfter(now)) state = candidate;
  }

  bool get isCurrent => state == personalMonthStart(DateTime.now());
}

final personalMonthProvider = NotifierProvider<PersonalMonthNotifier, DateTime>(
  PersonalMonthNotifier.new,
);

/// Income and spending of the selected month, live from the same Capella
/// stream the Cash Book uses.
final personalMonthSummaryProvider =
    StreamProvider.autoDispose<PersonalMonthSummary>((ref) {
      final branchId = ref.watch(personalBranchIdProvider);
      if (branchId == null) return Stream.value(PersonalMonthSummary.empty);
      final month = ref.watch(personalMonthProvider);
      return coreTransactionsStream(
        ref,
        startDate: personalMonthStart(month),
        endDate: personalMonthEnd(month),
        branchId: branchId,
        forceRealData: true,
        includeParked: false,
      ).map(
        (all) => summarizePersonalMonth(
          all.map(personalMovementFrom).whereType<PersonalMovement>(),
        ),
      );
    });
