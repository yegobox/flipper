import 'package:flipper_models/db_model_export.dart';
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
double barTabTotal(Iterable<TransactionItem> lines) {
  var total = 0.0;
  for (final line in lines) {
    total += line.price.toDouble() * line.qty.toDouble();
  }
  return total;
}

/// Σ qty (item count).
int barTabItemCount(Iterable<TransactionItem> lines) {
  var count = 0;
  for (final line in lines) {
    count += line.qty.toInt();
  }
  return count;
}

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
({double subtotal, double vat, double total}) barVatBreakdown(double total) {
  if (total <= 0) {
    return (subtotal: 0, vat: 0, total: 0);
  }
  final vat = total - total / 1.18;
  final subtotal = total - vat;
  return (subtotal: subtotal, vat: vat, total: total);
}

/// Merge key: variant + cashier + default price only.
bool barLineMatchesMerge({
  required TransactionItem line,
  required String variantId,
  required String cashierTenantId,
  required num defaultPrice,
}) {
  return line.variantId == variantId &&
      line.loggedByTenantId == cashierTenantId &&
      line.price == defaultPrice;
}

String barTenantInitials(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.length >= 2
        ? parts.first.substring(0, 2).toUpperCase()
        : parts.first.toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

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
