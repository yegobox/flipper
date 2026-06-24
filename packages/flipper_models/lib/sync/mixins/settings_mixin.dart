import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_core/query.dart' as brick;

mixin SettingsMixin {
  Repository get repository;
  Talker get talker;

  Future<Setting?> getSetting({required String businessId}) async {
    try {
      final settings = await repository.get<Setting>(
        query: brick.Query(
          where: [brick.Where('businessId').isExactly(businessId)],
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
      return settings.firstOrNull;
    } catch (e) {
      talker.error('Error in getSetting: $e');
      return null;
    }
  }

  Future<void> patchSettings({required Setting setting}) async {
    try {
      await repository.upsert<Setting>(setting);
    } catch (e) {
      talker.error('Error in patchSettings: $e');
      rethrow;
    }
  }
}
