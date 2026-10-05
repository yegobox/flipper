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

/// What a Cash Book list row represents.
enum CashbookEntryKind { cashIn, cashOut, sale }

const String _cashInType = 'Cash In';
const String _cashOutType = 'Cash Out';
const String _saleType = 'Sale';

/// Classifies a transaction for the Cash Book list. A movement recorded in the
/// Cash Book carries `receiptType` 'Cash In'/'Cash Out' (its `transactionType`
/// is the category name); POS sales come through the same stream as income.
CashbookEntryKind classifyCashbookEntry({
  required String? receiptType,
  required String? transactionType,
  required bool? isIncome,
}) {
  final receipt = receiptType?.trim().toLowerCase();
  if (receipt == _cashInType.toLowerCase()) return CashbookEntryKind.cashIn;
  if (receipt == _cashOutType.toLowerCase()) return CashbookEntryKind.cashOut;
  final type = transactionType?.trim().toLowerCase();
  if (type == _cashInType.toLowerCase()) return CashbookEntryKind.cashIn;
  if (type == _cashOutType.toLowerCase()) return CashbookEntryKind.cashOut;
  if (isIncome == false) return CashbookEntryKind.cashOut;
  return CashbookEntryKind.sale;
}

/// Row title and the line beneath it. The title is the kind ("Cash out");
/// the detail is what it was for: the category, then the note.
({String title, String? detail}) cashbookRowLabels({
  required CashbookEntryKind kind,
  required String? transactionType,
  String? note,
}) {
  final title = switch (kind) {
    CashbookEntryKind.cashIn => 'Cash in',
    CashbookEntryKind.cashOut => 'Cash out',
    CashbookEntryKind.sale => 'Sale',
  };
  final raw = transactionType?.trim() ?? '';
  final lower = raw.toLowerCase();
  final isPlaceholder =
      raw.isEmpty ||
      lower == _cashInType.toLowerCase() ||
      lower == _cashOutType.toLowerCase() ||
      lower == _saleType.toLowerCase();
  final category = isPlaceholder ? null : raw;
  final trimmedNote = note?.trim();
  final hasNote = trimmedNote != null && trimmedNote.isNotEmpty;

  final parts = <String>[
    if (category != null)
      category
    else if (kind == CashbookEntryKind.sale)
      'Point of sale'
    else
      'No category',
    if (hasNote) trimmedNote,
  ];
  return (title: title, detail: parts.isEmpty ? null : parts.join(' · '));
}

/// The category to show for a Cash Book movement, or "No category".
String cashbookCategoryLabel(String? transactionType) {
  final raw = transactionType?.trim() ?? '';
  final lower = raw.toLowerCase();
  if (raw.isEmpty ||
      lower == _cashInType.toLowerCase() ||
      lower == _cashOutType.toLowerCase()) {
    return 'No category';
  }
  return raw;
}

/// Short label for a non-cash payment method, or null for cash.
String? cashbookMethodBadge(String? paymentType) {
  final p = paymentType?.trim().toUpperCase() ?? '';
  if (p.isEmpty || p == cashbookMethodCash) return null;
  if (p.contains('AIRTEL')) return 'Airtel';
  if (p.contains('MOMO') || p.contains('MOBILE MONEY')) return 'MoMo';
  return null;
}

/// Day group header: "Today", "Yesterday", or a short date (year only when it
/// differs from [now]).
String cashbookDayLabel(DateTime day, DateTime now) {
  final d = DateTime(day.year, day.month, day.day);
  final today = DateTime(now.year, now.month, now.day);
  // Count calendar days on UTC dates: local midnights can be 23 or 25 hours
  // apart across a DST change, which would make `inDays` call yesterday today.
  final diff = DateTime.utc(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime.utc(d.year, d.month, d.day)).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final base = '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  return d.year == today.year ? base : '$base, ${d.year}';
}

/// Groups items by calendar day, newest day first, keeping each day's order.
List<({DateTime day, List<T> items})> groupCashbookByDay<T>(
  Iterable<T> items, {
  required DateTime Function(T) at,
}) {
  final groups = <DateTime, List<T>>{};
  for (final item in items) {
    final t = at(item);
    groups.putIfAbsent(DateTime(t.year, t.month, t.day), () => []).add(item);
  }
  final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));
  return [for (final d in days) (day: d, items: groups[d]!)];
}

/// Money in (sales + cash in), money out, and the net.
({double moneyIn, double moneyOut, double net}) cashbookTotals(
  Iterable<({CashbookEntryKind kind, double amount})> entries,
) {
  var moneyIn = 0.0;
  var moneyOut = 0.0;
  for (final e in entries) {
    if (e.kind == CashbookEntryKind.cashOut) {
      moneyOut += e.amount;
    } else {
      moneyIn += e.amount;
    }
  }
  return (moneyIn: moneyIn, moneyOut: moneyOut, net: moneyIn - moneyOut);
}
