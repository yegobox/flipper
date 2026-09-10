import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/ditto_transaction_line.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Same length as [SignInTokens.pinCellCount] / login PIN UI (6 cells).
const int barPinCellCount = 6;

/// `0` means "no PIN" on `users` / `tenants` rows — real login PINs live in `pins`.
bool isUsableStaffPin(int? pin) => pin != null && pin != 0;

/// Whether [enteredPin] matches the staff PIN on [tenant] (local merge from `pins`).
bool barPinMatchesTenant(Tenant tenant, String enteredPin) {
  final stored = tenant.pin;
  if (!isUsableStaffPin(stored)) return false;
  final parsed = int.tryParse(enteredPin);
  if (parsed != null && parsed == stored) return true;
  return stored.toString() == enteredPin;
}

/// Same verification path as [PinLogin] — `GET /v2/api/pin/{pin}` then match user.
Future<bool> barVerifyStaffPin(Tenant tenant, String enteredPin) async {
  if (barPinMatchesTenant(tenant, enteredPin)) return true;

  final expectedUserId = tenant.userId?.trim();
  if (expectedUserId == null || expectedUserId.isEmpty) return false;

  try {
    final record = await ProxyService.strategy.getPin(
      pinString: enteredPin,
      flipperHttpClient: ProxyService.http,
    );
    if (record == null) return false;
    return record.userId.trim() == expectedUserId;
  } catch (_) {
    return false;
  }
}

/// Σ price × qty for tab lines.
double barTabTotal(Iterable<TransactionItem> lines) => ticketLineTotal(lines);

/// Σ qty (item count).
int barTabItemCount(Iterable<TransactionItem> lines) => ticketItemCount(lines);

/// Distinct cashier tenant ids in first-seen order.
List<String> barTabServerIds(Iterable<TransactionItem> lines) {
  final seen = <String>{};
  final ordered = <String>[];
  for (final line in lines) {
    final id = line.loggedByTenantId;
    if (id == null || id.isEmpty || seen.contains(id)) continue;
    seen.add(id);
    ordered.add(id);
  }
  return ordered;
}

/// Inclusive VAT 18% breakdown.
({double subtotal, double vat, double total}) barVatBreakdown(double total) =>
    inclusiveVatBreakdown(total);

/// RRA [itemCd]: registered catalog code (≤20 chars), never a variant UUID.
String? barRraItemCd({
  Variant? variant,
  String? sku,
  String? legacyItemCd,
  String? variantId,
}) =>
    rraItemCd(
      variant: variant,
      sku: sku,
      legacyItemCd: legacyItemCd,
      variantId: variantId,
    );

/// Tourism tax category — RRA only accepts `TT` when applicable.
String? barRraTtCatCd({Variant? variant, String? legacy}) =>
    rraTtCatCd(variant: variant, legacy: legacy);

/// [TransactionItem.copyWith] cannot clear nullable fields with `null` — use `''`.
String barRraTtCatCdForItem({Variant? variant, String? legacy}) =>
    rraTtCatCdForItem(variant: variant, legacy: legacy);

/// Parses a Ditto `transaction_items` row for bar tabs.
TransactionItem? barTransactionLineFromDitto(Map<String, dynamic> data) =>
    transactionLineFromDitto(data);

/// Fills RRA-required fields on bar tab lines (variant catalog + pricing).
Future<List<TransactionItem>> enrichBarTabLinesForRraReceipt(
  List<TransactionItem> lines,
) =>
    enrichLinesForRraReceipt(lines, context: 'receipt');

/// Merge key: variant + cashier + default price only.
bool barLineMatchesMerge({
  required TransactionItem line,
  required String variantId,
  required String cashierTenantId,
  required num defaultPrice,
}) =>
    lineMatchesMerge(
      line: line,
      variantId: variantId,
      loggedByTenantId: cashierTenantId,
      defaultPrice: defaultPrice,
    );

String barTenantInitials(String? name) => tenantInitials(name);

/// Demo palette for server avatars (cycles by index).
const barServerColors = [
  0xFF2563EB,
  0xFF2E9E83,
  0xFFC2557E,
  0xFF5457D6,
  0xFFE08600,
  0xFF7C3AED,
];

int barServerColorForIndex(int index) =>
    barServerColors[index % barServerColors.length];

String barFormatDuration(Duration d) {
  if (d.inHours >= 1) return '${d.inHours}h ${d.inMinutes % 60}m';
  return '${d.inMinutes}m';
}
