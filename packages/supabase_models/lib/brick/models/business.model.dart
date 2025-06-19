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
  DateTime? createdAt;
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
    DateTime? createdAt,
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
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

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
      tinNumber: tinNumber,
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
      serverId: map['serverId'] as int, // Changed from server_id
      name: map['name'] as String?,
      currency: map['currency'] as String?,
      categoryId: map['categoryId'] as String?, // Changed from category_id
      latitude: map['latitude'] as String?,
      longitude: map['longitude'] as String?,
      userId: map['userId'] is String
          ? int.parse(map['userId'])
          : map['userId'] as int, // Handle string conversion
      timeZone: map['timeZone'] as String?, // Changed from time_zone
      country: map['country'] as String?,
      businessUrl: map['businessUrl'] as String?, // Changed from business_url
      hexColor: map['hexColor'] as String?, // Changed from hex_color
      imageUrl: map['imageUrl'] as String?, // Changed from image_url
      type: map['type'] as String?,
      chatUid: map['chatUid'] as String?, // Changed from chat_uid
      metadata: map['metadata'] as String?,
      role: map['role'] as String?,
      lastSeen: map['lastSeen'] as int?, // Changed from last_seen
      firstName: map['firstName'] as String?, // Changed from first_name
      lastName: map['lastName'] as String?, // Changed from last_name
      deviceToken: map['deviceToken'] as String?,
      subscriptionPlan:
          map['subscriptionPlan'] as String?, // Changed from subscription_plan
      nextBillingDate:
          map['nextBillingDate'] as String?, // Changed from next_billing_date
      previousBillingDate: map['previousBillingDate']
          as String?, // Changed from previous_billing_date
      backupFileId:
          map['backupFileId'] as String?, // Changed from backup_file_id
      email: map['email'] as String?,
      lastDbBackup:
          map['lastDbBackup'] as String?, // Changed from last_db_backup
      fullName: map['fullName'] as String?, // Changed from full_name
      tinNumber: map['tinNumber'] as int?, // Changed from tin_number
      bhfId: map['bhfId'] as String?, // Changed from bhf_id
      dvcSrlNo: map['dvcSrlNo'] as String?, // Changed from dvc_srl_no
      adrs: map['adrs'] as String?,
      taxServerUrl:
          map['taxServerUrl'] as String?, // Changed from tax_server_url
      businessTypeId:
          map['businessTypeId'] as int?, // Changed from business_type_id
      lastTouched: map['lastTouched'] == null
          ? null
          : DateTime.tryParse(map['lastTouched'].toString()),
      deletedAt: map['deletedAt'] == null
          ? null
          : DateTime.tryParse(map['deletedAt'].toString()),
      encryptionKey:
          map['encryptionKey'] as String?, // Changed from encryption_key
    );
  }
}
