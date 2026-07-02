import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/device.model.dart';

part 'device_provider.g.dart';

/// Branch devices for delegation target pickers.
///
/// Always reads via [Strategy.cloudSync] (Brick → Supabase), **not** Capella/Ditto.
/// Ditto `devices` can lag behind or keep stale rows after reinstall; Supabase is
/// the source of truth for the picker list.
@riverpod
Future<List<Device>> devicesForBranch(
  Ref ref, {
  required String branchId,
}) async {
  final devices = await ProxyService.getStrategy(Strategy.cloudSync)
      .getDevicesByBranch(
    branchId: branchId,
  );

  talker.info(
    '[delegation-devices] loaded ${devices.length} device(s) from '
    'Brick/cloudSync (not Ditto) branchId=$branchId '
    'thisDeviceId=${ProxyService.box.getThisDeviceId()} '
    'ids=${devices.map((d) => d.id).join(', ')}',
  );

  return devices;
}
