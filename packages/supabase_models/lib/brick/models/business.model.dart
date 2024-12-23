import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'businesses'),
)
class Business extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

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
    required this.id,
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
  });

  Business copyWith({
    int? id,
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
}
