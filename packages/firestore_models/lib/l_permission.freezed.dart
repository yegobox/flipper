// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'l_permission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LPermission _$LPermissionFromJson(Map<String, dynamic> json) {
  return _LPermission.fromJson(json);
}

/// @nodoc
mixin _$LPermission {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;

  /// Serializes this LPermission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LPermission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LPermissionCopyWith<LPermission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LPermissionCopyWith<$Res> {
  factory $LPermissionCopyWith(
          LPermission value, $Res Function(LPermission) then) =
      _$LPermissionCopyWithImpl<$Res, LPermission>;
  @useResult
  $Res call({int? id, String? name, int? userId});
}

/// @nodoc
class _$LPermissionCopyWithImpl<$Res, $Val extends LPermission>
    implements $LPermissionCopyWith<$Res> {
  _$LPermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LPermission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? userId = freezed,
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
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LPermissionImplCopyWith<$Res>
    implements $LPermissionCopyWith<$Res> {
  factory _$$LPermissionImplCopyWith(
          _$LPermissionImpl value, $Res Function(_$LPermissionImpl) then) =
      __$$LPermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name, int? userId});
}

/// @nodoc
class __$$LPermissionImplCopyWithImpl<$Res>
    extends _$LPermissionCopyWithImpl<$Res, _$LPermissionImpl>
    implements _$$LPermissionImplCopyWith<$Res> {
  __$$LPermissionImplCopyWithImpl(
      _$LPermissionImpl _value, $Res Function(_$LPermissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of LPermission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? userId = freezed,
  }) {
    return _then(_$LPermissionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LPermissionImpl implements _LPermission {
  const _$LPermissionImpl({this.id, this.name, this.userId});

  factory _$LPermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LPermissionImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final int? userId;

  @override
  String toString() {
    return 'LPermission(id: $id, name: $name, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LPermissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, userId);

  /// Create a copy of LPermission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LPermissionImplCopyWith<_$LPermissionImpl> get copyWith =>
      __$$LPermissionImplCopyWithImpl<_$LPermissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LPermissionImplToJson(
      this,
    );
  }
}

abstract class _LPermission implements LPermission {
  const factory _LPermission(
      {final int? id,
      final String? name,
      final int? userId}) = _$LPermissionImpl;

  factory _LPermission.fromJson(Map<String, dynamic> json) =
      _$LPermissionImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  int? get userId;

  /// Create a copy of LPermission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LPermissionImplCopyWith<_$LPermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
