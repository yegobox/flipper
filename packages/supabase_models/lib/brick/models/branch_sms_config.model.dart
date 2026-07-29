import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

/// WhatsApp delivery backend stored on [BranchSmsConfig.whatsappProvider].
/// Matches data-connector `provider`: 1 = openwa, 2 = meta.
abstract final class WhatsAppChannel {
  static const int openwa = 1;
  static const int meta = 2;

  /// API string for data-connector (`openwa` | `meta`).
  static String toApiProvider(int? code) {
    if (code == meta) return 'meta';
    return 'openwa';
  }

  static bool isMeta(int? code) => code == meta;
}

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'branch_sms_configs'),
)
class BranchSmsConfig extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String branchId;
  String? smsPhoneNumber;
  bool enableSms;
  bool enableWhatsapp;

  /// `1` = OpenWA, `2` = Meta Cloud API (see [WhatsAppChannel]).
  int whatsappProvider;

  BranchSmsConfig({
    String? id,
    required this.branchId,
    this.smsPhoneNumber,
    this.enableSms = false,
    this.enableWhatsapp = false,
    this.whatsappProvider = WhatsAppChannel.openwa,
  }) : id = id ?? const Uuid().v4();

  bool get hasAnyChannelEnabled => enableSms || enableWhatsapp;
}
