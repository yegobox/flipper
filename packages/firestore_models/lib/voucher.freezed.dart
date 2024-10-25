// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Voucher _$VoucherFromJson(Map<String, dynamic> json) {
  return _Voucher.fromJson(json);
}

/// @nodoc
mixin _$Voucher {
  int? get id => throw _privateConstructorUsedError;
  int? get value => throw _privateConstructorUsedError;
  int? get interval => throw _privateConstructorUsedError;
  bool? get used => throw _privateConstructorUsedError;
  int? get createdAt => throw _privateConstructorUsedError;
  int? get usedAt => throw _privateConstructorUsedError;
  String? get descriptor => throw _privateConstructorUsedError;

  /// Serializes this Voucher to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoucherCopyWith<Voucher> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoucherCopyWith<$Res> {
  factory $VoucherCopyWith(Voucher value, $Res Function(Voucher) then) =
      _$VoucherCopyWithImpl<$Res, Voucher>;
  @useResult
  $Res call(
      {int? id,
      int? value,
      int? interval,
      bool? used,
      int? createdAt,
      int? usedAt,
      String? descriptor});
}

/// @nodoc
class _$VoucherCopyWithImpl<$Res, $Val extends Voucher>
    implements $VoucherCopyWith<$Res> {
  _$VoucherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? value = freezed,
    Object? interval = freezed,
    Object? used = freezed,
    Object? createdAt = freezed,
    Object? usedAt = freezed,
    Object? descriptor = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int?,
      used: freezed == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      descriptor: freezed == descriptor
          ? _value.descriptor
          : descriptor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoucherImplCopyWith<$Res> implements $VoucherCopyWith<$Res> {
  factory _$$VoucherImplCopyWith(
          _$VoucherImpl value, $Res Function(_$VoucherImpl) then) =
      __$$VoucherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? value,
      int? interval,
      bool? used,
      int? createdAt,
      int? usedAt,
      String? descriptor});
}

/// @nodoc
class __$$VoucherImplCopyWithImpl<$Res>
    extends _$VoucherCopyWithImpl<$Res, _$VoucherImpl>
    implements _$$VoucherImplCopyWith<$Res> {
  __$$VoucherImplCopyWithImpl(
      _$VoucherImpl _value, $Res Function(_$VoucherImpl) _then)
      : super(_value, _then);

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? value = freezed,
    Object? interval = freezed,
    Object? used = freezed,
    Object? createdAt = freezed,
    Object? usedAt = freezed,
    Object? descriptor = freezed,
  }) {
    return _then(_$VoucherImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int?,
      used: freezed == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      descriptor: freezed == descriptor
          ? _value.descriptor
          : descriptor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VoucherImpl implements _Voucher {
  const _$VoucherImpl(
      {this.id,
      this.value,
      this.interval,
      this.used,
      this.createdAt,
      this.usedAt,
      this.descriptor});

  factory _$VoucherImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoucherImplFromJson(json);

  @override
  final int? id;
  @override
  final int? value;
  @override
  final int? interval;
  @override
  final bool? used;
  @override
  final int? createdAt;
  @override
  final int? usedAt;
  @override
  final String? descriptor;

  @override
  String toString() {
    return 'Voucher(id: $id, value: $value, interval: $interval, used: $used, createdAt: $createdAt, usedAt: $usedAt, descriptor: $descriptor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoucherImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.descriptor, descriptor) ||
                other.descriptor == descriptor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, value, interval, used, createdAt, usedAt, descriptor);

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoucherImplCopyWith<_$VoucherImpl> get copyWith =>
      __$$VoucherImplCopyWithImpl<_$VoucherImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoucherImplToJson(
      this,
    );
  }
}

abstract class _Voucher implements Voucher {
  const factory _Voucher(
      {final int? id,
      final int? value,
      final int? interval,
      final bool? used,
      final int? createdAt,
      final int? usedAt,
      final String? descriptor}) = _$VoucherImpl;

  factory _Voucher.fromJson(Map<String, dynamic> json) = _$VoucherImpl.fromJson;

  @override
  int? get id;
  @override
  int? get value;
  @override
  int? get interval;
  @override
  bool? get used;
  @override
  int? get createdAt;
  @override
  int? get usedAt;
  @override
  String? get descriptor;

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoucherImplCopyWith<_$VoucherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
