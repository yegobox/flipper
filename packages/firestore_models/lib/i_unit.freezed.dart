// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'i_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IUnit _$IUnitFromJson(Map<String, dynamic> json) {
  return _IUnit.fromJson(json);
}

/// @nodoc
mixin _$IUnit {
  int? get id => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  bool? get active => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this IUnit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IUnitCopyWith<IUnit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IUnitCopyWith<$Res> {
  factory $IUnitCopyWith(IUnit value, $Res Function(IUnit) then) =
      _$IUnitCopyWithImpl<$Res, IUnit>;
  @useResult
  $Res call(
      {int? id,
      int? branchId,
      String? name,
      String? value,
      bool? active,
      DateTime? lastTouched,
      String? createdAt,
      DateTime? deletedAt});
}

/// @nodoc
class _$IUnitCopyWithImpl<$Res, $Val extends IUnit>
    implements $IUnitCopyWith<$Res> {
  _$IUnitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? branchId = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? active = freezed,
    Object? lastTouched = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
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
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IUnitImplCopyWith<$Res> implements $IUnitCopyWith<$Res> {
  factory _$$IUnitImplCopyWith(
          _$IUnitImpl value, $Res Function(_$IUnitImpl) then) =
      __$$IUnitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? branchId,
      String? name,
      String? value,
      bool? active,
      DateTime? lastTouched,
      String? createdAt,
      DateTime? deletedAt});
}

/// @nodoc
class __$$IUnitImplCopyWithImpl<$Res>
    extends _$IUnitCopyWithImpl<$Res, _$IUnitImpl>
    implements _$$IUnitImplCopyWith<$Res> {
  __$$IUnitImplCopyWithImpl(
      _$IUnitImpl _value, $Res Function(_$IUnitImpl) _then)
      : super(_value, _then);

  /// Create a copy of IUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? branchId = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? active = freezed,
    Object? lastTouched = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$IUnitImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IUnitImpl implements _IUnit {
  const _$IUnitImpl(
      {this.id,
      this.branchId,
      this.name,
      this.value,
      this.active,
      this.lastTouched,
      this.createdAt,
      this.deletedAt});

  factory _$IUnitImpl.fromJson(Map<String, dynamic> json) =>
      _$$IUnitImplFromJson(json);

  @override
  final int? id;
  @override
  final int? branchId;
  @override
  final String? name;
  @override
  final String? value;
  @override
  final bool? active;
  @override
  final DateTime? lastTouched;
  @override
  final String? createdAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'IUnit(id: $id, branchId: $branchId, name: $name, value: $value, active: $active, lastTouched: $lastTouched, createdAt: $createdAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IUnitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, branchId, name, value,
      active, lastTouched, createdAt, deletedAt);

  /// Create a copy of IUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IUnitImplCopyWith<_$IUnitImpl> get copyWith =>
      __$$IUnitImplCopyWithImpl<_$IUnitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IUnitImplToJson(
      this,
    );
  }
}

abstract class _IUnit implements IUnit {
  const factory _IUnit(
      {final int? id,
      final int? branchId,
      final String? name,
      final String? value,
      final bool? active,
      final DateTime? lastTouched,
      final String? createdAt,
      final DateTime? deletedAt}) = _$IUnitImpl;

  factory _IUnit.fromJson(Map<String, dynamic> json) = _$IUnitImpl.fromJson;

  @override
  int? get id;
  @override
  int? get branchId;
  @override
  String? get name;
  @override
  String? get value;
  @override
  bool? get active;
  @override
  DateTime? get lastTouched;
  @override
  String? get createdAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of IUnit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IUnitImplCopyWith<_$IUnitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
