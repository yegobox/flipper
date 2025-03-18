import 'package:flipper_models/sync/interfaces/storage_interface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaStorageMixin implements StorageInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Stream<double>> downloadAsset({
    required int branchId,
    required String assetName,
    required String subPath,
  }) async {
    throw UnimplementedError(
        'downloadAsset needs to be implemented for Capella');
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    throw UnimplementedError(
        'downloadAssetSave needs to be implemented for Capella');
  }
}
