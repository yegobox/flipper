// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pcolor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PColor _$PColorFromJson(Map<String, dynamic> json) {
  return _PColor.fromJson(json);
}

/// @nodoc
mixin _$PColor {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  List<String> get colors => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this PColor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PColor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PColorCopyWith<PColor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PColorCopyWith<$Res> {
  factory $PColorCopyWith(PColor value, $Res Function(PColor) then) =
      _$PColorCopyWithImpl<$Res, PColor>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      List<String> colors,
      int? branchId,
      bool active,
      DateTime? lastTouched,
      DateTime? deletedAt});
}

/// @nodoc
class _$PColorCopyWithImpl<$Res, $Val extends PColor>
    implements $PColorCopyWith<$Res> {
  _$PColorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PColor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? colors = null,
    Object? branchId = freezed,
    Object? active = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
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
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$PColorImplCopyWith<$Res> implements $PColorCopyWith<$Res> {
  factory _$$PColorImplCopyWith(
          _$PColorImpl value, $Res Function(_$PColorImpl) then) =
      __$$PColorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      List<String> colors,
      int? branchId,
      bool active,
      DateTime? lastTouched,
      DateTime? deletedAt});
}

/// @nodoc
class __$$PColorImplCopyWithImpl<$Res>
    extends _$PColorCopyWithImpl<$Res, _$PColorImpl>
    implements _$$PColorImplCopyWith<$Res> {
  __$$PColorImplCopyWithImpl(
      _$PColorImpl _value, $Res Function(_$PColorImpl) _then)
      : super(_value, _then);

  /// Create a copy of PColor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? colors = null,
    Object? branchId = freezed,
    Object? active = null,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$PColorImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      colors: null == colors
          ? _value._colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$PColorImpl implements _PColor {
  const _$PColorImpl(
      {this.id,
      this.name,
      required final List<String> colors,
      this.branchId,
      this.active = false,
      this.lastTouched,
      this.deletedAt})
      : _colors = colors;

  factory _$PColorImpl.fromJson(Map<String, dynamic> json) =>
      _$$PColorImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  final List<String> _colors;
  @override
  List<String> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  @override
  final int? branchId;
  @override
  @JsonKey()
  final bool active;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'PColor(id: $id, name: $name, colors: $colors, branchId: $branchId, active: $active, lastTouched: $lastTouched, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PColorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_colors),
      branchId,
      active,
      lastTouched,
      deletedAt);

  /// Create a copy of PColor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PColorImplCopyWith<_$PColorImpl> get copyWith =>
      __$$PColorImplCopyWithImpl<_$PColorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PColorImplToJson(
      this,
    );
  }
}

abstract class _PColor implements PColor {
  const factory _PColor(
      {final int? id,
      final String? name,
      required final List<String> colors,
      final int? branchId,
      final bool active,
      final DateTime? lastTouched,
      final DateTime? deletedAt}) = _$PColorImpl;

  factory _PColor.fromJson(Map<String, dynamic> json) = _$PColorImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  List<String> get colors;
  @override
  int? get branchId;
  @override
  bool get active;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;

  /// Create a copy of PColor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PColorImplCopyWith<_$PColorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
