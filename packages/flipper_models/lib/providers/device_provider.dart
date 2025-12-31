import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/device.model.dart';

part 'device_provider.g.dart';

@riverpod
Future<List<Device>> devicesForBranch(
  Ref ref, {
  required String branchId,
}) async {
  final devices = await ProxyService.getStrategy(Strategy.capella)
      .getDevicesByBranch(branchId: branchId);
  return devices;
}
