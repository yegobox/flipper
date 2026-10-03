/// Minimal purchase payload for GL posting (avoids web-only document types).
class PurchasePostingInput {
  const PurchasePostingInput({
    required this.purchaseId,
    required this.supplierName,
    required this.invoiceNo,
    required this.pmtTyCd,
    required this.totAmt,
    required this.totTaxAmt,
    required this.lines,
    this.supplierTin = '',
    this.supplierId,
    this.purchaseDate,
    this.paidUpfront,
    this.dueDate,
  });

  final String purchaseId;
  final String supplierName;
  final String supplierTin;
  final int invoiceNo;
  final String pmtTyCd;
  final double totAmt;
  final double totTaxAmt;
  final List<PurchasePostingLine> lines;
  final DateTime? purchaseDate;

  /// Supplier party id (`suppliers` row), when the purchase is linked to one.
  final String? supplierId;

  /// Cash/Credit (`03`) only: the part paid at purchase time. The rest is
  /// owed to the supplier. Null means "use what the draft bill recorded".
  final double? paidUpfront;

  /// When the supplier expects to be paid. Null means "keep the draft bill's
  /// due date", falling back to 30 days after the purchase.
  final DateTime? dueDate;

  int get netInventory => (totAmt - totTaxAmt).round();
  int get vat => totTaxAmt.round();
  int get total => totAmt.round();

  /// True when some of the purchase is bought on credit (`02`, `03`).
  bool get isOnCredit => pmtTyCd == '02' || pmtTyCd == '03';

  /// Amount settled at purchase time, given the cash/credit part [upfront]
  /// (only meaningful for `03`).
  int paidAtPurchase(double? upfront) {
    switch (pmtTyCd) {
      case '02':
        return 0;
      case '03':
        return (upfront ?? 0).round().clamp(0, total);
      default:
        return total;
    }
  }
}

class PurchasePostingLine {
  const PurchasePostingLine({
    required this.description,
    required this.qty,
    required this.unitPrice,
  });

  final String description;
  final double qty;
  final double unitPrice;
}
