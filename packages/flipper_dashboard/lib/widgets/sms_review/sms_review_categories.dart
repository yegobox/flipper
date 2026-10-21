import 'package:flipper_dashboard/cashbook_form_rules.dart'
    show cashbookLastCategoryKey, findCashbookCategoryByName;
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart'
    show kPersonalExpenseCategories, kPersonalIncomeCategories;
import 'package:flipper_models/db_model_export.dart' show Category;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// What money coming into a business account usually is. Category names are
/// shared data (every user sees the same row), so they are not translated,
/// like the seeded Transport / Airtime / Salary.
const kSmsIncomeCategories = [
  'Sales',
  'Customer payment',
  'Loan received',
  'Owner deposit',
  'Other income',
];

/// What money leaving a business account usually pays for.
const kSmsExpenseCategories = [
  'Salary',
  'Rent',
  'Supplies',
  'Transport',
  'Utilities',
  'Airtime',
  'Bank charges',
];

/// Product-catalogue defaults that never describe a bank movement.
const _productDefaults = {'main', 'uncategorized'};

/// One category chip: an existing category, or a suggestion ([id] null) that
/// is created when the SMS is confirmed with it.
typedef SmsCategoryChoice = ({String name, String? id});

/// The direction's [suggested] categories first (matched by name to the
/// branch's own, else offered as new), then the branch's [more] categories.
typedef SmsCategoryChoices = ({
  List<SmsCategoryChoice> suggested,
  List<SmsCategoryChoice> more,
});

/// [personal] suggests what personal money comes from and goes on instead of
/// the business lists (personal mode, `docs/personal_mode.md`).
SmsCategoryChoices smsCategoryChoices({
  required bool isIncome,
  required Iterable<Category> branch,
  bool personal = false,
}) {
  final usable = [
    for (final c in branch)
      if (c.deletedAt == null &&
          (c.name?.trim().isNotEmpty ?? false) &&
          !_productDefaults.contains(c.name!.trim().toLowerCase()))
        c,
  ];
  final suggested = <SmsCategoryChoice>[
    for (final name in switch ((personal, isIncome)) {
      (true, true) => kPersonalIncomeCategories,
      (true, false) => kPersonalExpenseCategories,
      (false, true) => kSmsIncomeCategories,
      (false, false) => kSmsExpenseCategories,
    })
      switch (findCashbookCategoryByName(
        usable,
        name,
        name: (c) => c.name ?? '',
      )) {
        final Category c => (name: c.name!.trim(), id: c.id),
        null => (name: name, id: null),
      },
  ];
  final seen = {for (final s in suggested) s.name.toLowerCase()};
  final more = <SmsCategoryChoice>[];
  for (final c in usable) {
    final name = c.name!.trim();
    if (seen.add(name.toLowerCase())) more.add((name: name, id: c.id));
  }
  more.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return (suggested: suggested, more: more);
}

/// Creates categories picked from the SMS sheet and remembers the last one
/// per direction (the Cash Book's own keys, so both forms agree). Tests
/// override it.
class SmsCategoryStore {
  const SmsCategoryStore(this._ref);

  final Ref _ref;

  /// Creates [name] at [branchId] and returns its id.
  Future<String> create(String name, String branchId) async {
    final services = _ref.read(branchServicesProvider);
    final now = DateTime.now().toUtc();
    final draft = Category(
      name: name,
      branchId: branchId,
      active: true,
      focused: false,
    );
    await services.strategy.addCategory(
      id: draft.id,
      name: name,
      branchId: branchId,
      active: true,
      focused: false,
      lastTouched: now,
      createdAt: now,
      deletedAt: null,
    );
    _ref.invalidate(categoryProvider);
    return draft.id;
  }

  String? lastUsed({required bool isIncome}) {
    try {
      return _ref
          .read(branchServicesProvider)
          .box
          .readString(key: cashbookLastCategoryKey(isIncome: isIncome));
    } catch (_) {
      return null;
    }
  }

  Future<void> remember(String id, {required bool isIncome}) async {
    try {
      await _ref
          .read(branchServicesProvider)
          .box
          .writeString(
            key: cashbookLastCategoryKey(isIncome: isIncome),
            value: id,
          );
    } catch (_) {
      // A preference only: the SMS is already recorded.
    }
  }
}

final smsCategoryStoreProvider = Provider<SmsCategoryStore>(
  SmsCategoryStore.new,
);
