import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';

part 'business_feature.g.dart';

@JsonSerializable()
class BusinessFeature extends IJsonSerializable {
  @JsonKey(name: '_id')
  String id;
  String businessId;
  List<String> features;

  BusinessFeature({
    required this.id,
    required this.businessId,
    required this.features,
  });

  factory BusinessFeature.fromJson(Map<String, dynamic> json) =>
      _$BusinessFeatureFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BusinessFeatureToJson(this);
}
