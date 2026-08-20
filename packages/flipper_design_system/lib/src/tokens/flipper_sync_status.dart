import 'package:flipper_design_system/src/tokens/flipper_colors.dart';
import 'package:flutter/material.dart';

/// State of an offline-first record's sync to the cloud (Ditto -> Supabase
/// / Firebase). Drives [FlipperSyncStatusBadge].
enum FlipperSyncStatus {
  synced,
  syncing,
  offline,
  error;

  Color color(BuildContext context) => switch (this) {
        FlipperSyncStatus.synced => FlipperColors.success,
        FlipperSyncStatus.syncing => Theme.of(context).colorScheme.primary,
        FlipperSyncStatus.offline => FlipperColors.mediumGrey,
        FlipperSyncStatus.error => FlipperColors.error,
      };

  IconData get icon => switch (this) {
        FlipperSyncStatus.synced => Icons.cloud_done_outlined,
        FlipperSyncStatus.syncing => Icons.sync,
        FlipperSyncStatus.offline => Icons.cloud_off_outlined,
        FlipperSyncStatus.error => Icons.sync_problem_outlined,
      };

  String get label => switch (this) {
        FlipperSyncStatus.synced => 'Synced',
        FlipperSyncStatus.syncing => 'Syncing',
        FlipperSyncStatus.offline => 'Offline',
        FlipperSyncStatus.error => 'Sync failed',
      };
}
