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
    this.purchaseDate,
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

  int get netInventory => (totAmt - totTaxAmt).round();
  int get vat => totTaxAmt.round();
  int get total => totAmt.round();
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
