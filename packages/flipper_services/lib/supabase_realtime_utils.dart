import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Transient Supabase Realtime disconnects (WebSocket closed, channel error).
/// These are expected on network blips and must not crash the app or spam logs.
bool isBenignSupabaseRealtimeError(Object error) {
  return error is RealtimeSubscribeException;
}

/// Log a Supabase stream/channel error without treating disconnects as fatal.
void logSupabaseRealtimeError(
  Object error, {
  String? source,
  StackTrace? stackTrace,
}) {
  final label = source != null ? ' ($source)' : '';
  if (isBenignSupabaseRealtimeError(error)) {
    talker.warning('Supabase realtime paused$label: $error');
    if (kDebugMode) {
      debugPrint('Supabase realtime paused$label: $error');
    }
    return;
  }
  talker.error('Supabase realtime error$label: $error', stackTrace);
}

/// Optional [RealtimeChannel.subscribe] status handler — logs channel errors only.
void onSupabaseChannelSubscribeStatus(
  RealtimeSubscribeStatus status, [
  Object? error,
]) {
  switch (status) {
    case RealtimeSubscribeStatus.subscribed:
      break;
    case RealtimeSubscribeStatus.channelError:
    case RealtimeSubscribeStatus.timedOut:
      logSupabaseRealtimeError(
        RealtimeSubscribeException(status, error),
        source: 'channel',
      );
    case RealtimeSubscribeStatus.closed:
      break;
  }
}
