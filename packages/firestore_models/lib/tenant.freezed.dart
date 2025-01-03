// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tenant _$TenantFromJson(Map<String, dynamic> json) {
  return _Tenant.fromJson(json);
}

/// @nodoc
mixin _$Tenant {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  bool? get nfcEnabled => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String? get imageUrl =>
      throw _privateConstructorUsedError; // DateTime? lastTouched,
// DateTime? deletedAt,
  int? get pin => throw _privateConstructorUsedError;
  bool? get sessionActive => throw _privateConstructorUsedError;
  bool? get isDefault =>
      throw _privateConstructorUsedError; // Helper properties (not persisted)
  bool? get isLongPressed => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this Tenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantCopyWith<Tenant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantCopyWith<$Res> {
  factory $TenantCopyWith(Tenant value, $Res Function(Tenant) then) =
      _$TenantCopyWithImpl<$Res, Tenant>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? phoneNumber,
      String? email,
      bool? nfcEnabled,
      int? businessId,
      int? userId,
      String? imageUrl,
      int? pin,
      bool? sessionActive,
      bool? isDefault,
      bool? isLongPressed,
      String? type});
}

/// @nodoc
class _$TenantCopyWithImpl<$Res, $Val extends Tenant>
    implements $TenantCopyWith<$Res> {
  _$TenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? nfcEnabled = freezed,
    Object? businessId = freezed,
    Object? userId = freezed,
    Object? imageUrl = freezed,
    Object? pin = freezed,
    Object? sessionActive = freezed,
    Object? isDefault = freezed,
    Object? isLongPressed = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nfcEnabled: freezed == nfcEnabled
          ? _value.nfcEnabled
          : nfcEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pin: freezed == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionActive: freezed == sessionActive
          ? _value.sessionActive
          : sessionActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDefault: freezed == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
      isLongPressed: freezed == isLongPressed
          ? _value.isLongPressed
          : isLongPressed // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TenantImplCopyWith<$Res> implements $TenantCopyWith<$Res> {
  factory _$$TenantImplCopyWith(
          _$TenantImpl value, $Res Function(_$TenantImpl) then) =
      __$$TenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? phoneNumber,
      String? email,
      bool? nfcEnabled,
      int? businessId,
      int? userId,
      String? imageUrl,
      int? pin,
      bool? sessionActive,
      bool? isDefault,
      bool? isLongPressed,
      String? type});
}

/// @nodoc
class __$$TenantImplCopyWithImpl<$Res>
    extends _$TenantCopyWithImpl<$Res, _$TenantImpl>
    implements _$$TenantImplCopyWith<$Res> {
  __$$TenantImplCopyWithImpl(
      _$TenantImpl _value, $Res Function(_$TenantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? nfcEnabled = freezed,
    Object? businessId = freezed,
    Object? userId = freezed,
    Object? imageUrl = freezed,
    Object? pin = freezed,
    Object? sessionActive = freezed,
    Object? isDefault = freezed,
    Object? isLongPressed = freezed,
    Object? type = freezed,
  }) {
    return _then(_$TenantImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nfcEnabled: freezed == nfcEnabled
          ? _value.nfcEnabled
          : nfcEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pin: freezed == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionActive: freezed == sessionActive
          ? _value.sessionActive
          : sessionActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDefault: freezed == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
      isLongPressed: freezed == isLongPressed
          ? _value.isLongPressed
          : isLongPressed // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantImpl implements _Tenant {
  const _$TenantImpl(
      {this.id,
      this.name,
      this.phoneNumber,
      this.email,
      this.nfcEnabled,
      this.businessId,
      this.userId,
      this.imageUrl,
      this.pin,
      this.sessionActive,
      this.isDefault,
      this.isLongPressed,
      this.type});

  factory _$TenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? phoneNumber;
  @override
  final String? email;
  @override
  final bool? nfcEnabled;
  @override
  final int? businessId;
  @override
  final int? userId;
  @override
  final String? imageUrl;
// DateTime? lastTouched,
// DateTime? deletedAt,
  @override
  final int? pin;
  @override
  final bool? sessionActive;
  @override
  final bool? isDefault;
// Helper properties (not persisted)
  @override
  final bool? isLongPressed;
  @override
  final String? type;

  @override
  String toString() {
    return 'Tenant(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, nfcEnabled: $nfcEnabled, businessId: $businessId, userId: $userId, imageUrl: $imageUrl, pin: $pin, sessionActive: $sessionActive, isDefault: $isDefault, isLongPressed: $isLongPressed, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nfcEnabled, nfcEnabled) ||
                other.nfcEnabled == nfcEnabled) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.sessionActive, sessionActive) ||
                other.sessionActive == sessionActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isLongPressed, isLongPressed) ||
                other.isLongPressed == isLongPressed) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      phoneNumber,
      email,
      nfcEnabled,
      businessId,
      userId,
      imageUrl,
      pin,
      sessionActive,
      isDefault,
      isLongPressed,
      type);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      __$$TenantImplCopyWithImpl<_$TenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantImplToJson(
      this,
    );
  }
}

abstract class _Tenant implements Tenant {
  const factory _Tenant(
      {final int? id,
      final String? name,
      final String? phoneNumber,
      final String? email,
      final bool? nfcEnabled,
      final int? businessId,
      final int? userId,
      final String? imageUrl,
      final int? pin,
      final bool? sessionActive,
      final bool? isDefault,
      final bool? isLongPressed,
      final String? type}) = _$TenantImpl;

  factory _Tenant.fromJson(Map<String, dynamic> json) = _$TenantImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get phoneNumber;
  @override
  String? get email;
  @override
  bool? get nfcEnabled;
  @override
  int? get businessId;
  @override
  int? get userId;
  @override
  String? get imageUrl; // DateTime? lastTouched,
// DateTime? deletedAt,
  @override
  int? get pin;
  @override
  bool? get sessionActive;
  @override
  bool? get isDefault; // Helper properties (not persisted)
  @override
  bool? get isLongPressed;
  @override
  String? get type;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
