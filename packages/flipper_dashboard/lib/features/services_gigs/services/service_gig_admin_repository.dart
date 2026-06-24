import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceGigAdminRepository {
  static const _table = 'service_gig_admins';

  Future<bool> isEnabledAdmin({required String userId}) async {
    if (userId.isEmpty) return false;
    try {
      final row = await Supabase.instance.client
          .from(_table)
          .select('enabled')
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return false;
      final enabled = row['enabled'];
      return enabled == true;
    } catch (_) {
      return false;
    }
  }
}

