import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.freezed.dart';
part 'setting.g.dart';

@freezed
class Setting with _$Setting {
  const factory Setting({
    int? id,

    // User related
    String? email,
    int? userId,
    int? businessId,
    String? businessPhoneNumber,
    String? token,
    String? deviceToken,

    // Printing and receipts
    @Default(false) bool? openReceiptFileOSaleComplete,
    @Default(false) bool? autoPrint,

    // Reporting
    @Default(false) bool? sendDailyReport,

    // Language
    String? defaultLanguage,

    // Attendance
    @Default(false) bool? attendnaceDocCreated,
    @Default(false) bool? isAttendanceEnabled,

    // Bot and auto-response
    String? type,
    @Default(false) bool? enrolledInBot,
    @Default(false) bool? autoRespond,

    // Security
    @Default(false) bool hasPin,

    // Timestamps
    String? createdAt,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  const Setting._(); // This is needed for custom getters
}

/// Extension methods for Setting helpers
extension SettingHelpers on Setting {
  /// Checks if the setting has complete business information
  bool get hasBusinessInfo => businessId != null && businessPhoneNumber != null;

  /// Checks if notifications are configured
  bool get hasNotificationsConfigured =>
      deviceToken != null && autoRespond != null;

  /// Checks if attendance features are enabled and setup
  bool get isAttendanceConfigured =>
      isAttendanceEnabled == true && attendnaceDocCreated == true;

  /// Checks if printing is configured
  bool get isPrintingConfigured =>
      autoPrint == true || openReceiptFileOSaleComplete == true;
}
