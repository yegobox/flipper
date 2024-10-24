// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'configurations.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Configurations _$ConfigurationsFromJson(Map<String, dynamic> json) {
  return _Configurations.fromJson(json);
}

/// @nodoc
mixin _$Configurations {
  int? get id => throw _privateConstructorUsedError;
  String? get taxType => throw _privateConstructorUsedError;
  double? get taxPercentage => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;

  /// Serializes this Configurations to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Configurations
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigurationsCopyWith<Configurations> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigurationsCopyWith<$Res> {
  factory $ConfigurationsCopyWith(
          Configurations value, $Res Function(Configurations) then) =
      _$ConfigurationsCopyWithImpl<$Res, Configurations>;
  @useResult
  $Res call(
      {int? id,
      String? taxType,
      double? taxPercentage,
      int? businessId,
      int? branchId});
}

/// @nodoc
class _$ConfigurationsCopyWithImpl<$Res, $Val extends Configurations>
    implements $ConfigurationsCopyWith<$Res> {
  _$ConfigurationsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Configurations
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taxType = freezed,
    Object? taxPercentage = freezed,
    Object? businessId = freezed,
    Object? branchId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      taxType: freezed == taxType
          ? _value.taxType
          : taxType // ignore: cast_nullable_to_non_nullable
              as String?,
      taxPercentage: freezed == taxPercentage
          ? _value.taxPercentage
          : taxPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigurationsImplCopyWith<$Res>
    implements $ConfigurationsCopyWith<$Res> {
  factory _$$ConfigurationsImplCopyWith(_$ConfigurationsImpl value,
          $Res Function(_$ConfigurationsImpl) then) =
      __$$ConfigurationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? taxType,
      double? taxPercentage,
      int? businessId,
      int? branchId});
}

/// @nodoc
class __$$ConfigurationsImplCopyWithImpl<$Res>
    extends _$ConfigurationsCopyWithImpl<$Res, _$ConfigurationsImpl>
    implements _$$ConfigurationsImplCopyWith<$Res> {
  __$$ConfigurationsImplCopyWithImpl(
      _$ConfigurationsImpl _value, $Res Function(_$ConfigurationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Configurations
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taxType = freezed,
    Object? taxPercentage = freezed,
    Object? businessId = freezed,
    Object? branchId = freezed,
  }) {
    return _then(_$ConfigurationsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      taxType: freezed == taxType
          ? _value.taxType
          : taxType // ignore: cast_nullable_to_non_nullable
              as String?,
      taxPercentage: freezed == taxPercentage
          ? _value.taxPercentage
          : taxPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigurationsImpl implements _Configurations {
  const _$ConfigurationsImpl(
      {this.id,
      this.taxType,
      this.taxPercentage,
      this.businessId,
      this.branchId});

  factory _$ConfigurationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigurationsImplFromJson(json);

  @override
  final int? id;
  @override
  final String? taxType;
  @override
  final double? taxPercentage;
  @override
  final int? businessId;
  @override
  final int? branchId;

  @override
  String toString() {
    return 'Configurations(id: $id, taxType: $taxType, taxPercentage: $taxPercentage, businessId: $businessId, branchId: $branchId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigurationsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taxType, taxType) || other.taxType == taxType) &&
            (identical(other.taxPercentage, taxPercentage) ||
                other.taxPercentage == taxPercentage) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, taxType, taxPercentage, businessId, branchId);

  /// Create a copy of Configurations
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigurationsImplCopyWith<_$ConfigurationsImpl> get copyWith =>
      __$$ConfigurationsImplCopyWithImpl<_$ConfigurationsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigurationsImplToJson(
      this,
    );
  }
}

abstract class _Configurations implements Configurations {
  const factory _Configurations(
      {final int? id,
      final String? taxType,
      final double? taxPercentage,
      final int? businessId,
      final int? branchId}) = _$ConfigurationsImpl;

  factory _Configurations.fromJson(Map<String, dynamic> json) =
      _$ConfigurationsImpl.fromJson;

  @override
  int? get id;
  @override
  String? get taxType;
  @override
  double? get taxPercentage;
  @override
  int? get businessId;
  @override
  int? get branchId;

  /// Create a copy of Configurations
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigurationsImplCopyWith<_$ConfigurationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
