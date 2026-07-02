import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

// part 'device.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'devices'),
)
// Ditto sync disabled for devices — delegation uses cloudSync (Supabase).
class Device extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? linkingCode;
  String? deviceName;
  /// User-chosen label shown in delegation pickers (e.g. "Front counter printer").
  String? friendlyName;
  String? deviceVersion;
  bool? pubNubPublished;
  String? phone;
  String? branchId;
  String? businessId;
  String? userId;
  String? defaultApp;

  /// for sync
  DateTime? deletedAt;

  Device({
    String? id,
    this.linkingCode,
    this.deviceName,
    this.friendlyName,
    this.deviceVersion,
    this.pubNubPublished,
    this.phone,
    this.branchId,
    this.businessId,
    this.userId,
    this.defaultApp,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4();

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String?,
      linkingCode: json['linkingCode'] as String?,
      deviceName: json['deviceName'] as String?,
      friendlyName: json['friendlyName'] as String?,
      deviceVersion: json['deviceVersion'] as String?,
      pubNubPublished: json['pubNubPublished'] as bool?,
      phone: json['phone'] as String?,
      branchId: json['branchId'] as String?,
      businessId: json['businessId'] as String?,
      userId: json['userId'] as String?,
      defaultApp: json['defaultApp'] as String?,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'].toString())
          : null,
    );
  }
}

/// Label for delegation pickers: custom name when set, else OS/platform name.
extension DeviceDisplayLabel on Device {
  String get displayLabel {
    final custom = friendlyName?.trim();
    if (custom != null && custom.isNotEmpty) return custom;
    return deviceName ?? 'Unknown Device';
  }
}
