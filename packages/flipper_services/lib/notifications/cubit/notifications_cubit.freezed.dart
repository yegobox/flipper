// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationsState {
  bool get enabled => throw _privateConstructorUsedError;
  NotificationResponse? get notificationResponse =>
      throw _privateConstructorUsedError;

  /// The number of overdue tasks.
  ///
  /// Tracked so we don't update the icons if the number hasn't changed.
  int get overdueTasksCount => throw _privateConstructorUsedError;
  bool get permissionGranted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsStateCopyWith<NotificationsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsStateCopyWith<$Res> {
  factory $NotificationsStateCopyWith(
          NotificationsState value, $Res Function(NotificationsState) then) =
      _$NotificationsStateCopyWithImpl<$Res, NotificationsState>;
  @useResult
  $Res call(
      {bool enabled,
      NotificationResponse? notificationResponse,
      int overdueTasksCount,
      bool permissionGranted});
}

/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res, $Val extends NotificationsState>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? notificationResponse = freezed,
    Object? overdueTasksCount = null,
    Object? permissionGranted = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationResponse: freezed == notificationResponse
          ? _value.notificationResponse
          : notificationResponse // ignore: cast_nullable_to_non_nullable
              as NotificationResponse?,
      overdueTasksCount: null == overdueTasksCount
          ? _value.overdueTasksCount
          : overdueTasksCount // ignore: cast_nullable_to_non_nullable
              as int,
      permissionGranted: null == permissionGranted
          ? _value.permissionGranted
          : permissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NotificationsStateCopyWith<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  factory _$$_NotificationsStateCopyWith(_$_NotificationsState value,
          $Res Function(_$_NotificationsState) then) =
      __$$_NotificationsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      NotificationResponse? notificationResponse,
      int overdueTasksCount,
      bool permissionGranted});
}

/// @nodoc
class __$$_NotificationsStateCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$_NotificationsState>
    implements _$$_NotificationsStateCopyWith<$Res> {
  __$$_NotificationsStateCopyWithImpl(
      _$_NotificationsState _value, $Res Function(_$_NotificationsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? notificationResponse = freezed,
    Object? overdueTasksCount = null,
    Object? permissionGranted = null,
  }) {
    return _then(_$_NotificationsState(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationResponse: freezed == notificationResponse
          ? _value.notificationResponse
          : notificationResponse // ignore: cast_nullable_to_non_nullable
              as NotificationResponse?,
      overdueTasksCount: null == overdueTasksCount
          ? _value.overdueTasksCount
          : overdueTasksCount // ignore: cast_nullable_to_non_nullable
              as int,
      permissionGranted: null == permissionGranted
          ? _value.permissionGranted
          : permissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NotificationsState
    with DiagnosticableTreeMixin
    implements _NotificationsState {
  const _$_NotificationsState(
      {required this.enabled,
      this.notificationResponse,
      required this.overdueTasksCount,
      required this.permissionGranted});

  @override
  final bool enabled;
  @override
  final NotificationResponse? notificationResponse;

  /// The number of overdue tasks.
  ///
  /// Tracked so we don't update the icons if the number hasn't changed.
  @override
  final int overdueTasksCount;
  @override
  final bool permissionGranted;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsState(enabled: $enabled, notificationResponse: $notificationResponse, overdueTasksCount: $overdueTasksCount, permissionGranted: $permissionGranted)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotificationsState'))
      ..add(DiagnosticsProperty('enabled', enabled))
      ..add(DiagnosticsProperty('notificationResponse', notificationResponse))
      ..add(DiagnosticsProperty('overdueTasksCount', overdueTasksCount))
      ..add(DiagnosticsProperty('permissionGranted', permissionGranted));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationsState &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.notificationResponse, notificationResponse) ||
                other.notificationResponse == notificationResponse) &&
            (identical(other.overdueTasksCount, overdueTasksCount) ||
                other.overdueTasksCount == overdueTasksCount) &&
            (identical(other.permissionGranted, permissionGranted) ||
                other.permissionGranted == permissionGranted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled, notificationResponse,
      overdueTasksCount, permissionGranted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationsStateCopyWith<_$_NotificationsState> get copyWith =>
      __$$_NotificationsStateCopyWithImpl<_$_NotificationsState>(
          this, _$identity);
}

abstract class _NotificationsState implements NotificationsState {
  const factory _NotificationsState(
      {required final bool enabled,
      final NotificationResponse? notificationResponse,
      required final int overdueTasksCount,
      required final bool permissionGranted}) = _$_NotificationsState;

  @override
  bool get enabled;
  @override
  NotificationResponse? get notificationResponse;
  @override

  /// The number of overdue tasks.
  ///
  /// Tracked so we don't update the icons if the number hasn't changed.
  int get overdueTasksCount;
  @override
  bool get permissionGranted;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationsStateCopyWith<_$_NotificationsState> get copyWith =>
      throw _privateConstructorUsedError;
}
