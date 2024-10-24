// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return _Setting.fromJson(json);
}

/// @nodoc
mixin _$Setting {
  int? get id => throw _privateConstructorUsedError; // User related
  String? get email => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  int? get businessId => throw _privateConstructorUsedError;
  String? get businessPhoneNumber => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get deviceToken =>
      throw _privateConstructorUsedError; // Printing and receipts
  bool? get openReceiptFileOSaleComplete => throw _privateConstructorUsedError;
  bool? get autoPrint => throw _privateConstructorUsedError; // Reporting
  bool? get sendDailyReport => throw _privateConstructorUsedError; // Language
  String? get defaultLanguage =>
      throw _privateConstructorUsedError; // Attendance
  bool? get attendnaceDocCreated => throw _privateConstructorUsedError;
  bool? get isAttendanceEnabled =>
      throw _privateConstructorUsedError; // Bot and auto-response
  String? get type => throw _privateConstructorUsedError;
  bool? get enrolledInBot => throw _privateConstructorUsedError;
  bool? get autoRespond => throw _privateConstructorUsedError; // Security
  bool get hasPin => throw _privateConstructorUsedError; // Timestamps
  String? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Setting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingCopyWith<Setting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingCopyWith<$Res> {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) then) =
      _$SettingCopyWithImpl<$Res, Setting>;
  @useResult
  $Res call(
      {int? id,
      String? email,
      int? userId,
      int? businessId,
      String? businessPhoneNumber,
      String? token,
      String? deviceToken,
      bool? openReceiptFileOSaleComplete,
      bool? autoPrint,
      bool? sendDailyReport,
      String? defaultLanguage,
      bool? attendnaceDocCreated,
      bool? isAttendanceEnabled,
      String? type,
      bool? enrolledInBot,
      bool? autoRespond,
      bool hasPin,
      String? createdAt,
      DateTime? lastTouched,
      DateTime? deletedAt});
}

/// @nodoc
class _$SettingCopyWithImpl<$Res, $Val extends Setting>
    implements $SettingCopyWith<$Res> {
  _$SettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? userId = freezed,
    Object? businessId = freezed,
    Object? businessPhoneNumber = freezed,
    Object? token = freezed,
    Object? deviceToken = freezed,
    Object? openReceiptFileOSaleComplete = freezed,
    Object? autoPrint = freezed,
    Object? sendDailyReport = freezed,
    Object? defaultLanguage = freezed,
    Object? attendnaceDocCreated = freezed,
    Object? isAttendanceEnabled = freezed,
    Object? type = freezed,
    Object? enrolledInBot = freezed,
    Object? autoRespond = freezed,
    Object? hasPin = null,
    Object? createdAt = freezed,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessPhoneNumber: freezed == businessPhoneNumber
          ? _value.businessPhoneNumber
          : businessPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceToken: freezed == deviceToken
          ? _value.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as String?,
      openReceiptFileOSaleComplete: freezed == openReceiptFileOSaleComplete
          ? _value.openReceiptFileOSaleComplete
          : openReceiptFileOSaleComplete // ignore: cast_nullable_to_non_nullable
              as bool?,
      autoPrint: freezed == autoPrint
          ? _value.autoPrint
          : autoPrint // ignore: cast_nullable_to_non_nullable
              as bool?,
      sendDailyReport: freezed == sendDailyReport
          ? _value.sendDailyReport
          : sendDailyReport // ignore: cast_nullable_to_non_nullable
              as bool?,
      defaultLanguage: freezed == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      attendnaceDocCreated: freezed == attendnaceDocCreated
          ? _value.attendnaceDocCreated
          : attendnaceDocCreated // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAttendanceEnabled: freezed == isAttendanceEnabled
          ? _value.isAttendanceEnabled
          : isAttendanceEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      enrolledInBot: freezed == enrolledInBot
          ? _value.enrolledInBot
          : enrolledInBot // ignore: cast_nullable_to_non_nullable
              as bool?,
      autoRespond: freezed == autoRespond
          ? _value.autoRespond
          : autoRespond // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasPin: null == hasPin
          ? _value.hasPin
          : hasPin // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$SettingImplCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$$SettingImplCopyWith(
          _$SettingImpl value, $Res Function(_$SettingImpl) then) =
      __$$SettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? email,
      int? userId,
      int? businessId,
      String? businessPhoneNumber,
      String? token,
      String? deviceToken,
      bool? openReceiptFileOSaleComplete,
      bool? autoPrint,
      bool? sendDailyReport,
      String? defaultLanguage,
      bool? attendnaceDocCreated,
      bool? isAttendanceEnabled,
      String? type,
      bool? enrolledInBot,
      bool? autoRespond,
      bool hasPin,
      String? createdAt,
      DateTime? lastTouched,
      DateTime? deletedAt});
}

/// @nodoc
class __$$SettingImplCopyWithImpl<$Res>
    extends _$SettingCopyWithImpl<$Res, _$SettingImpl>
    implements _$$SettingImplCopyWith<$Res> {
  __$$SettingImplCopyWithImpl(
      _$SettingImpl _value, $Res Function(_$SettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? userId = freezed,
    Object? businessId = freezed,
    Object? businessPhoneNumber = freezed,
    Object? token = freezed,
    Object? deviceToken = freezed,
    Object? openReceiptFileOSaleComplete = freezed,
    Object? autoPrint = freezed,
    Object? sendDailyReport = freezed,
    Object? defaultLanguage = freezed,
    Object? attendnaceDocCreated = freezed,
    Object? isAttendanceEnabled = freezed,
    Object? type = freezed,
    Object? enrolledInBot = freezed,
    Object? autoRespond = freezed,
    Object? hasPin = null,
    Object? createdAt = freezed,
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$SettingImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessId: freezed == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int?,
      businessPhoneNumber: freezed == businessPhoneNumber
          ? _value.businessPhoneNumber
          : businessPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceToken: freezed == deviceToken
          ? _value.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as String?,
      openReceiptFileOSaleComplete: freezed == openReceiptFileOSaleComplete
          ? _value.openReceiptFileOSaleComplete
          : openReceiptFileOSaleComplete // ignore: cast_nullable_to_non_nullable
              as bool?,
      autoPrint: freezed == autoPrint
          ? _value.autoPrint
          : autoPrint // ignore: cast_nullable_to_non_nullable
              as bool?,
      sendDailyReport: freezed == sendDailyReport
          ? _value.sendDailyReport
          : sendDailyReport // ignore: cast_nullable_to_non_nullable
              as bool?,
      defaultLanguage: freezed == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      attendnaceDocCreated: freezed == attendnaceDocCreated
          ? _value.attendnaceDocCreated
          : attendnaceDocCreated // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAttendanceEnabled: freezed == isAttendanceEnabled
          ? _value.isAttendanceEnabled
          : isAttendanceEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      enrolledInBot: freezed == enrolledInBot
          ? _value.enrolledInBot
          : enrolledInBot // ignore: cast_nullable_to_non_nullable
              as bool?,
      autoRespond: freezed == autoRespond
          ? _value.autoRespond
          : autoRespond // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasPin: null == hasPin
          ? _value.hasPin
          : hasPin // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$SettingImpl extends _Setting {
  const _$SettingImpl(
      {this.id,
      this.email,
      this.userId,
      this.businessId,
      this.businessPhoneNumber,
      this.token,
      this.deviceToken,
      this.openReceiptFileOSaleComplete = false,
      this.autoPrint = false,
      this.sendDailyReport = false,
      this.defaultLanguage,
      this.attendnaceDocCreated = false,
      this.isAttendanceEnabled = false,
      this.type,
      this.enrolledInBot = false,
      this.autoRespond = false,
      this.hasPin = false,
      this.createdAt,
      this.lastTouched,
      this.deletedAt})
      : super._();

  factory _$SettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingImplFromJson(json);

  @override
  final int? id;
// User related
  @override
  final String? email;
  @override
  final int? userId;
  @override
  final int? businessId;
  @override
  final String? businessPhoneNumber;
  @override
  final String? token;
  @override
  final String? deviceToken;
// Printing and receipts
  @override
  @JsonKey()
  final bool? openReceiptFileOSaleComplete;
  @override
  @JsonKey()
  final bool? autoPrint;
// Reporting
  @override
  @JsonKey()
  final bool? sendDailyReport;
// Language
  @override
  final String? defaultLanguage;
// Attendance
  @override
  @JsonKey()
  final bool? attendnaceDocCreated;
  @override
  @JsonKey()
  final bool? isAttendanceEnabled;
// Bot and auto-response
  @override
  final String? type;
  @override
  @JsonKey()
  final bool? enrolledInBot;
  @override
  @JsonKey()
  final bool? autoRespond;
// Security
  @override
  @JsonKey()
  final bool hasPin;
// Timestamps
  @override
  final String? createdAt;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'Setting(id: $id, email: $email, userId: $userId, businessId: $businessId, businessPhoneNumber: $businessPhoneNumber, token: $token, deviceToken: $deviceToken, openReceiptFileOSaleComplete: $openReceiptFileOSaleComplete, autoPrint: $autoPrint, sendDailyReport: $sendDailyReport, defaultLanguage: $defaultLanguage, attendnaceDocCreated: $attendnaceDocCreated, isAttendanceEnabled: $isAttendanceEnabled, type: $type, enrolledInBot: $enrolledInBot, autoRespond: $autoRespond, hasPin: $hasPin, createdAt: $createdAt, lastTouched: $lastTouched, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.businessPhoneNumber, businessPhoneNumber) ||
                other.businessPhoneNumber == businessPhoneNumber) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.deviceToken, deviceToken) ||
                other.deviceToken == deviceToken) &&
            (identical(other.openReceiptFileOSaleComplete,
                    openReceiptFileOSaleComplete) ||
                other.openReceiptFileOSaleComplete ==
                    openReceiptFileOSaleComplete) &&
            (identical(other.autoPrint, autoPrint) ||
                other.autoPrint == autoPrint) &&
            (identical(other.sendDailyReport, sendDailyReport) ||
                other.sendDailyReport == sendDailyReport) &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            (identical(other.attendnaceDocCreated, attendnaceDocCreated) ||
                other.attendnaceDocCreated == attendnaceDocCreated) &&
            (identical(other.isAttendanceEnabled, isAttendanceEnabled) ||
                other.isAttendanceEnabled == isAttendanceEnabled) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enrolledInBot, enrolledInBot) ||
                other.enrolledInBot == enrolledInBot) &&
            (identical(other.autoRespond, autoRespond) ||
                other.autoRespond == autoRespond) &&
            (identical(other.hasPin, hasPin) || other.hasPin == hasPin) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        email,
        userId,
        businessId,
        businessPhoneNumber,
        token,
        deviceToken,
        openReceiptFileOSaleComplete,
        autoPrint,
        sendDailyReport,
        defaultLanguage,
        attendnaceDocCreated,
        isAttendanceEnabled,
        type,
        enrolledInBot,
        autoRespond,
        hasPin,
        createdAt,
        lastTouched,
        deletedAt
      ]);

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingImplCopyWith<_$SettingImpl> get copyWith =>
      __$$SettingImplCopyWithImpl<_$SettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingImplToJson(
      this,
    );
  }
}

abstract class _Setting extends Setting {
  const factory _Setting(
      {final int? id,
      final String? email,
      final int? userId,
      final int? businessId,
      final String? businessPhoneNumber,
      final String? token,
      final String? deviceToken,
      final bool? openReceiptFileOSaleComplete,
      final bool? autoPrint,
      final bool? sendDailyReport,
      final String? defaultLanguage,
      final bool? attendnaceDocCreated,
      final bool? isAttendanceEnabled,
      final String? type,
      final bool? enrolledInBot,
      final bool? autoRespond,
      final bool hasPin,
      final String? createdAt,
      final DateTime? lastTouched,
      final DateTime? deletedAt}) = _$SettingImpl;
  const _Setting._() : super._();

  factory _Setting.fromJson(Map<String, dynamic> json) = _$SettingImpl.fromJson;

  @override
  int? get id; // User related
  @override
  String? get email;
  @override
  int? get userId;
  @override
  int? get businessId;
  @override
  String? get businessPhoneNumber;
  @override
  String? get token;
  @override
  String? get deviceToken; // Printing and receipts
  @override
  bool? get openReceiptFileOSaleComplete;
  @override
  bool? get autoPrint; // Reporting
  @override
  bool? get sendDailyReport; // Language
  @override
  String? get defaultLanguage; // Attendance
  @override
  bool? get attendnaceDocCreated;
  @override
  bool? get isAttendanceEnabled; // Bot and auto-response
  @override
  String? get type;
  @override
  bool? get enrolledInBot;
  @override
  bool? get autoRespond; // Security
  @override
  bool get hasPin; // Timestamps
  @override
  String? get createdAt;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingImplCopyWith<_$SettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
