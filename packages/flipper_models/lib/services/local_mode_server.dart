import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A business's sync mode as Supabase records it (`businesses.sync_mode`).
class BusinessSyncState {
  const BusinessSyncState({
    required this.mode,
    this.changedAt,
    this.deviceName,
  });

  factory BusinessSyncState.fromRow(Map<String, dynamic> row) =>
      BusinessSyncState(
        mode: (row['sync_mode'] as String?) ?? 'full',
        changedAt: DateTime.tryParse(
          (row['sync_mode_changed_at'] as String?) ?? '',
        ),
        deviceName: row['local_device_name'] as String?,
      );

  final String mode;
  final DateTime? changedAt;

  /// The device holding a local business's data, as [deviceRecord] wrote it.
  final String? deviceName;

  bool get isLocal => mode == 'local';

  /// The device's name, for people to read.
  String? get deviceLabel {
    final name = deviceName;
    if (name == null) return null;
    final hash = name.lastIndexOf('#');
    return hash < 0 ? name : name.substring(0, hash);
  }

  /// The device's store id ([LocalMode.installId]); null for a record that
  /// has none, which then names no device.
  String? get deviceId {
    final name = deviceName;
    final hash = name?.lastIndexOf('#') ?? -1;
    if (hash < 0) return null;
    final id = name!.substring(hash + 1);
    return id.isEmpty ? null : id;
  }

  /// What `local_device_name` records: the hostname to read, and the store
  /// id that identifies the device (hostnames repeat).
  static String deviceRecord({String? label, required String id}) =>
      '${label ?? ''}#$id';
}

enum SyncModeWrite {
  saved,

  /// The server has no `sync_mode` column yet (migration not deployed).
  notSupported,
  failed,
}

/// Reads and writes `businesses.sync_mode`, so other devices learn that a
/// business keeps its data on one device. Never throws: an unreachable server
/// reads as "unknown" (null) and callers carry on.
class LocalModeServer {
  LocalModeServer._();

  static const _columns = 'sync_mode, sync_mode_changed_at, local_device_name';
  static const _timeout = Duration(seconds: 8);

  /// Postgres "undefined_column": the migration is not on this server yet.
  static const _undefinedColumn = '42703';

  static Future<BusinessSyncState?> fetch(String businessId) async {
    try {
      final row = await LocalMode.allowCloud(
        () => Supabase.instance.client
            .from('businesses')
            .select(_columns)
            .eq('id', businessId)
            .maybeSingle()
            .timeout(_timeout),
      );
      return row == null ? null : BusinessSyncState.fromRow(row);
    } catch (e) {
      talker.warning('LocalModeServer.fetch($businessId): $e');
      return null;
    }
  }

  /// Sets the mode and returns what the server kept: a trigger refuses
  /// full -> local once the business has a plan.
  static Future<(SyncModeWrite, BusinessSyncState?)> setMode(
    String businessId, {
    required bool local,
    String? deviceName,
  }) async {
    try {
      // The one write local mode makes on purpose: other devices must learn
      // where this business's data lives.
      final row = await LocalMode.allowCloud(
        () => Supabase.instance.client
            .from('businesses')
            .update({
              'sync_mode': local ? 'local' : 'full',
              if (deviceName != null) 'local_device_name': deviceName,
            })
            .eq('id', businessId)
            .select(_columns)
            .maybeSingle()
            .timeout(_timeout),
      );
      if (row == null) return (SyncModeWrite.failed, null);
      final state = BusinessSyncState.fromRow(row);
      return (
        state.isLocal == local ? SyncModeWrite.saved : SyncModeWrite.failed,
        state,
      );
    } on PostgrestException catch (e) {
      if (e.code == _undefinedColumn) return (SyncModeWrite.notSupported, null);
      talker.warning('LocalModeServer.setMode($businessId): $e');
      return (SyncModeWrite.failed, null);
    } catch (e) {
      talker.warning('LocalModeServer.setMode($businessId): $e');
      return (SyncModeWrite.failed, null);
    }
  }
}
