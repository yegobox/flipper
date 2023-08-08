import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'setting.g.dart';

@JsonSerializable()
@Collection()
class Setting extends IJsonSerializable {
  Setting({
    required this.id,
    required this.email,
    required this.hasPin,
    required this.userId,
    required this.type,
    this.autoPrint,
    this.openReceiptFileOSaleComplete,
    this.sendDailyReport,
    this.defaultLanguage,
    this.attendnaceDocCreated,
    this.isAttendanceEnabled,
    this.enrolledInBot,
    this.deviceToken,
    this.businessPhoneNumber,
    this.autoRespond,
    this.businessId,
    this.createdAt,
    this.token,
    this.deletedAt,
  });

  late String id;
  String? email;
  String? hasPin;
  @Index()
  int? userId;
  bool? openReceiptFileOSaleComplete;
  bool? autoPrint;
  bool? sendDailyReport;
  String? defaultLanguage;
  bool? attendnaceDocCreated;
  bool? isAttendanceEnabled;
  String? type;
  bool? enrolledInBot;
  String? deviceToken;
  String? businessPhoneNumber;
  bool? autoRespond;
  String? token;
  @Index()
  // @JsonKey(fromJson: _toInt)
  int? businessId;
  String? createdAt;
  @Index()
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  DateTime? deletedAt;
  factory Setting.fromRecord(RecordModel record) =>
      Setting.fromJson(record.toJson());

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
