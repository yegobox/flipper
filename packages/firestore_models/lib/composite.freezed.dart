// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'composite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Composite _$CompositeFromJson(Map<String, dynamic> json) {
  return _Composite.fromJson(json);
}

/// @nodoc
mixin _$Composite {
  int? get id => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  double? get qty => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  double? get actualPrice => throw _privateConstructorUsedError;

  /// Serializes this Composite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Composite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompositeCopyWith<Composite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompositeCopyWith<$Res> {
  factory $CompositeCopyWith(Composite value, $Res Function(Composite) then) =
      _$CompositeCopyWithImpl<$Res, Composite>;
  @useResult
  $Res call(
      {int? id,
      int? productId,
      int? variantId,
      double? qty,
      int? branchId,
      int? businessId,
      double? actualPrice});
}

/// @nodoc
class _$CompositeCopyWithImpl<$Res, $Val extends Composite>
    implements $CompositeCopyWith<$Res> {
  _$CompositeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Composite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? qty = freezed,
    Object? branchId = freezed,
    Object? businessId = freezed,
    Object? actualPrice = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      actualPrice: freezed == actualPrice
          ? _value.actualPrice
          : actualPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompositeImplCopyWith<$Res>
    implements $CompositeCopyWith<$Res> {
  factory _$$CompositeImplCopyWith(
          _$CompositeImpl value, $Res Function(_$CompositeImpl) then) =
      __$$CompositeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? productId,
      int? variantId,
      double? qty,
      int? branchId,
      int? businessId,
      double? actualPrice});
}

/// @nodoc
class __$$CompositeImplCopyWithImpl<$Res>
    extends _$CompositeCopyWithImpl<$Res, _$CompositeImpl>
    implements _$$CompositeImplCopyWith<$Res> {
  __$$CompositeImplCopyWithImpl(
      _$CompositeImpl _value, $Res Function(_$CompositeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Composite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? qty = freezed,
    Object? branchId = freezed,
    Object? businessId = freezed,
    Object? actualPrice = freezed,
  }) {
    return _then(_$CompositeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      actualPrice: freezed == actualPrice
          ? _value.actualPrice
          : actualPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompositeImpl implements _Composite {
  const _$CompositeImpl(
      {this.id,
      this.productId,
      this.variantId,
      this.qty,
      this.branchId,
      this.businessId,
      this.actualPrice});

  factory _$CompositeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompositeImplFromJson(json);

  @override
  final int? id;
  @override
  final int? productId;
  @override
  final int? variantId;
  @override
  final double? qty;
  @override
  final int? branchId;
  @override
  final int? businessId;
  @override
  final double? actualPrice;

  @override
  String toString() {
    return 'Composite(id: $id, productId: $productId, variantId: $variantId, qty: $qty, branchId: $branchId, businessId: $businessId, actualPrice: $actualPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompositeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.actualPrice, actualPrice) ||
                other.actualPrice == actualPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, productId, variantId, qty,
      branchId, businessId, actualPrice);

  /// Create a copy of Composite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompositeImplCopyWith<_$CompositeImpl> get copyWith =>
      __$$CompositeImplCopyWithImpl<_$CompositeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompositeImplToJson(
      this,
    );
  }
}

abstract class _Composite implements Composite {
  const factory _Composite(
      {final int? id,
      final int? productId,
      final int? variantId,
      final double? qty,
      final int? branchId,
      final int? businessId,
      final double? actualPrice}) = _$CompositeImpl;

  factory _Composite.fromJson(Map<String, dynamic> json) =
      _$CompositeImpl.fromJson;

  @override
  int? get id;
  @override
  int? get productId;
  @override
  int? get variantId;
  @override
  double? get qty;
  @override
  int? get branchId;
  @override
  int? get businessId;
  @override
  double? get actualPrice;

  /// Create a copy of Composite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompositeImplCopyWith<_$CompositeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
