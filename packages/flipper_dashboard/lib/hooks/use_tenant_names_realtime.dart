import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/services/tenant_name_sync.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Refreshes providers that surface business/branch names after
/// [TenantNameSync] patched a local copy.
void invalidateTenantNameProviders(WidgetRef ref) {
  ref.invalidate(businessesProvider);
  ref.invalidate(branchesProvider);
  ref.invalidate(allBusinessBranchesProvider);
  ref.invalidate(activeBranchProvider);
}

/// Keeps business and branch names in step with Supabase.
///
/// Subscribes to Realtime UPDATEs on `public.businesses` (this business) and
/// `public.branches` (its branches) and hands the new `name` (and, for the
/// business, `business_type_id`) to [TenantNameSync], which patches Brick,
/// the Ditto docs and `user_access`.
/// On mount it also runs [TenantNameSync.catchUp] for renames made while the
/// app was closed. Same shape as `useAccessPermissionsRealtimeSync`.
///
/// Requires both tables in the `supabase_realtime` publication (migration
/// `tenant_names_realtime`).
void useTenantNamesRealtimeSync(WidgetRef ref) {
  final businessId = ProxyService.box.getBusinessId();

  useEffect(() {
    if (businessId == null || businessId.isEmpty) return null;

    final client = Supabase.instance.client;
    var disposed = false;

    void refreshIfChanged(Future<bool> patch) {
      unawaited(
        patch
            .then((changed) {
              if (changed && !disposed) invalidateTenantNameProviders(ref);
            })
            .catchError((Object e) {
              talker.warning('tenant names realtime: patch failed: $e');
            }),
      );
    }

    refreshIfChanged(TenantNameSync.catchUp(businessId: businessId));

    final channel = client
        .channel('tenant-names-$businessId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'businesses',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: businessId,
          ),
          callback: (payload) => refreshIfChanged(
            TenantNameSync.applyBusinessRow(payload.newRecord),
          ),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'branches',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'business_id',
            value: businessId,
          ),
          callback: (payload) => refreshIfChanged(
            TenantNameSync.applyBranchName(
              payload.newRecord['id']?.toString(),
              payload.newRecord['name'],
            ),
          ),
        )
        .subscribe(onSupabaseChannelSubscribeStatus);

    if (kDebugMode) {
      debugPrint(
        'useTenantNamesRealtimeSync: subscribed for business_id=$businessId',
      );
    }

    return () {
      disposed = true;
      unawaited(client.removeChannel(channel));
    };
  }, [businessId]);
}
