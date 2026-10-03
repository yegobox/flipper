import 'package:supabase_models/brick/models/all_models.dart';

/// A supplier the owner can pick when recording a purchase.
class SupplierOption {
  const SupplierOption({required this.name, this.tin = '', this.savedId});

  final String name;
  final String tin;

  /// The `suppliers` row id when this supplier is saved; null for one only
  /// seen on a past invoice (it is saved with the purchase).
  final String? savedId;

  bool get isSaved => savedId != null;
}

String _normName(String name) =>
    name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

String _normTin(String tin) => tin.replaceAll(RegExp(r'\D'), '');

/// Saved suppliers first, then suppliers seen only on past invoices (RRA or
/// recorded), one entry per supplier. A TIN identifies a supplier when both
/// sides have one; otherwise the name does. Sorted by name.
List<SupplierOption> mergeSupplierOptions({
  required List<Supplier> saved,
  required List<Purchase> purchases,
}) {
  final byTin = <String, SupplierOption>{};
  final byName = <String, SupplierOption>{};
  final out = <SupplierOption>[];

  void add(SupplierOption option) {
    final tin = _normTin(option.tin);
    final name = _normName(option.name);
    if (name.isEmpty) return;
    if (tin.isNotEmpty && byTin.containsKey(tin)) return;
    final sameName = byName[name];
    // Same name, and no TIN on either side says they are different firms.
    if (sameName != null && (tin.isEmpty || _normTin(sameName.tin).isEmpty)) {
      return;
    }
    out.add(option);
    if (tin.isNotEmpty) byTin[tin] = option;
    byName.putIfAbsent(name, () => option);
  }

  for (final s in saved) {
    add(
      SupplierOption(
        name: (s.custNm ?? '').trim(),
        tin: (s.custTin ?? '').trim(),
        savedId: s.id,
      ),
    );
  }
  for (final p in purchases) {
    add(SupplierOption(name: p.spplrNm.trim(), tin: p.spplrTin.trim()));
  }

  out.sort((a, b) => _normName(a.name).compareTo(_normName(b.name)));
  return out;
}

/// A past purchase's supplier and invoice number. [recorded] is true for
/// purchases entered in Flipper (regTyCd 'M'), false for RRA invoices.
typedef InvoiceRecord = ({
  String name,
  String tin,
  int invoiceNo,
  bool recorded,
});

/// The invoice number to suggest for a new purchase: one after the last
/// invoice from this supplier (RRA or recorded), else one after the last
/// purchase recorded in Flipper, else 1. RRA invoices of other suppliers are
/// never the fallback: they follow those suppliers' own numbering.
/// Suppliers match by TIN when both sides have one, else by name.
int suggestNextInvoiceNo(
  Iterable<InvoiceRecord> history, {
  String supplierName = '',
  String supplierTin = '',
}) {
  final tin = _normTin(supplierTin);
  final name = _normName(supplierName);
  int? supplierMax;
  int? overallMax;
  for (final r in history) {
    if (r.invoiceNo <= 0) continue;
    if (r.recorded && (overallMax == null || r.invoiceNo > overallMax)) {
      overallMax = r.invoiceNo;
    }
    final rTin = _normTin(r.tin);
    final sameSupplier = tin.isNotEmpty && rTin.isNotEmpty
        ? rTin == tin
        : name.isNotEmpty && _normName(r.name) == name;
    if (sameSupplier && (supplierMax == null || r.invoiceNo > supplierMax)) {
      supplierMax = r.invoiceNo;
    }
  }
  return (supplierMax ?? overallMax ?? 0) + 1;
}

/// [purchases] as [InvoiceRecord]s.
Iterable<InvoiceRecord> invoiceRecordsOf(Iterable<Purchase> purchases) =>
    purchases.map(
      (p) => (
        name: p.spplrNm,
        tin: p.spplrTin,
        invoiceNo: p.spplrInvcNo,
        recorded: p.regTyCd == 'M',
      ),
    );
