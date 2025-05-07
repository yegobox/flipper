import 'package:flipper_models/sync/mixins/asset_mixin.dart';

mixin AssetMixin implements AssetInterface {
  @override
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) {
    throw UnimplementedError();
  }

  @override
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) {
    throw UnimplementedError();
  }
}
