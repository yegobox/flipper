import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/domain/party/supplier_factory.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/repository.dart';

/// EBM payment type codes accepted on a purchase.
const Map<String, String> purchasePaymentTypes = {
  '01': 'Cash',
  '02': 'Credit',
  '03': 'Cash/Credit',
  '04': 'Bank check',
  '05': 'Debit/credit card',
  '06': 'Mobile money',
  '07': 'Other',
};

class ManualPurchaseLine {
  /// Stable identity for row widgets; survives edits and removals.
  final int uid;

  /// Set when the line was picked from the catalog; null for a new item.
  final String? catalogVariantId;
  final String name;
  final String? itemCd;
  final String? itemClsCd;
  final String? bcd;
  final double qty;
  final double unitPrice;
  final String taxTyCd;

  const ManualPurchaseLine({
    required this.uid,
    this.catalogVariantId,
    required this.name,
    this.itemCd,
    this.itemClsCd,
    this.bcd,
    this.qty = 1,
    this.unitPrice = 0,
    this.taxTyCd = 'B',
  });

  double get total => qty * unitPrice;

  /// VAT is tax-inclusive: only bracket B carries 18%.
  double get taxAmt => taxTyCd == 'B' ? total * 18 / 118 : 0;

  ManualPurchaseLine copyWith({
    String? name,
    double? qty,
    double? unitPrice,
    String? taxTyCd,
  }) {
    return ManualPurchaseLine(
      uid: uid,
      catalogVariantId: catalogVariantId,
      name: name ?? this.name,
      itemCd: itemCd,
      itemClsCd: itemClsCd,
      bcd: bcd,
      qty: qty ?? this.qty,
      unitPrice: unitPrice ?? this.unitPrice,
      taxTyCd: taxTyCd ?? this.taxTyCd,
    );
  }
}

class ManualPurchaseState {
  final String supplierName;
  final String supplierTin;
  final String? selectedSupplierId;
  final String invoiceNo;
  final DateTime purchaseDate;
  final String pmtTyCd;
  final List<ManualPurchaseLine> lines;
  final bool isSaving;
  final String? error;

  ManualPurchaseState({
    this.supplierName = '',
    this.supplierTin = '',
    this.selectedSupplierId,
    this.invoiceNo = '',
    DateTime? purchaseDate,
    this.pmtTyCd = '01',
    this.lines = const [],
    this.isSaving = false,
    this.error,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  double taxblAmt(String taxTyCd) => lines
      .where((l) => l.taxTyCd == taxTyCd)
      .fold(0.0, (sum, l) => sum + l.total);

  double taxAmt(String taxTyCd) => lines
      .where((l) => l.taxTyCd == taxTyCd)
      .fold(0.0, (sum, l) => sum + l.taxAmt);

  double get totTaxblAmt => lines.fold(0.0, (sum, l) => sum + l.total);
  double get totTaxAmt => lines.fold(0.0, (sum, l) => sum + l.taxAmt);
  double get totAmt => totTaxblAmt;

  bool get isValid =>
      supplierName.trim().isNotEmpty &&
      int.tryParse(invoiceNo.trim()) != null &&
      !purchaseDate.isAfter(DateTime.now()) &&
      lines.isNotEmpty &&
      lines.every((l) => l.name.trim().isNotEmpty && l.qty > 0);

  ManualPurchaseState copyWith({
    String? supplierName,
    String? supplierTin,
    String? selectedSupplierId,
    bool clearSelectedSupplierId = false,
    String? invoiceNo,
    DateTime? purchaseDate,
    String? pmtTyCd,
    List<ManualPurchaseLine>? lines,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return ManualPurchaseState(
      supplierName: supplierName ?? this.supplierName,
      supplierTin: supplierTin ?? this.supplierTin,
      selectedSupplierId: clearSelectedSupplierId
          ? null
          : (selectedSupplierId ?? this.selectedSupplierId),
      invoiceNo: invoiceNo ?? this.invoiceNo,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      pmtTyCd: pmtTyCd ?? this.pmtTyCd,
      lines: lines ?? this.lines,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ManualPurchaseNotifier extends StateNotifier<ManualPurchaseState> {
  ManualPurchaseNotifier() : super(ManualPurchaseState());

  int _nextUid = 0;

  void setSupplier({String? name, String? tin, String? id}) {
    state = state.copyWith(
      supplierName: name,
      supplierTin: tin,
      selectedSupplierId: id,
      clearSelectedSupplierId: id == null && name != null,
      clearError: true,
    );
  }

  void setInvoiceNo(String invoiceNo) {
    state = state.copyWith(invoiceNo: invoiceNo, clearError: true);
  }

  void setPurchaseDate(DateTime date) {
    state = state.copyWith(purchaseDate: date, clearError: true);
  }

  void setPaymentType(String pmtTyCd) {
    state = state.copyWith(pmtTyCd: pmtTyCd, clearError: true);
  }

  Future<Supplier?> createSupplier({
    required String name,
    String tin = '',
    String phone = '',
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return null;

    try {
      final draft = PartyDraft(
        name: name.trim(),
        phone: phone.trim(),
        tin: tin.trim().isEmpty ? null : tin.trim(),
        customerType: 'Business',
        branchId: branchId,
        kind: PartyKind.supplier,
        bhfId: await ProxyService.box.bhfId() ?? '00',
      );
      final supplier = await ProxyService.getStrategy(Strategy.capella)
          .upsertSupplierParty(draft);
      state = state.copyWith(
        supplierName: supplier.custNm ?? name,
        supplierTin: supplier.custTin ?? tin,
        selectedSupplierId: supplier.id,
        clearError: true,
      );
      return supplier;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void addLineFromVariant(Variant variant) {
    state = state.copyWith(
      lines: [
        ...state.lines,
        ManualPurchaseLine(
          uid: _nextUid++,
          catalogVariantId: variant.id,
          name: variant.name,
          itemCd: variant.itemCd,
          itemClsCd: variant.itemClsCd,
          bcd: variant.bcd,
          unitPrice: variant.supplyPrice ?? 0,
          taxTyCd: variant.taxTyCd ?? 'B',
        ),
      ],
      clearError: true,
    );
  }

  void addBlankLine() {
    state = state.copyWith(
      lines: [
        ...state.lines,
        ManualPurchaseLine(uid: _nextUid++, name: ''),
      ],
      clearError: true,
    );
  }

  void updateLine(
    int index, {
    String? name,
    double? qty,
    double? unitPrice,
    String? taxTyCd,
  }) {
    if (index < 0 || index >= state.lines.length) return;
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(
      name: name,
      qty: qty,
      unitPrice: unitPrice,
      taxTyCd: taxTyCd,
    );
    state = state.copyWith(lines: lines, clearError: true);
  }

  void removeLine(int index) {
    if (index < 0 || index >= state.lines.length) return;
    final lines = [...state.lines]..removeAt(index);
    state = state.copyWith(lines: lines, clearError: true);
  }

  /// Non-blocking duplicate check used to warn before saving.
  Future<bool> invoiceAlreadyExists() async {
    final invoiceNo = int.tryParse(state.invoiceNo.trim());
    if (invoiceNo == null) return false;
    final branchId = ProxyService.box.getBranchId()!;
    final existing = await Repository().get<Purchase>(
      query: brick.Query(
        where: [
          brick.Where('spplrInvcNo').isExactly(invoiceNo),
          brick.Where('branchId').isExactly(branchId),
        ],
      ),
    );
    return existing.isNotEmpty;
  }

  Supplier _supplierForSave({
    required String branchId,
    required String supplierName,
    required String supplierTin,
    required DateTime now,
  }) {
    final id = state.selectedSupplierId;
    if (id != null && id.isNotEmpty) {
      return Supplier(
        id: id,
        custNm: supplierName,
        custTin: supplierTin.isEmpty ? null : supplierTin,
        branchId: branchId,
        updatedAt: now,
      );
    }
    final draft = PartyDraft(
      name: supplierName,
      phone: '',
      tin: supplierTin.isEmpty ? null : supplierTin,
      customerType: 'Business',
      branchId: branchId,
      kind: PartyKind.supplier,
      bhfId: '00',
      updatedAt: now,
    );
    return supplierFromDraft(draft);
  }

  /// Persists the purchase locally with variants in pchsSttsCd '01' so it
  /// enters the same approval pipeline as RRA-fetched purchases.
  Future<Purchase?> save() async {
    final s = state;
    if (!s.isValid) {
      state = s.copyWith(
        error:
            'Supplier, a numeric invoice number and at least one line '
            'with quantity above zero are required.',
      );
      return null;
    }

    state = s.copyWith(isSaving: true, clearError: true);
    try {
      final branchId = ProxyService.box.getBranchId()!;
      final now = DateTime.now().toUtc();
      final supplierName = s.supplierName.trim();
      final supplierTin = s.supplierTin.trim();

      final variants = <Variant>[];
      for (var i = 0; i < s.lines.length; i++) {
        final line = s.lines[i];
        variants.add(
          Variant(
            name: line.name.trim(),
            itemNm: line.name.trim(),
            branchId: branchId,
            itemSeq: i + 1,
            itemCd: line.itemCd ?? '',
            itemClsCd: line.itemClsCd ?? '1',
            bcd: line.bcd,
            pkgUnitCd: 'NT',
            pkg: 1,
            qtyUnitCd: 'BA',
            qty: line.qty,
            prc: line.unitPrice,
            splyAmt: line.total,
            dcRt: 0,
            dcAmt: 0,
            taxTyCd: line.taxTyCd,
            taxblAmt: line.total,
            taxAmt: line.taxAmt,
            totAmt: line.total,
            spplrNm: supplierName,
            stock: Stock(
              branchId: branchId,
              currentStock: line.qty,
              lastTouched: now,
            ),
          ),
        );
      }

      final purchase = Purchase(
        spplrTin: supplierTin,
        spplrNm: supplierName,
        spplrBhfId: '00',
        spplrInvcNo: int.parse(s.invoiceNo.trim()),
        rcptTyCd: 'S',
        pmtTyCd: s.pmtTyCd,
        cfmDt: DateFormat('yyyy-MM-dd HH:mm:ss').format(s.purchaseDate),
        salesDt: DateFormat('yyyyMMdd').format(s.purchaseDate),
        totItemCnt: s.lines.length,
        taxblAmtA: s.taxblAmt('A'),
        taxblAmtB: s.taxblAmt('B'),
        taxblAmtC: s.taxblAmt('C'),
        taxblAmtD: s.taxblAmt('D'),
        taxRtA: 0,
        taxRtB: 18,
        taxRtC: 0,
        taxRtD: 0,
        taxAmtA: s.taxAmt('A'),
        taxAmtB: s.taxAmt('B'),
        taxAmtC: s.taxAmt('C'),
        taxAmtD: s.taxAmt('D'),
        totTaxblAmt: s.totTaxblAmt,
        totTaxAmt: s.totTaxAmt,
        totAmt: s.totAmt,
        regTyCd: 'M',
        branchId: branchId,
        createdAt: now,
        variants: variants,
      );

      final supplier = _supplierForSave(
        branchId: branchId,
        supplierName: supplierName,
        supplierTin: supplierTin,
        now: now,
      );

      final saved = await ProxyService.getStrategy(Strategy.capella)
          .saveManualPurchase(
        purchase: purchase,
        branchId: branchId,
        supplier: supplier,
      );

      state = state.copyWith(isSaving: false);
      return saved;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }
}

final manualPurchaseProvider =
    StateNotifierProvider.autoDispose<
      ManualPurchaseNotifier,
      ManualPurchaseState
    >((ref) {
      return ManualPurchaseNotifier();
    });
