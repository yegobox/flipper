import 'package:flipper_models/db_model_export.dart';

/// Commission input mode for a sale attributed to an agent.
enum SaleAgentCommissionType { fixed, percent }

String saleAgentCommissionTypeToDb(SaleAgentCommissionType type) {
  switch (type) {
    case SaleAgentCommissionType.fixed:
      return 'fixed';
    case SaleAgentCommissionType.percent:
      return 'percent';
  }
}

SaleAgentCommissionType? saleAgentCommissionTypeFromDb(String? raw) {
  switch (raw) {
    case 'fixed':
      return SaleAgentCommissionType.fixed;
    case 'percent':
      return SaleAgentCommissionType.percent;
    default:
      return null;
  }
}

/// Pre-VAT net used for percent commission.
///
/// Checkout shows `total = subTotal + tax`, so [subTotal] is already net of VAT.
/// Commission is calculated on that net (after tax is deducted from the customer total).
double agentCommissionNetBase({
  required double subTotal,
  required double taxAmount,
}) {
  if (subTotal > 0) return subTotal;
  // Fallback when only tax lines exist (edge case).
  if (taxAmount > 0) return 0;
  return 0;
}

/// Resolved RWF commission for reporting (percent uses [commissionBase]).
num? resolveAgentCommissionAmount({
  required String? commissionType,
  required num? commissionValue,
  required double commissionBase,
}) {
  if (commissionType == null || commissionValue == null) return null;
  if (commissionValue <= 0) return null;

  switch (commissionType) {
    case 'fixed':
      return commissionValue;
    case 'percent':
      if (commissionBase <= 0) return null;
      return (commissionBase * commissionValue / 100).round();
    default:
      return null;
  }
}

/// Copies agent attribution from [source] when [target] is missing fields (e.g. stale cart).
void mergeAgentAttributionOnto(ITransaction target, ITransaction? source) {
  if (source == null) return;
  target.attributedAgentUserId ??= source.attributedAgentUserId;
  target.agentCommissionType ??= source.agentCommissionType;
  target.agentCommissionValue ??= source.agentCommissionValue;
  if (target.agentCommissionAmount == null && source.agentCommissionAmount != null) {
    target.agentCommissionAmount = source.agentCommissionAmount;
  }
}

/// In-memory only — no Ditto reads (Pay hot path before [updateTransaction]).
void applyAgentCommissionForSaleCompletionInMemory({
  required ITransaction transaction,
  required double finalSubTotal,
  List<TransactionItem>? preloadedLineItems,
}) {
  var tax = transaction.taxAmount?.toDouble() ?? 0;
  if (tax <= 0 && preloadedLineItems != null && preloadedLineItems.isNotEmpty) {
    tax = preloadedLineItems.fold<double>(
      0,
      (sum, item) => sum + (item.taxAmt?.toDouble() ?? 0),
    );
    transaction.taxAmount = tax;
  }
  finalizeAgentCommissionAmount(
    target: transaction,
    subTotal: finalSubTotal,
    taxAmount: tax,
  );
}

/// Sets [target.agentCommissionAmount] at sale completion (percent on net excl. VAT).
void finalizeAgentCommissionAmount({
  required ITransaction target,
  required double subTotal,
  required double taxAmount,
}) {
  final uid = target.attributedAgentUserId;
  if (uid == null || uid.isEmpty) return;

  final base = agentCommissionNetBase(subTotal: subTotal, taxAmount: taxAmount);
  final resolved = resolveAgentCommissionAmount(
    commissionType: target.agentCommissionType,
    commissionValue: target.agentCommissionValue,
    commissionBase: base,
  );

  if (resolved != null) {
    target.agentCommissionAmount = resolved;
  } else if (target.agentCommissionType == 'fixed' &&
      target.agentCommissionValue != null) {
    target.agentCommissionAmount = target.agentCommissionValue;
  }
}

String formatSaleAgentCommissionLabel({
  required String? commissionType,
  required num? commissionValue,
  num? resolvedAmount,
}) {
  if (commissionType == null || commissionValue == null) return '';
  switch (commissionType) {
    case 'fixed':
      final amt = resolvedAmount ?? commissionValue;
      return 'RWF ${amt.round()}';
    case 'percent':
      if (resolvedAmount != null && resolvedAmount > 0) {
        return '${commissionValue.round()}% (RWF ${resolvedAmount.round()})';
      }
      return '${commissionValue.round()}%';
    default:
      return '';
  }
}

String tenantDisplayName(Tenant tenant) {
  final name = (tenant.name ?? '').trim();
  if (name.isNotEmpty) return name;
  final email = (tenant.email ?? tenant.phoneNumber ?? '').trim();
  return email.isNotEmpty ? email : 'Agent';
}
