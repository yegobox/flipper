// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Assets _$AssetsFromJson(Map<String, dynamic> json) {
  return _Assets.fromJson(json);
}

/// @nodoc
mixin _$Assets {
  int? get id => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  String? get assetName => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;

  /// Serializes this Assets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetsCopyWith<Assets> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetsCopyWith<$Res> {
  factory $AssetsCopyWith(Assets value, $Res Function(Assets) then) =
      _$AssetsCopyWithImpl<$Res, Assets>;
  @useResult
  $Res call(
      {int? id,
      int? branchId,
      int? businessId,
      String? assetName,
      int? productId});
}

/// @nodoc
class _$AssetsCopyWithImpl<$Res, $Val extends Assets>
    implements $AssetsCopyWith<$Res> {
  _$AssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? branchId = freezed,
    Object? businessId = freezed,
    Object? assetName = freezed,
    Object? productId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      assetName: freezed == assetName
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetsImplCopyWith<$Res> implements $AssetsCopyWith<$Res> {
  factory _$$AssetsImplCopyWith(
          _$AssetsImpl value, $Res Function(_$AssetsImpl) then) =
      __$$AssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? branchId,
      int? businessId,
      String? assetName,
      int? productId});
}

/// @nodoc
class __$$AssetsImplCopyWithImpl<$Res>
    extends _$AssetsCopyWithImpl<$Res, _$AssetsImpl>
    implements _$$AssetsImplCopyWith<$Res> {
  __$$AssetsImplCopyWithImpl(
      _$AssetsImpl _value, $Res Function(_$AssetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? branchId = freezed,
    Object? businessId = freezed,
    Object? assetName = freezed,
    Object? productId = freezed,
  }) {
    return _then(_$AssetsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      assetName: freezed == assetName
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetsImpl implements _Assets {
  const _$AssetsImpl(
      {this.id,
      this.branchId,
      this.businessId,
      this.assetName,
      this.productId});

  factory _$AssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetsImplFromJson(json);

  @override
  final int? id;
  @override
  final int? branchId;
  @override
  final int? businessId;
  @override
  final String? assetName;
  @override
  final int? productId;

  @override
  String toString() {
    return 'Assets(id: $id, branchId: $branchId, businessId: $businessId, assetName: $assetName, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.assetName, assetName) ||
                other.assetName == assetName) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, branchId, businessId, assetName, productId);

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetsImplCopyWith<_$AssetsImpl> get copyWith =>
      __$$AssetsImplCopyWithImpl<_$AssetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetsImplToJson(
      this,
    );
  }
}

abstract class _Assets implements Assets {
  const factory _Assets(
      {final int? id,
      final int? branchId,
      final int? businessId,
      final String? assetName,
      final int? productId}) = _$AssetsImpl;

  factory _Assets.fromJson(Map<String, dynamic> json) = _$AssetsImpl.fromJson;

  @override
  int? get id;
  @override
  int? get branchId;
  @override
  int? get businessId;
  @override
  String? get assetName;
  @override
  int? get productId;

  /// Create a copy of Assets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetsImplCopyWith<_$AssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
