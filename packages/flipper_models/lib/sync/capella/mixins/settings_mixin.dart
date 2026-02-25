import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:flipper_web/services/ditto_service.dart';

mixin CapellaSettingsMixin {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService;

  Future<Setting?> getSetting({required String businessId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:19');
        return null;
      }

      ditto.sync.registerSubscription(
        "SELECT * FROM settings WHERE businessId = :businessId",
        arguments: {'businessId': businessId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM settings WHERE businessId = :businessId",
        arguments: {'businessId': businessId},
      );

      final result = await ditto.store.execute(
        "SELECT * FROM settings WHERE businessId = :businessId",
        arguments: {'businessId': businessId},
      );

      if (result.items.isNotEmpty) {
        return Setting.fromJson(
          Map<String, dynamic>.from(result.items.first.value),
        );
      }
      return null;
    } catch (e) {
      talker.error('Error in getSetting: $e');
      return null;
    }
  }

  Future<void> patchSettings({required Setting setting}) async {
    try {
      await repository.upsert<Setting>(setting);
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO settings DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
          arguments: {'doc': setting.toJson()},
        );
      }
    } catch (e) {
      talker.error('Error in patchSettings: $e');
      rethrow;
    }
  }
}
