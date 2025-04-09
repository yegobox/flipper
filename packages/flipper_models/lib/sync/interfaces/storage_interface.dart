import 'dart:async';

abstract class StorageInterface {
  Future<Stream<double>> downloadAsset({
    required int branchId,
    required String assetName,
    required String subPath,
  });

  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  });
}
