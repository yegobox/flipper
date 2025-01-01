import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'businesses'),
)
class Business extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  int serverId;

  String? name;
  String? currency;
  String? categoryId;
  String? latitude;
  String? longitude;
  int? userId;
  String? timeZone;
  // List<String>? channels;
  String? country;
  String? businessUrl;
  String? hexColor;
  String? imageUrl;
  String? type;
  bool? active;
  String? chatUid;
  String? metadata;
  String? role;
  int? lastSeen;
  String? firstName;
  String? lastName;
  String? createdAt;
  String? deviceToken;
  bool? backUpEnabled;
  String? subscriptionPlan;
  String? nextBillingDate;
  String? previousBillingDate;
  bool? isLastSubscriptionPaymentSucceeded;
  String? backupFileId;
  String? email;
  String? lastDbBackup;
  String? fullName;
  int? tinNumber;
  String? bhfId;
  String? dvcSrlNo;
  // address
  String? adrs;
  bool? taxEnabled;
  String? taxServerUrl;
  bool? isDefault;
  int? businessTypeId;

  DateTime? lastTouched;

  DateTime? deletedAt;

  String? encryptionKey;

  Business({
    String? id,
    this.name,
    required this.serverId,
    this.currency,
    this.categoryId,
    this.latitude,
    this.longitude,
    this.userId,
    this.timeZone,
    this.country,
    this.businessUrl,
    this.hexColor,
    this.imageUrl,
    this.type,
    this.active,
    this.chatUid,
    this.metadata,
    this.role,
    this.lastSeen,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.deviceToken,
    this.backUpEnabled,
    this.subscriptionPlan,
    this.nextBillingDate,
    this.previousBillingDate,
    this.isLastSubscriptionPaymentSucceeded,
    this.backupFileId,
    this.email,
    this.lastDbBackup,
    this.fullName,
    this.tinNumber,
    this.bhfId,
    this.dvcSrlNo,
    this.adrs,
    this.taxEnabled,
    this.taxServerUrl,
    this.isDefault,
    this.businessTypeId,
    this.lastTouched,
    this.deletedAt,
    this.encryptionKey,
  }) : id = id ?? const Uuid().v4();

  Business copyWith({
    String? id,
    String? name,
    int? serverId,
    String? currency,
    String? categoryId,
    String? latitude,
    String? longitude,
    int? userId,
    String? timeZone,
    String? country,
    String? businessUrl,
    String? hexColor,
    String? imageUrl,
    String? type,
    bool? active,
    String? chatUid,
    String? metadata,
    String? role,
    int? lastSeen,
    String? firstName,
    String? lastName,
    String? createdAt,
    String? deviceToken,
    bool? backUpEnabled,
    String? subscriptionPlan,
    String? nextBillingDate,
    String? previousBillingDate,
    bool? isLastSubscriptionPaymentSucceeded,
    String? backupFileId,
    String? email,
    String? lastDbBackup,
    String? fullName,
    int? tinNumber,
    String? bhfId,
    String? dvcSrlNo,
    String? adrs,
    bool? taxEnabled,
    String? taxServerUrl,
    bool? isDefault,
    int? businessTypeId,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? encryptionKey,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      userId: userId ?? this.userId,
      timeZone: timeZone ?? this.timeZone,
      country: country ?? this.country,
      businessUrl: businessUrl ?? this.businessUrl,
      hexColor: hexColor ?? this.hexColor,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      active: active ?? this.active,
      chatUid: chatUid ?? this.chatUid,
      metadata: metadata ?? this.metadata,
      role: role ?? this.role,
      lastSeen: lastSeen ?? this.lastSeen,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      deviceToken: deviceToken ?? this.deviceToken,
      backUpEnabled: backUpEnabled ?? this.backUpEnabled,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      previousBillingDate: previousBillingDate ?? this.previousBillingDate,
      isLastSubscriptionPaymentSucceeded: isLastSubscriptionPaymentSucceeded ??
          this.isLastSubscriptionPaymentSucceeded,
      backupFileId: backupFileId ?? this.backupFileId,
    );
  }

  // fromMap method
  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'] as String,
      serverId: map['server_id'] as int,
      name: map['name'] as String?,
      currency: map['currency'] as String?,
      categoryId: map['category_id'] as String?,
      latitude: map['latitude'] as String?,
      longitude: map['longitude'] as String?,
      userId: map['user_id'] as int,
      timeZone: map['time_zone'] as String?,
      country: map['country'] as String?,
      businessUrl: map['business_url'] as String?,
      hexColor: map['hex_color'] as String?,
      imageUrl: map['image_url'] as String?,
      type: map['type'] as String?,
      // active: map['active'] as bool,
      chatUid: map['chat_uid'] as String?,
      metadata: map['metadata'] as String?,
      role: map['role'] as String?,
      lastSeen: map['last_seen'] as int?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      createdAt: map['created_at'] as String?,
      deviceToken: map['deviceToken'] as String?,
      // backUpEnabled: map['back_up_enabled'] as bool?,
      subscriptionPlan: map['subscription_plan'] as String?,
      nextBillingDate: map['next_billing_date'] as String?,
      previousBillingDate: map['previous_billing_date'] as String?,
      // isLastSubscriptionPaymentSucceeded:
      //     map['is_last_subscription_payment_succeeded'] as bool?,
      backupFileId: map['backup_file_id'] as String?,
      email: map['email'] as String?,
      lastDbBackup: map['last_db_backup'] as String?,
      fullName: map['full_name'] as String?,
      tinNumber: map['tin_number'] as int?,
      bhfId: map['bhf_id'] as String?,
      dvcSrlNo: map['dvc_srl_no'] as String?,
      adrs: map['adrs'] as String?,
      // taxEnabled: map['tax_enabled'] as bool?,
      taxServerUrl: map['tax_server_url'] as String?,
      // isDefault: map['is_default'] as bool?,
      businessTypeId: map['business_type_id'] as int?,
      lastTouched: map['last_touched'] == null
          ? null
          : DateTime.tryParse(map['last_touched'] as String),
      deletedAt: map['deleted_at'] == null
          ? null
          : DateTime.tryParse(map['deleted_at'] as String),
      encryptionKey: map['encryption_key'] as String?,
    );
  }
}
