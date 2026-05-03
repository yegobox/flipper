import 'package:flipper_dashboard/transaction_report_cashier_profile.dart';
import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

/// Legacy design-mock profiles (substring match on [ITransaction.agentId] when no Supabase row).
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
  final List<String> matchSubstrings;
}

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

/// Grid / export / chart: [directory] wins (Supabase staff), then mock substrings, then fallbacks.
String transactionReportCashierDisplayLabel(
  ITransaction tx, {
  Map<String, TransactionReportCashierProfile>? directory,
}) {
  final cached = (tx.cashierName ?? '').trim();
  if (cached.isNotEmpty) return cached;
  final aid = (tx.agentId ?? '').trim();
  if (directory != null && aid.isNotEmpty) {
    final p = directory[aid];
    if (p != null) return p.displayName;
  }
  final m = _mockCashierMatchingAgent(tx.agentId);
  if (m != null) return m.displayName;
  final raw = (tx.agentId ?? '').trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'Staff';
  return cashierLabelFromAgentId(raw);
}

String transactionReportCashierInitials(
  ITransaction tx, {
  Map<String, TransactionReportCashierProfile>? directory,
}) {
  final cached = (tx.cashierName ?? '').trim();
  if (cached.isNotEmpty) return initialsFromLabel(cached);
  final aid = (tx.agentId ?? '').trim();
  if (directory != null && aid.isNotEmpty) {
    final p = directory[aid];
    if (p != null) return p.initials;
  }
  final m = _mockCashierMatchingAgent(tx.agentId);
  if (m != null) return m.initials;
  final raw = (tx.agentId ?? '').trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'ST';
  return initialsFromLabel(cashierLabelFromAgentId(raw));
}

Color transactionReportCashierAvatarColor(
  ITransaction tx, {
  Map<String, TransactionReportCashierProfile>? directory,
}) {
  final aid = (tx.agentId ?? '').trim();
  if (directory != null && aid.isNotEmpty) {
    final p = directory[aid];
    if (p != null) return p.avatarColor;
  }
  final m = _mockCashierMatchingAgent(tx.agentId);
  if (m != null) return m.avatarColor;
  return cashierAccentColorForAgentId(tx.agentId ?? '');
}

String transactionReportCashierDisplayLabelForAgentId(
  String agentId, {
  Map<String, TransactionReportCashierProfile>? directory,
}) {
  final aid = agentId.trim();
  if (directory != null && aid.isNotEmpty) {
    final p = directory[aid];
    if (p != null) return p.displayName;
  }
  final m = _mockCashierMatchingAgent(agentId);
  if (m != null) return m.displayName;
  final raw = agentId.trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'Staff';
  return cashierLabelFromAgentId(agentId);
}

String transactionReportCashierInitialsForAgentId(
  String agentId, {
  Map<String, TransactionReportCashierProfile>? directory,
}) {
  final aid = agentId.trim();
  if (directory != null && aid.isNotEmpty) {
    final p = directory[aid];
    if (p != null) return p.initials;
  }
  final m = _mockCashierMatchingAgent(agentId);
  if (m != null) return m.initials;
  final raw = agentId.trim();
  if (agentIdLooksLikeOpaqueTechnicalId(raw)) return 'ST';
  return initialsFromLabel(cashierLabelFromAgentId(agentId));
}

Color transactionReportCashierAvatarColorForAgentId(
  String agentId, {
  Map<String, TransactionReportCashierProfile>? directory,
}) {
  final aid = agentId.trim();
  if (directory != null && aid.isNotEmpty) {
    final p = directory[aid];
    if (p != null) return p.avatarColor;
  }
  final m = _mockCashierMatchingAgent(agentId);
  if (m != null) return m.avatarColor;
  return cashierAccentColorForAgentId(agentId);
}

/// Filter by exact [ITransaction.agentId] (Supabase `users.id` / Ditto agent id).
bool transactionMatchesCashierFilter(
  ITransaction tx,
  String? cashierAgentId,
) {
  if (cashierAgentId == null || cashierAgentId.isEmpty) return true;
  return (tx.agentId ?? '').trim() == cashierAgentId.trim();
}
