import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/domain/party/supplier_factory.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
import 'package:flipper_dashboard/manual_purchase/purchase_suggestions.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

/// EBM payment type codes accepted on a purchase, with labels in the current
/// app language. The keys are the wire codes; only the values are localized.
Map<String, String> get purchasePaymentTypes {
  final l10n = FlipperL10n.current;
  return {
    '01': l10n.cash,
    '02': l10n.credit,
    '03': l10n.paymentCashCredit,
    '04': l10n.paymentBankCheck,
    '05': l10n.paymentDebitCreditCard,
    '06': l10n.paymentMobileMoney,
    '07': l10n.paymentOther,
  };
}

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

  /// New items only: the price the product sells at once created. Null
  /// means "same as the cost" (the owner can change it in Inventory).
  final double? sellingPrice;

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
    this.sellingPrice,
  });

  double get total => qty * unitPrice;

  /// VAT is tax-inclusive: only bracket B carries 18%.
  double get taxAmt => taxTyCd == 'B' ? total * 18 / 118 : 0;

  ManualPurchaseLine copyWith({
    String? name,
    double? qty,
    double? unitPrice,
    String? taxTyCd,
    double? sellingPrice,
    bool clearSellingPrice = false,
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
      sellingPrice: clearSellingPrice
          ? null
          : (sellingPrice ?? this.sellingPrice),
    );
  }
}

class ManualPurchaseState {
  final String supplierName;
  final String supplierTin;
  final String? selectedSupplierId;
  final String invoiceNo;

  /// True while [invoiceNo] is our suggestion rather than typed by the owner;
  /// only then may a new suggestion (e.g. after picking a supplier) replace it.
  final bool invoiceAutoFilled;
  final DateTime purchaseDate;
  final String pmtTyCd;

  /// Pay-by date the owner picked; null means the default, 30 days after
  /// [purchaseDate] (see [effectiveDueDate]).
  final DateTime? dueDate;

  /// Cash/Credit (`03`): the part paid when the goods arrived.
  final double paidUpfront;
  final List<ManualPurchaseLine> lines;
  final bool isSaving;
  final String? error;

  ManualPurchaseState({
    this.supplierName = '',
    this.supplierTin = '',
    this.selectedSupplierId,
    this.invoiceNo = '',
    this.invoiceAutoFilled = false,
    DateTime? purchaseDate,
    this.pmtTyCd = '01',
    this.dueDate,
    this.paidUpfront = 0,
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

  /// Some of the purchase is owed to the supplier (`02` Credit, `03` Cash/Credit).
  bool get isOnCredit => pmtTyCd == '02' || pmtTyCd == '03';

  /// When the supplier is due: the picked date, else Net 30 from the
  /// purchase date (so it follows later purchase-date changes).
  DateTime get effectiveDueDate =>
      dueDate ?? purchaseDate.add(const Duration(days: 30));

  /// What will be owed once the purchase is approved.
  double get amountOwed => switch (pmtTyCd) {
    '02' => totAmt,
    '03' => (totAmt - paidUpfront).clamp(0, totAmt).toDouble(),
    _ => 0,
  };

  bool get isValid =>
      supplierName.trim().isNotEmpty &&
      int.tryParse(invoiceNo.trim()) != null &&
      !purchaseDate.isAfter(DateTime.now()) &&
      lines.isNotEmpty &&
      lines.every((l) => l.name.trim().isNotEmpty && l.qty > 0) &&
      (pmtTyCd != '03' || paidUpfront <= totAmt);

  ManualPurchaseState copyWith({
    String? supplierName,
    String? supplierTin,
    String? selectedSupplierId,
    bool clearSelectedSupplierId = false,
    String? invoiceNo,
    bool? invoiceAutoFilled,
    DateTime? purchaseDate,
    String? pmtTyCd,
    DateTime? dueDate,
    bool clearDueDate = false,
    double? paidUpfront,
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
      invoiceAutoFilled: invoiceAutoFilled ?? this.invoiceAutoFilled,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      pmtTyCd: pmtTyCd ?? this.pmtTyCd,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      paidUpfront: paidUpfront ?? this.paidUpfront,
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
    state = state.copyWith(
      invoiceNo: invoiceNo,
      invoiceAutoFilled: false,
      clearError: true,
    );
  }

  /// Fills in the next invoice number for the chosen supplier, unless the
  /// owner already typed one. [loaded] adds purchases already on screen (RRA
  /// invoices are not in Ditto) to the recorded history.
  Future<void> suggestInvoiceNo({List<Purchase> loaded = const []}) async {
    if (state.invoiceNo.trim().isNotEmpty && !state.invoiceAutoFilled) return;
    final branchId = ProxyService.box.getBranchId();
    final recorded = branchId == null
        ? const <InvoiceRecord>[]
        : await ManualPurchaseDitto.invoiceHistory(branchId);
    if (!mounted) return;
    // The owner may have typed while the history loaded.
    if (state.invoiceNo.trim().isNotEmpty && !state.invoiceAutoFilled) return;
    final next = suggestNextInvoiceNo(
      [...recorded, ...invoiceRecordsOf(loaded)],
      supplierName: state.supplierName,
      supplierTin: state.supplierTin,
    );
    state = state.copyWith(invoiceNo: '$next', invoiceAutoFilled: true);
  }

  void setPurchaseDate(DateTime date) {
    final due = state.dueDate;
    state = state.copyWith(
      purchaseDate: date,
      // A picked pay-by date before the new purchase date no longer makes
      // sense; fall back to the default.
      clearDueDate: due != null && due.isBefore(date),
      clearError: true,
    );
  }

  void setPaymentType(String pmtTyCd) {
    final onCredit = pmtTyCd == '02' || pmtTyCd == '03';
    state = state.copyWith(
      pmtTyCd: pmtTyCd,
      clearDueDate: !onCredit,
      paidUpfront: pmtTyCd == '03' ? state.paidUpfront : 0,
      clearError: true,
    );
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(dueDate: date, clearError: true);
  }

  void setPaidUpfront(double amount) {
    state = state.copyWith(
      paidUpfront: amount < 0 ? 0 : amount,
      clearError: true,
    );
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
      final supplier = await ProxyService.getStrategy(
        Strategy.capella,
      ).upsertSupplierParty(draft);
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
    double? sellingPrice,
  }) {
    if (index < 0 || index >= state.lines.length) return;
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(
      name: name,
      qty: qty,
      unitPrice: unitPrice,
      taxTyCd: taxTyCd,
      sellingPrice: sellingPrice != null && sellingPrice > 0
          ? sellingPrice
          : null,
      clearSellingPrice: sellingPrice != null && sellingPrice <= 0,
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
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return false;
    final tin = state.supplierTin.trim();
    return ManualPurchaseDitto.invoiceExists(
      branchId: branchId,
      spplrTin: tin,
      spplrInvcNo: invoiceNo,
    );
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
        error: s.pmtTyCd == '03' && s.paidUpfront > s.totAmt
            ? FlipperL10n.current.manualPurchasePaidExceedsTotal
            : FlipperL10n.current.manualPurchaseRequiredFields,
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
      // itemSeq → catalog variant the line was picked from: approval adds
      // the line's quantity to that product's stock.
      final catalogTargets = <int, String>{};
      for (var i = 0; i < s.lines.length; i++) {
        final line = s.lines[i];
        final catalogId = line.catalogVariantId;
        if (catalogId != null && catalogId.isNotEmpty) {
          catalogTargets[i + 1] = catalogId;
        }
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
            supplyPrice: line.unitPrice,
            // New items: the product created on approval sells at this.
            retailPrice: line.sellingPrice ?? line.unitPrice,
            splyAmt: line.total,
            dcRt: 0,
            dcAmt: 0,
            taxTyCd: line.taxTyCd,
            taxblAmt: line.total,
            taxAmt: line.taxAmt,
            totAmt: line.total,
            spplrNm: supplierName,
            // No stock until approval: the quantity then goes onto the
            // product's own stock (see stockInManualPurchase).
            stock: Stock(branchId: branchId, currentStock: 0, lastTouched: now),
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
            catalogTargets: catalogTargets,
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
