import 'package:freezed_annotation/freezed_annotation.dart';

part 'assets.freezed.dart';
part 'assets.g.dart';

@freezed
class Assets with _$Assets {
  const factory Assets({
    int? id,
    int? branchId,
    int? businessId,
    String? assetName,
    int? productId,
  }) = _Assets;

  factory Assets.fromJson(Map<String, dynamic> json) => _$AssetsFromJson(json);
}
