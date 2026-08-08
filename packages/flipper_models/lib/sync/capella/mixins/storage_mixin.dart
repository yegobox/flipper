import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync/interfaces/storage_interface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaStorageMixin implements StorageInterface {
  Repository get repository;
  Talker get talker;

  // TODO(ditto-migration): port `downloadAsset` to Ditto.
  @override
  Future<Stream<double>> downloadAsset({
    required String branchId,
    required String assetName,
    required String subPath,
  }) async {
    return ProxyService.legacyStrategy.downloadAsset(branchId: branchId, assetName: assetName, subPath: subPath);
  }

  // TODO(ditto-migration): port `downloadAssetSave` to Ditto.
  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    return ProxyService.legacyStrategy.downloadAssetSave(assetName: assetName, subPath: subPath);
  }
}
