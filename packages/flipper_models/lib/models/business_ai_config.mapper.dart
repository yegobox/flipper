// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'business_ai_config.dart';

class BusinessAIConfigMapper extends ClassMapperBase<BusinessAIConfig> {
  BusinessAIConfigMapper._();

  static BusinessAIConfigMapper? _instance;
  static BusinessAIConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BusinessAIConfigMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BusinessAIConfig';

  static String _$id(BusinessAIConfig v) => v.id;
  static const Field<BusinessAIConfig, String> _f$id = Field('id', _$id);
  static String _$businessId(BusinessAIConfig v) => v.businessId;
  static const Field<BusinessAIConfig, String> _f$businessId = Field(
    'businessId',
    _$businessId,
    key: r'business_id',
  );
  static String? _$aiModelId(BusinessAIConfig v) => v.aiModelId;
  static const Field<BusinessAIConfig, String> _f$aiModelId = Field(
    'aiModelId',
    _$aiModelId,
    key: r'ai_model_id',
    opt: true,
  );
  static int _$usageLimit(BusinessAIConfig v) => v.usageLimit;
  static const Field<BusinessAIConfig, int> _f$usageLimit = Field(
    'usageLimit',
    _$usageLimit,
    key: r'usage_limit',
    opt: true,
    def: 100,
  );
  static int _$currentUsage(BusinessAIConfig v) => v.currentUsage;
  static const Field<BusinessAIConfig, int> _f$currentUsage = Field(
    'currentUsage',
    _$currentUsage,
    key: r'current_usage',
    opt: true,
    def: 0,
  );
  static DateTime _$updatedAt(BusinessAIConfig v) => v.updatedAt;
  static const Field<BusinessAIConfig, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<BusinessAIConfig> fields = const {
    #id: _f$id,
    #businessId: _f$businessId,
    #aiModelId: _f$aiModelId,
    #usageLimit: _f$usageLimit,
    #currentUsage: _f$currentUsage,
    #updatedAt: _f$updatedAt,
  };

  static BusinessAIConfig _instantiate(DecodingData data) {
    return BusinessAIConfig(
      id: data.dec(_f$id),
      businessId: data.dec(_f$businessId),
      aiModelId: data.dec(_f$aiModelId),
      usageLimit: data.dec(_f$usageLimit),
      currentUsage: data.dec(_f$currentUsage),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BusinessAIConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BusinessAIConfig>(map);
  }

  static BusinessAIConfig fromJson(String json) {
    return ensureInitialized().decodeJson<BusinessAIConfig>(json);
  }
}

mixin BusinessAIConfigMappable {
  String toJson() {
    return BusinessAIConfigMapper.ensureInitialized()
        .encodeJson<BusinessAIConfig>(this as BusinessAIConfig);
  }

  Map<String, dynamic> toMap() {
    return BusinessAIConfigMapper.ensureInitialized()
        .encodeMap<BusinessAIConfig>(this as BusinessAIConfig);
  }

  BusinessAIConfigCopyWith<BusinessAIConfig, BusinessAIConfig, BusinessAIConfig>
  get copyWith =>
      _BusinessAIConfigCopyWithImpl<BusinessAIConfig, BusinessAIConfig>(
        this as BusinessAIConfig,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BusinessAIConfigMapper.ensureInitialized().stringifyValue(
      this as BusinessAIConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return BusinessAIConfigMapper.ensureInitialized().equalsValue(
      this as BusinessAIConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return BusinessAIConfigMapper.ensureInitialized().hashValue(
      this as BusinessAIConfig,
    );
  }
}

extension BusinessAIConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BusinessAIConfig, $Out> {
  BusinessAIConfigCopyWith<$R, BusinessAIConfig, $Out>
  get $asBusinessAIConfig =>
      $base.as((v, t, t2) => _BusinessAIConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BusinessAIConfigCopyWith<$R, $In extends BusinessAIConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? businessId,
    String? aiModelId,
    int? usageLimit,
    int? currentUsage,
    DateTime? updatedAt,
  });
  BusinessAIConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BusinessAIConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BusinessAIConfig, $Out>
    implements BusinessAIConfigCopyWith<$R, BusinessAIConfig, $Out> {
  _BusinessAIConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BusinessAIConfig> $mapper =
      BusinessAIConfigMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? businessId,
    Object? aiModelId = $none,
    int? usageLimit,
    int? currentUsage,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (businessId != null) #businessId: businessId,
      if (aiModelId != $none) #aiModelId: aiModelId,
      if (usageLimit != null) #usageLimit: usageLimit,
      if (currentUsage != null) #currentUsage: currentUsage,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  BusinessAIConfig $make(CopyWithData data) => BusinessAIConfig(
    id: data.get(#id, or: $value.id),
    businessId: data.get(#businessId, or: $value.businessId),
    aiModelId: data.get(#aiModelId, or: $value.aiModelId),
    usageLimit: data.get(#usageLimit, or: $value.usageLimit),
    currentUsage: data.get(#currentUsage, or: $value.currentUsage),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  BusinessAIConfigCopyWith<$R2, BusinessAIConfig, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BusinessAIConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

