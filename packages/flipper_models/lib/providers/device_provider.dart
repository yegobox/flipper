import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/device.model.dart';

part 'device_provider.g.dart';

/// Branch devices for delegation target pickers.
///
/// TODO(ditto-migration): deliberately still on Brick → Supabase, **not**
/// Ditto. Ditto `devices` can lag behind or keep stale rows after reinstall;
/// Supabase is the source of truth for the picker list. Porting this needs the
/// staleness handled first — see docs/DITTO_ONLY_MIGRATION.md.
@riverpod
Future<List<Device>> devicesForBranch(
  Ref ref, {
  required String branchId,
}) async {
  final devices = await ProxyService.legacyStrategy
      .getDevicesByBranch(
    branchId: branchId,
    getPolicy: OfflineFirstGetPolicy.awaitRemote,
  );

  final active = devices.where((device) => device.deletedAt == null).toList();

  talker.info(
    '[delegation-devices] loaded ${active.length} active device(s) from '
    'Brick/cloudSync (awaitRemote) branchId=$branchId '
    'branchIdsOnRows=${active.map((d) => d.branchId ?? 'null').join(', ')} '
    'thisDeviceId=${ProxyService.box.getThisDeviceId()} '
    'ids=${active.map((d) => d.id).join(', ')} '
    'platforms=${active.map((d) => d.deviceName ?? 'null').join(', ')}',
  );

  return active;
}
