/// Pure rules behind the Cash Book entry form. No Flutter or model imports so
/// they stay unit-testable while the dashboard widget tests cannot load.
library;

/// Payment methods offered on the form, stored as `transaction.paymentType`.
/// Values match `paymentTypes` in flipper_services constants.
const String cashbookMethodCash = 'CASH';
const String cashbookMethodMtn = 'MTN MOMO';
const String cashbookMethodAirtel = 'AIRTEL MONEY';

const List<({String value, String label})> cashbookPaymentMethods = [
  (value: cashbookMethodCash, label: 'Cash'),
  (value: cashbookMethodMtn, label: 'MTN MoMo'),
  (value: cashbookMethodAirtel, label: 'Airtel Money'),
];

/// Box keys holding the form defaults (allow-listed in `local_storage.dart`).
const String cashbookLastCategoryInKey = 'cashbookLastCategoryIn';
const String cashbookLastCategoryOutKey = 'cashbookLastCategoryOut';
const String cashbookLastPaymentMethodKey = 'cashbookLastPaymentMethod';

String cashbookLastCategoryKey({required bool isIncome}) =>
    isIncome ? cashbookLastCategoryInKey : cashbookLastCategoryOutKey;

/// Method preselected on a new entry: the last one used, else cash.
String initialCashbookPaymentMethod(String? lastUsed) {
  for (final m in cashbookPaymentMethods) {
    if (m.value == lastUsed) return m.value;
  }
  return cashbookMethodCash;
}

/// Category preselected on a new entry: the last one used for this direction,
/// if it still exists in the branch. Otherwise none — the category is optional.
String? initialCashbookCategoryId(
  Iterable<String> categoryIds,
  String? lastUsed,
) {
  if (lastUsed == null || lastUsed.isEmpty) return null;
  return categoryIds.contains(lastUsed) ? lastUsed : null;
}

/// Chip order: the selected category first (so it is visible without
/// scrolling), then alphabetical. Blank names are dropped.
List<T> orderCashbookCategories<T>(
  Iterable<T> categories, {
  required String Function(T) id,
  required String Function(T) name,
  String? selectedId,
}) {
  final list = categories.where((c) => name(c).trim().isNotEmpty).toList()
    ..sort((a, b) {
      final aSel = id(a) == selectedId ? 0 : 1;
      final bSel = id(b) == selectedId ? 0 : 1;
      if (aSel != bSel) return aSel.compareTo(bSel);
      return name(a).toLowerCase().compareTo(name(b).toLowerCase());
    });
  return list;
}

/// Existing category with the same name (case/space-insensitive), so "+ New"
/// does not create a duplicate.
T? findCashbookCategoryByName<T>(
  Iterable<T> categories,
  String typed, {
  required String Function(T) name,
}) {
  final key = typed.trim().toLowerCase();
  if (key.isEmpty) return null;
  for (final c in categories) {
    if (name(c).trim().toLowerCase() == key) return c;
  }
  return null;
}

/// Starter names offered in the "New category" sheet, per direction.
const List<String> cashbookIncomeCategorySuggestions = [
  'Sales',
  'Owner deposit',
  'Loan received',
  'Debt repayment',
  'Refund',
  'Commission',
];

const List<String> cashbookExpenseCategorySuggestions = [
  'Transport',
  'Rent',
  'Salaries',
  'Utilities',
  'Supplies',
  'Airtime',
  'Food',
  'Repairs',
];

/// Suggestions for the "New category" sheet, minus names the branch already
/// has (case/space-insensitive) so a quick pick always creates something new.
List<String> cashbookCategorySuggestions({
  required bool isIncome,
  required Iterable<String> existingNames,
}) {
  final taken = existingNames.map((n) => n.trim().toLowerCase()).toSet();
  final source = isIncome
      ? cashbookIncomeCategorySuggestions
      : cashbookExpenseCategorySuggestions;
  return [
    for (final s in source)
      if (!taken.contains(s.toLowerCase())) s,
  ];
}

/// The category to record for [selectedId]: the loaded copy when the stream
/// has it, else [createdHere] — a category just made via "+ New" that the
/// asynchronously refreshed stream may not carry yet. `null` when nothing is
/// selected or the selection is gone.
T? resolveCashbookSelectedCategory<T>({
  required String? selectedId,
  required Iterable<T> loaded,
  required T? createdHere,
  required String Function(T) id,
}) {
  if (selectedId == null) return null;
  for (final c in loaded) {
    if (id(c) == selectedId) return c;
  }
  if (createdHere != null && id(createdHere) == selectedId) return createdHere;
  return null;
}
