import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscribes to Supabase Realtime on [accesses] for the signed-in user.
///
/// Feature menus read nested module rows from Ditto `user_access` (written at
/// login). When an admin updates `public.accesses`, this debounces and calls
/// [sendLoginRequest] with `refreshUserAccessOnly: true`, which re-fetches
/// `/v2/api/user` (`get_user_with_nested_data`) and **upserts the entire**
/// `user_access` document — same businesses → branches → accesses shape —
/// then invalidates permission providers.
///
/// Requires: `public.accesses` in `supabase_realtime` publication (see
/// migration `accesses_realtime_for_user_access_refresh`) and RLS that allows
/// the signed-in user to receive change events for their `user_id`.
void useAccessPermissionsRealtimeSync(WidgetRef ref) {
  final userId = ProxyService.box.getUserId();

  useEffect(() {
    if (userId == null || userId.isEmpty) return null;

    final client = Supabase.instance.client;
    Timer? debounce;

    Future<void> scheduleRefresh() async {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () async {
        final loginKey =
            ProxyService.box.getUserPhone() ?? userId;
        if (loginKey.isEmpty) return;
        try {
          await ProxyService.strategy.sendLoginRequest(
            loginKey,
            ProxyService.http,
            AppSecrets.apihubProd,
            expectedPinUserId: userId,
            refreshUserAccessOnly: true,
          );
          ref.invalidate(allAccessesProvider(userId));
          for (final f in features) {
            ref.invalidate(userAccessesProvider(userId, featureName: f));
          }
        } catch (e, s) {
          talker.warning('accesses realtime → login refresh failed: $e\n$s');
        }
      });
    }

    final channel = client
        .channel(
          'accesses-permissions-$userId',
          opts: const RealtimeChannelConfig(ack: true),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'accesses',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) {
            scheduleRefresh();
          },
        )
        .subscribe(onSupabaseChannelSubscribeStatus);

    if (kDebugMode) {
      debugPrint(
        'useAccessPermissionsRealtimeSync: subscribed for user_id=$userId',
      );
    }

    return () {
      debounce?.cancel();
      unawaited(client.removeChannel(channel));
    };
  }, [userId]);
}
