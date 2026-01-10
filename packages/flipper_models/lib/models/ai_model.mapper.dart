// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ai_model.dart';

class AIModelMapper extends ClassMapperBase<AIModel> {
  AIModelMapper._();

  static AIModelMapper? _instance;
  static AIModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AIModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AIModel';

  static String _$id(AIModel v) => v.id;
  static const Field<AIModel, String> _f$id = Field('id', _$id);
  static String _$name(AIModel v) => v.name;
  static const Field<AIModel, String> _f$name = Field('name', _$name);
  static String _$modelId(AIModel v) => v.modelId;
  static const Field<AIModel, String> _f$modelId = Field('modelId', _$modelId);
  static String _$provider(AIModel v) => v.provider;
  static const Field<AIModel, String> _f$provider = Field(
    'provider',
    _$provider,
  );
  static String _$apiUrl(AIModel v) => v.apiUrl;
  static const Field<AIModel, String> _f$apiUrl = Field('apiUrl', _$apiUrl);
  static String? _$apiKey(AIModel v) => v.apiKey;
  static const Field<AIModel, String> _f$apiKey = Field(
    'apiKey',
    _$apiKey,
    opt: true,
  );
  static bool _$isActive(AIModel v) => v.isActive;
  static const Field<AIModel, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static bool _$isDefault(AIModel v) => v.isDefault;
  static const Field<AIModel, bool> _f$isDefault = Field(
    'isDefault',
    _$isDefault,
    opt: true,
    def: false,
  );
  static bool _$isPaidOnly(AIModel v) => v.isPaidOnly;
  static const Field<AIModel, bool> _f$isPaidOnly = Field(
    'isPaidOnly',
    _$isPaidOnly,
    key: r'is_paid_only',
    opt: true,
    def: false,
  );
  static String? _$apiStandard(AIModel v) => v.apiStandard;
  static const Field<AIModel, String> _f$apiStandard = Field(
    'apiStandard',
    _$apiStandard,
    opt: true,
  );
  static int _$maxTokens(AIModel v) => v.maxTokens;
  static const Field<AIModel, int> _f$maxTokens = Field(
    'maxTokens',
    _$maxTokens,
    opt: true,
    def: 2048,
  );
  static double _$temperature(AIModel v) => v.temperature;
  static const Field<AIModel, double> _f$temperature = Field(
    'temperature',
    _$temperature,
    opt: true,
    def: 0.2,
  );
  static DateTime _$createdAt(AIModel v) => v.createdAt;
  static const Field<AIModel, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(AIModel v) => v.updatedAt;
  static const Field<AIModel, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<AIModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #modelId: _f$modelId,
    #provider: _f$provider,
    #apiUrl: _f$apiUrl,
    #apiKey: _f$apiKey,
    #isActive: _f$isActive,
    #isDefault: _f$isDefault,
    #isPaidOnly: _f$isPaidOnly,
    #apiStandard: _f$apiStandard,
    #maxTokens: _f$maxTokens,
    #temperature: _f$temperature,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static AIModel _instantiate(DecodingData data) {
    return AIModel(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      modelId: data.dec(_f$modelId),
      provider: data.dec(_f$provider),
      apiUrl: data.dec(_f$apiUrl),
      apiKey: data.dec(_f$apiKey),
      isActive: data.dec(_f$isActive),
      isDefault: data.dec(_f$isDefault),
      isPaidOnly: data.dec(_f$isPaidOnly),
      apiStandard: data.dec(_f$apiStandard),
      maxTokens: data.dec(_f$maxTokens),
      temperature: data.dec(_f$temperature),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AIModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AIModel>(map);
  }

  static AIModel fromJson(String json) {
    return ensureInitialized().decodeJson<AIModel>(json);
  }
}

mixin AIModelMappable {
  String toJson() {
    return AIModelMapper.ensureInitialized().encodeJson<AIModel>(
      this as AIModel,
    );
  }

  Map<String, dynamic> toMap() {
    return AIModelMapper.ensureInitialized().encodeMap<AIModel>(
      this as AIModel,
    );
  }

  AIModelCopyWith<AIModel, AIModel, AIModel> get copyWith =>
      _AIModelCopyWithImpl<AIModel, AIModel>(
        this as AIModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AIModelMapper.ensureInitialized().stringifyValue(this as AIModel);
  }

  @override
  bool operator ==(Object other) {
    return AIModelMapper.ensureInitialized().equalsValue(
      this as AIModel,
      other,
    );
  }

  @override
  int get hashCode {
    return AIModelMapper.ensureInitialized().hashValue(this as AIModel);
  }
}

extension AIModelValueCopy<$R, $Out> on ObjectCopyWith<$R, AIModel, $Out> {
  AIModelCopyWith<$R, AIModel, $Out> get $asAIModel =>
      $base.as((v, t, t2) => _AIModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AIModelCopyWith<$R, $In extends AIModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? name,
    String? modelId,
    String? provider,
    String? apiUrl,
    String? apiKey,
    bool? isActive,
    bool? isDefault,
    bool? isPaidOnly,
    String? apiStandard,
    int? maxTokens,
    double? temperature,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  AIModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AIModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AIModel, $Out>
    implements AIModelCopyWith<$R, AIModel, $Out> {
  _AIModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AIModel> $mapper =
      AIModelMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    String? modelId,
    String? provider,
    String? apiUrl,
    Object? apiKey = $none,
    bool? isActive,
    bool? isDefault,
    bool? isPaidOnly,
    Object? apiStandard = $none,
    int? maxTokens,
    double? temperature,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (modelId != null) #modelId: modelId,
      if (provider != null) #provider: provider,
      if (apiUrl != null) #apiUrl: apiUrl,
      if (apiKey != $none) #apiKey: apiKey,
      if (isActive != null) #isActive: isActive,
      if (isDefault != null) #isDefault: isDefault,
      if (isPaidOnly != null) #isPaidOnly: isPaidOnly,
      if (apiStandard != $none) #apiStandard: apiStandard,
      if (maxTokens != null) #maxTokens: maxTokens,
      if (temperature != null) #temperature: temperature,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  AIModel $make(CopyWithData data) => AIModel(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    modelId: data.get(#modelId, or: $value.modelId),
    provider: data.get(#provider, or: $value.provider),
    apiUrl: data.get(#apiUrl, or: $value.apiUrl),
    apiKey: data.get(#apiKey, or: $value.apiKey),
    isActive: data.get(#isActive, or: $value.isActive),
    isDefault: data.get(#isDefault, or: $value.isDefault),
    isPaidOnly: data.get(#isPaidOnly, or: $value.isPaidOnly),
    apiStandard: data.get(#apiStandard, or: $value.apiStandard),
    maxTokens: data.get(#maxTokens, or: $value.maxTokens),
    temperature: data.get(#temperature, or: $value.temperature),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  AIModelCopyWith<$R2, AIModel, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AIModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

