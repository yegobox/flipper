import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class Conversation extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  String? userName;
  String? body;
  String? avatar;
  String? channelType;
  String? fromNumber;
  String? toNumber;
  String? createdAt;
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
    required this.id,
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
  });
}
