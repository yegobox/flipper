// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sku.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SKU _$SKUFromJson(Map<String, dynamic> json) {
  return _SKU.fromJson(json);
}

/// @nodoc
mixin _$SKU {
  int? get id => throw _privateConstructorUsedError;
  int? get sku => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  bool? get consumed => throw _privateConstructorUsedError;

  /// Serializes this SKU to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SKU
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SKUCopyWith<SKU> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SKUCopyWith<$Res> {
  factory $SKUCopyWith(SKU value, $Res Function(SKU) then) =
      _$SKUCopyWithImpl<$Res, SKU>;
  @useResult
  $Res call(
      {int? id, int? sku, int? branchId, int? businessId, bool? consumed});
}

/// @nodoc
class _$SKUCopyWithImpl<$Res, $Val extends SKU> implements $SKUCopyWith<$Res> {
  _$SKUCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SKU
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sku = freezed,
    Object? branchId = freezed,
    Object? businessId = freezed,
    Object? consumed = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      consumed: freezed == consumed
          ? _value.consumed
          : consumed // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SKUImplCopyWith<$Res> implements $SKUCopyWith<$Res> {
  factory _$$SKUImplCopyWith(_$SKUImpl value, $Res Function(_$SKUImpl) then) =
      __$$SKUImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id, int? sku, int? branchId, int? businessId, bool? consumed});
}

/// @nodoc
class __$$SKUImplCopyWithImpl<$Res> extends _$SKUCopyWithImpl<$Res, _$SKUImpl>
    implements _$$SKUImplCopyWith<$Res> {
  __$$SKUImplCopyWithImpl(_$SKUImpl _value, $Res Function(_$SKUImpl) _then)
      : super(_value, _then);

  /// Create a copy of SKU
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sku = freezed,
    Object? branchId = freezed,
    Object? businessId = freezed,
    Object? consumed = freezed,
  }) {
    return _then(_$SKUImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      consumed: freezed == consumed
          ? _value.consumed
          : consumed // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SKUImpl implements _SKU {
  const _$SKUImpl(
      {this.id, this.sku, this.branchId, this.businessId, this.consumed});

  factory _$SKUImpl.fromJson(Map<String, dynamic> json) =>
      _$$SKUImplFromJson(json);

  @override
  final int? id;
  @override
  final int? sku;
  @override
  final int? branchId;
  @override
  final int? businessId;
  @override
  final bool? consumed;

  @override
  String toString() {
    return 'SKU(id: $id, sku: $sku, branchId: $branchId, businessId: $businessId, consumed: $consumed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SKUImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.consumed, consumed) ||
                other.consumed == consumed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sku, branchId, businessId, consumed);

  /// Create a copy of SKU
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SKUImplCopyWith<_$SKUImpl> get copyWith =>
      __$$SKUImplCopyWithImpl<_$SKUImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SKUImplToJson(
      this,
    );
  }
}

abstract class _SKU implements SKU {
  const factory _SKU(
      {final int? id,
      final int? sku,
      final int? branchId,
      final int? businessId,
      final bool? consumed}) = _$SKUImpl;

  factory _SKU.fromJson(Map<String, dynamic> json) = _$SKUImpl.fromJson;

  @override
  int? get id;
  @override
  int? get sku;
  @override
  int? get branchId;
  @override
  int? get businessId;
  @override
  bool? get consumed;

  /// Create a copy of SKU
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SKUImplCopyWith<_$SKUImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
