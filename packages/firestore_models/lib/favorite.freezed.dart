// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Favorite _$FavoriteFromJson(Map<String, dynamic> json) {
  return _Favorite.fromJson(json);
}

/// @nodoc
mixin _$Favorite {
  int? get id => throw _privateConstructorUsedError;
  int? get favIndex => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Favorite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteCopyWith<Favorite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteCopyWith<$Res> {
  factory $FavoriteCopyWith(Favorite value, $Res Function(Favorite) then) =
      _$FavoriteCopyWithImpl<$Res, Favorite>;
  @useResult
  $Res call(
      {int? id,
      int? favIndex,
      int? productId,
      int? branchId,
      DateTime? lastTouched,
      DateTime? deletedAt});
}

/// @nodoc
class _$FavoriteCopyWithImpl<$Res, $Val extends Favorite>
    implements $FavoriteCopyWith<$Res> {
  _$FavoriteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? favIndex = freezed,
    Object? productId = freezed,
    Object? branchId = freezed,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      favIndex: freezed == favIndex
          ? _value.favIndex
          : favIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoriteImplCopyWith<$Res>
    implements $FavoriteCopyWith<$Res> {
  factory _$$FavoriteImplCopyWith(
          _$FavoriteImpl value, $Res Function(_$FavoriteImpl) then) =
      __$$FavoriteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? favIndex,
      int? productId,
      int? branchId,
      DateTime? lastTouched,
      DateTime? deletedAt});
}

/// @nodoc
class __$$FavoriteImplCopyWithImpl<$Res>
    extends _$FavoriteCopyWithImpl<$Res, _$FavoriteImpl>
    implements _$$FavoriteImplCopyWith<$Res> {
  __$$FavoriteImplCopyWithImpl(
      _$FavoriteImpl _value, $Res Function(_$FavoriteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? favIndex = freezed,
    Object? productId = freezed,
    Object? branchId = freezed,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$FavoriteImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      favIndex: freezed == favIndex
          ? _value.favIndex
          : favIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteImpl implements _Favorite {
  const _$FavoriteImpl(
      {this.id,
      this.favIndex,
      this.productId,
      this.branchId,
      this.lastTouched,
      this.deletedAt});

  factory _$FavoriteImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteImplFromJson(json);

  @override
  final int? id;
  @override
  final int? favIndex;
  @override
  final int? productId;
  @override
  final int? branchId;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'Favorite(id: $id, favIndex: $favIndex, productId: $productId, branchId: $branchId, lastTouched: $lastTouched, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.favIndex, favIndex) ||
                other.favIndex == favIndex) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, favIndex, productId, branchId, lastTouched, deletedAt);

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteImplCopyWith<_$FavoriteImpl> get copyWith =>
      __$$FavoriteImplCopyWithImpl<_$FavoriteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteImplToJson(
      this,
    );
  }
}

abstract class _Favorite implements Favorite {
  const factory _Favorite(
      {final int? id,
      final int? favIndex,
      final int? productId,
      final int? branchId,
      final DateTime? lastTouched,
      final DateTime? deletedAt}) = _$FavoriteImpl;

  factory _Favorite.fromJson(Map<String, dynamic> json) =
      _$FavoriteImpl.fromJson;

  @override
  int? get id;
  @override
  int? get favIndex;
  @override
  int? get productId;
  @override
  int? get branchId;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteImplCopyWith<_$FavoriteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
