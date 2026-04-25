import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

/// Hard-coded cashiers from the shared Transaction Reports design mock (until real
/// directory data is wired). Filter ids are prefixed so they never collide with Ditto agent ids.
class TransactionReportMockCashier {
  const TransactionReportMockCashier({
    required this.filterId,
    required this.displayName,
    required this.initials,
    required this.avatarColor,
    required this.matchSubstrings,
  });

  final String filterId;
  final String displayName;
  final String initials;
  final Color avatarColor;

  /// Matched case-insensitively against [ITransaction.agentId] and derived label.
  final List<String> matchSubstrings;
}

/// Order matches the mock: Alice, Bob, Chloe, David.
const List<TransactionReportMockCashier> kTransactionReportMockCashiers =
    <TransactionReportMockCashier>[
  TransactionReportMockCashier(
    filterId: '__mock_cashier_alice__',
    displayName: 'Alice K.',
    initials: 'AK',
    avatarColor: Color(0xFF2563EB),
    matchSubstrings: <String>['alice'],
  ),
  TransactionReportMockCashier(
    filterId: '__mock_cashier_bob__',
    displayName: 'Bob M.',
    initials: 'BM',
    avatarColor: Color(0xFF7C3AED),
    matchSubstrings: <String>['bob'],
  ),
  TransactionReportMockCashier(
    filterId: '__mock_cashier_chloe__',
    displayName: 'Chloe R.',
    initials: 'CR',
    avatarColor: Color(0xFF0D9488),
    matchSubstrings: <String>['chloe'],
  ),
  TransactionReportMockCashier(
    filterId: '__mock_cashier_david__',
    displayName: 'David N.',
    initials: 'DN',
    avatarColor: Color(0xFFEA580C),
    matchSubstrings: <String>['david'],
  ),
];

TransactionReportMockCashier? mockCashierForFilterId(String? filterId) {
  if (filterId == null || filterId.isEmpty) return null;
  for (final c in kTransactionReportMockCashiers) {
    if (c.filterId == filterId) return c;
  }
  return null;
}

TransactionReportMockCashier? _mockCashierMatchingAgent(String? agentId) {
  if (agentId == null || agentId.trim().isEmpty) return null;
  final aid = agentId.toLowerCase();
  final label = cashierLabelFromAgentId(agentId).toLowerCase();
  for (final m in kTransactionReportMockCashiers) {
    for (final s in m.matchSubstrings) {
      final t = s.toLowerCase();
      if (aid.contains(t) || label.contains(t)) return m;
    }
  }
  return null;
}

/// Grid / export / chart: show mock name when agent matches a mock profile.
String transactionReportCashierDisplayLabel(ITransaction tx) {
  final m = _mockCashierMatchingAgent(tx.agentId);
  if (m != null) return m.displayName;
  final raw = (tx.agentId ?? '').trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'Staff';
  return cashierLabelFromAgentId(raw);
}

String transactionReportCashierInitials(ITransaction tx) {
  final m = _mockCashierMatchingAgent(tx.agentId);
  if (m != null) return m.initials;
  final raw = (tx.agentId ?? '').trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'ST';
  return initialsFromLabel(cashierLabelFromAgentId(raw));
}

Color transactionReportCashierAvatarColor(ITransaction tx) {
  final m = _mockCashierMatchingAgent(tx.agentId);
  if (m != null) return m.avatarColor;
  return cashierAccentColorForAgentId(tx.agentId ?? '');
}

/// Chart / chips: same rules using raw agent id string.
String transactionReportCashierDisplayLabelForAgentId(String agentId) {
  final m = _mockCashierMatchingAgent(agentId);
  if (m != null) return m.displayName;
  final raw = agentId.trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'Staff';
  return cashierLabelFromAgentId(agentId);
}

String transactionReportCashierInitialsForAgentId(String agentId) {
  final m = _mockCashierMatchingAgent(agentId);
  if (m != null) return m.initials;
  final raw = agentId.trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'ST';
  return initialsFromLabel(cashierLabelFromAgentId(agentId));
}

Color transactionReportCashierAvatarColorForAgentId(String agentId) {
  final m = _mockCashierMatchingAgent(agentId);
  if (m != null) return m.avatarColor;
  return cashierAccentColorForAgentId(agentId);
}

bool transactionMatchesCashierFilter(
  ITransaction tx,
  String? cashierAgentId,
) {
  if (cashierAgentId == null || cashierAgentId.isEmpty) return true;
  final mock = mockCashierForFilterId(cashierAgentId);
  if (mock != null) {
    final aid = (tx.agentId ?? '').toLowerCase();
    final label = cashierLabelFromAgentId(tx.agentId ?? '').toLowerCase();
    for (final s in mock.matchSubstrings) {
      final t = s.toLowerCase();
      if (aid.contains(t) || label.contains(t)) return true;
    }
    return false;
  }
  return (tx.agentId ?? '') == cashierAgentId;
}
