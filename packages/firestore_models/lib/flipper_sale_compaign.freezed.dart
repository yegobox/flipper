// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flipper_sale_compaign.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FlipperSaleCompaign _$FlipperSaleCompaignFromJson(Map<String, dynamic> json) {
  return _FlipperSaleCompaign.fromJson(json);
}

/// @nodoc
mixin _$FlipperSaleCompaign {
  int? get id => throw _privateConstructorUsedError;
  int? get compaignId => throw _privateConstructorUsedError;
  int? get discountRate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get couponCode => throw _privateConstructorUsedError;

  /// Serializes this FlipperSaleCompaign to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlipperSaleCompaign
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlipperSaleCompaignCopyWith<FlipperSaleCompaign> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlipperSaleCompaignCopyWith<$Res> {
  factory $FlipperSaleCompaignCopyWith(
          FlipperSaleCompaign value, $Res Function(FlipperSaleCompaign) then) =
      _$FlipperSaleCompaignCopyWithImpl<$Res, FlipperSaleCompaign>;
  @useResult
  $Res call(
      {int? id,
      int? compaignId,
      int? discountRate,
      DateTime? createdAt,
      String? couponCode});
}

/// @nodoc
class _$FlipperSaleCompaignCopyWithImpl<$Res, $Val extends FlipperSaleCompaign>
    implements $FlipperSaleCompaignCopyWith<$Res> {
  _$FlipperSaleCompaignCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlipperSaleCompaign
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? compaignId = freezed,
    Object? discountRate = freezed,
    Object? createdAt = freezed,
    Object? couponCode = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      compaignId: freezed == compaignId
          ? _value.compaignId
          : compaignId // ignore: cast_nullable_to_non_nullable
              as int?,
      discountRate: freezed == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlipperSaleCompaignImplCopyWith<$Res>
    implements $FlipperSaleCompaignCopyWith<$Res> {
  factory _$$FlipperSaleCompaignImplCopyWith(_$FlipperSaleCompaignImpl value,
          $Res Function(_$FlipperSaleCompaignImpl) then) =
      __$$FlipperSaleCompaignImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? compaignId,
      int? discountRate,
      DateTime? createdAt,
      String? couponCode});
}

/// @nodoc
class __$$FlipperSaleCompaignImplCopyWithImpl<$Res>
    extends _$FlipperSaleCompaignCopyWithImpl<$Res, _$FlipperSaleCompaignImpl>
    implements _$$FlipperSaleCompaignImplCopyWith<$Res> {
  __$$FlipperSaleCompaignImplCopyWithImpl(_$FlipperSaleCompaignImpl _value,
      $Res Function(_$FlipperSaleCompaignImpl) _then)
      : super(_value, _then);

  /// Create a copy of FlipperSaleCompaign
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? compaignId = freezed,
    Object? discountRate = freezed,
    Object? createdAt = freezed,
    Object? couponCode = freezed,
  }) {
    return _then(_$FlipperSaleCompaignImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      compaignId: freezed == compaignId
          ? _value.compaignId
          : compaignId // ignore: cast_nullable_to_non_nullable
              as int?,
      discountRate: freezed == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlipperSaleCompaignImpl implements _FlipperSaleCompaign {
  _$FlipperSaleCompaignImpl(
      {this.id,
      this.compaignId,
      this.discountRate,
      this.createdAt,
      this.couponCode});

  factory _$FlipperSaleCompaignImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlipperSaleCompaignImplFromJson(json);

  @override
  final int? id;
  @override
  final int? compaignId;
  @override
  final int? discountRate;
  @override
  final DateTime? createdAt;
  @override
  final String? couponCode;

  @override
  String toString() {
    return 'FlipperSaleCompaign(id: $id, compaignId: $compaignId, discountRate: $discountRate, createdAt: $createdAt, couponCode: $couponCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlipperSaleCompaignImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.compaignId, compaignId) ||
                other.compaignId == compaignId) &&
            (identical(other.discountRate, discountRate) ||
                other.discountRate == discountRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, compaignId, discountRate, createdAt, couponCode);

  /// Create a copy of FlipperSaleCompaign
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlipperSaleCompaignImplCopyWith<_$FlipperSaleCompaignImpl> get copyWith =>
      __$$FlipperSaleCompaignImplCopyWithImpl<_$FlipperSaleCompaignImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlipperSaleCompaignImplToJson(
      this,
    );
  }
}

abstract class _FlipperSaleCompaign implements FlipperSaleCompaign {
  factory _FlipperSaleCompaign(
      {final int? id,
      final int? compaignId,
      final int? discountRate,
      final DateTime? createdAt,
      final String? couponCode}) = _$FlipperSaleCompaignImpl;

  factory _FlipperSaleCompaign.fromJson(Map<String, dynamic> json) =
      _$FlipperSaleCompaignImpl.fromJson;

  @override
  int? get id;
  @override
  int? get compaignId;
  @override
  int? get discountRate;
  @override
  DateTime? get createdAt;
  @override
  String? get couponCode;

  /// Create a copy of FlipperSaleCompaign
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlipperSaleCompaignImplCopyWith<_$FlipperSaleCompaignImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
