import 'package:flipper_dashboard/transaction_report_cashier_profile.dart';
import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/models/access.model.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// Staff member eligible to receive an order form via WhatsApp — active
/// [AppFeature.StockHandover] grant plus a reachable phone on their tenant row.
class HandoverStaffMember {
  const HandoverStaffMember({
    required this.userId,
    required this.displayName,
    required this.initials,
    required this.avatarColor,
    required this.phoneNumber,
    this.tenant,
  });

  final String userId;
  final String displayName;
  final String initials;
  final Color avatarColor;
  final String phoneNumber;
  final Tenant? tenant;
}

/// Active Stock Handover staff for the logged-in business (write/admin access).
final handoverStaffProvider =
    FutureProvider.autoDispose<List<HandoverStaffMember>>((ref) async {
  final businessId = ProxyService.box.getBusinessId();
  if (businessId == null || businessId.isEmpty) return const [];

  final repo = Repository();
  final accessQuery = Query(
    where: [
      Where('businessId').isExactly(businessId),
      Where('featureName').isExactly(AppFeature.StockHandover),
      Where('status').isExactly('active'),
    ],
  );

  List<Access> accesses;
  try {
    accesses = await repo.get<Access>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: accessQuery,
    );
  } catch (_) {
    accesses = await repo.get<Access>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: accessQuery,
    );
  }

  final now = DateTime.now();
  final handoverUserIds = accesses
      .where((a) {
        final level = (a.accessLevel ?? '').toLowerCase();
        if (level != 'write' && level != 'admin') return false;
        final expires = a.expiresAt;
        if (expires != null && expires.isBefore(now)) return false;
        final uid = (a.userId ?? '').trim();
        return uid.isNotEmpty;
      })
      .map((a) => a.userId!.trim())
      .toSet()
      .toList();
  if (handoverUserIds.isEmpty) return const [];

  final tenants = await FlipperBaseModel.fetchBarStaffTenants(
    businessId: businessId,
  );
  final tenantByUserId = {
    for (final t in tenants)
      if ((t.userId ?? '').trim().isNotEmpty) t.userId!.trim(): t,
  };

  final members = <HandoverStaffMember>[];
  for (final userId in handoverUserIds) {
    final tenant = tenantByUserId[userId];
    final phone = _normalizeHandoverPhone(tenant?.phoneNumber);
    if (phone == null) continue;

    final name = (tenant?.name ?? '').trim();
    members.add(
      HandoverStaffMember(
        userId: userId,
        displayName: name.isNotEmpty
            ? name
            : TransactionReportCashierProfile.displayNameFromUserRow(
                name: tenant?.name,
                email: tenant?.email,
              ),
        initials: TransactionReportCashierProfile.initialsFromUserRow(
          name: tenant?.name,
          email: tenant?.email,
        ),
        avatarColor: cashierAccentColorForAgentId(userId),
        phoneNumber: phone,
        tenant: tenant,
      ),
    );
  }

  members.sort(
    (a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
  );
  return members;
});

String? _normalizeHandoverPhone(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty || trimmed.contains('@')) return null;
  final digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;
  if (digits.startsWith('0') && digits.length >= 9) {
    return '250${digits.substring(1)}';
  }
  if (digits.length == 9) return '250$digits';
  if (digits.startsWith('250') && digits.length >= 12) return digits;
  return digits.length >= 10 ? digits : null;
}

/// Resolves data-connector URL from cached EBM/box settings.
Future<String?> resolveOrderFormDataConnectorUrl() =>
    resolveEbmDataConnectorUrl();
