import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscribes to Supabase Realtime on [accesses] for the signed-in user.
///
/// When an admin (or RPC) changes that user's rows, this debounces and calls
/// [sendLoginRequest] so `/v2/api/user` repopulates Ditto `user_access` and
/// permission providers refresh.
///
/// Requires: Realtime enabled for `public.accesses` in Supabase, and RLS (or
/// policies) allowing this user to receive changes for their `user_id`.
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
        .subscribe();

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
