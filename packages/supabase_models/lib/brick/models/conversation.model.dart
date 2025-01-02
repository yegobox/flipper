import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'conversations'),
)
class Conversation extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? userName;
  String? body;
  String? avatar;
  String? channelType;
  String? fromNumber;
  String? toNumber;
  DateTime? createdAt;
  String? messageType;
  String? phoneNumberId;
  String? messageId;
  String? respondedBy;
  String? conversationId;
  String? businessPhoneNumber;
  int? businessId;
  DateTime? scheduledAt;
  bool? delivered;
  DateTime? lastTouched;
  DateTime? deletedAt;

  Conversation({
    String? id,
    this.userName,
    this.body,
    this.avatar,
    this.channelType,
    this.fromNumber,
    this.toNumber,
    this.createdAt,
    this.messageType,
    this.phoneNumberId,
    this.messageId,
    this.respondedBy,
    this.conversationId,
    this.businessPhoneNumber,
    this.businessId,
    this.scheduledAt,
    this.delivered,
    this.lastTouched,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4();
}
