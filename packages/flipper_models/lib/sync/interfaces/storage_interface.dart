import 'dart:async';
import 'package:flipper_services/abstractions/storage.dart';

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

  Future<void> configureLocal({
    required bool useInMemory,
    required LocalStorage box,
  });
}
