import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';
import 'package:flutter/material.dart';

/// A staff member shown on Transaction Reports (from Supabase `accesses` + `users`).
class TransactionReportCashierProfile {
  const TransactionReportCashierProfile({
    required this.userId,
    required this.displayName,
    required this.initials,
    required this.avatarColor,
  });

  final String userId;
  final String displayName;
  final String initials;
  final Color avatarColor;

  static String displayNameFromUserRow({
    required String? name,
    required String? email,
  }) {
    final n = (name ?? '').trim();
    if (n.isNotEmpty) return n;
    final e = (email ?? '').trim();
    if (e.contains('@')) {
      final local = e.split('@').first.trim();
      if (local.isNotEmpty) {
        return local.replaceAll(RegExp(r'[._-]+'), ' ');
      }
    }
    return 'User';
  }

  static String initialsFromUserRow({
    required String? name,
    required String? email,
  }) {
    final n = (name ?? '').trim();
    if (n.isNotEmpty) {
      final parts = n.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      if (parts.length == 1 && parts[0].length >= 2) {
        return parts[0].substring(0, 2).toUpperCase();
      }
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    }
    final e = (email ?? '').trim();
    if (e.contains('@')) {
      final local = e.split('@').first.trim();
      if (local.length >= 2) return local.substring(0, 2).toUpperCase();
      if (local.isNotEmpty) return local[0].toUpperCase();
    }
    return 'U';
  }

  factory TransactionReportCashierProfile.fromUserRow(
    Map<String, dynamic> row,
  ) {
    final id = row['id'] as String? ?? '';
    final name = row['name'] as String?;
    final email = row['email'] as String?;
    final display = displayNameFromUserRow(name: name, email: email);
    final ini = initialsFromUserRow(name: name, email: email);
    return TransactionReportCashierProfile(
      userId: id,
      displayName: display,
      initials: ini,
      avatarColor: cashierAccentColorForAgentId(id),
    );
  }
}
