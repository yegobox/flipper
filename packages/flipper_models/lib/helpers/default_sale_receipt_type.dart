import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

/// The EBM sale code a freshly minted cart starts life with.
///
/// A new sale is a **Normal Sale** unless the operator has deliberately put
/// this device into Proforma or Training mode (System Config on desktop, the
/// Sale mode sheet in the mobile drawer). The remaining codes — CS, NR, CR,
/// TR — are never a starting state: they are derived per action (copy,
/// refund) from the sale being acted on.
///
/// Both pending-cart paths ([TransactionMixin.manageTransaction] on Brick and
/// [CapellaTransactionMixin.manageTransaction] on Ditto) must agree here;
/// Capella used to hardcode `TS`, which tagged every sale as a training
/// receipt and blocked sharing/printing it.
String defaultSaleReceiptType() {
  if (ProxyService.box.isProformaMode()) return TransactionReceptType.PS;
  if (ProxyService.box.isTrainingMode()) return TransactionReceptType.TS;
  return TransactionReceptType.NS;
}

/// Sale codes a pending cart can legitimately carry, and therefore the only
/// ones safe to re-resolve at completion time. A refund/copy code (NR, CR,
/// TR, CS) or a cash-book code is authored deliberately and must be left
/// alone.
const Set<String> pendingSaleReceiptTypes = {
  TransactionReceptType.NS,
  TransactionReceptType.TS,
  TransactionReceptType.PS,
};
