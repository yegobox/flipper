import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:flipper_web/services/ditto_service.dart';

class PaymentSkipSettings {
  final String businessId;
  final int skipCount;
  final int maxSkipsAllowed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentSkipSettings({
    required this.businessId,
    required this.skipCount,
    required this.maxSkipsAllowed,
    this.createdAt,
    this.updatedAt,
  });
}

mixin CapellaSettingsMixin {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService;

  DateTime _settingLastTouched(Map<String, dynamic> data) {
    final value =
        data['lastTouched'] ??
        data['last_touched'] ??
        data['updatedAt'] ??
        data['updated_at'] ??
        data['createdAt'] ??
        data['created_at'];
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<Setting?> getSetting({required String businessId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:19');
        return null;
      }

      final preparedSettings = prepareDqlSyncSubscription(
        "SELECT * FROM settings WHERE businessId = :businessId",
        {'businessId': businessId},
      );
      ditto.sync.registerSubscription(
        preparedSettings.dql,
        arguments: preparedSettings.arguments,
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
        var latest = Map<String, dynamic>.from(result.items.first.value);
        for (final item in result.items.skip(1)) {
          final candidate = Map<String, dynamic>.from(item.value);
          if (_settingLastTouched(
            candidate,
          ).isAfter(_settingLastTouched(latest))) {
            latest = candidate;
          }
        }
        return Setting.fromJson(latest);
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

  Future<PaymentSkipSettings> getPaymentSkipSettings({
    required String businessId,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized in getPaymentSkipSettings');
        return PaymentSkipSettings(
          businessId: businessId,
          skipCount: 0,
          maxSkipsAllowed: 5,
        );
      }

      final result = await ditto.store.execute(
        'SELECT * FROM payment_skip_settings WHERE businessId = :businessId LIMIT 1',
        arguments: {'businessId': businessId},
      );

      if (result.items.isNotEmpty) {
        final data = Map<String, dynamic>.from(result.items.first.value);
        return PaymentSkipSettings(
          businessId: data['businessId'] ?? businessId,
          skipCount: (data['skipCount'] as num?)?.toInt() ?? 0,
          maxSkipsAllowed: (data['maxSkipsAllowed'] as num?)?.toInt() ?? 5,
          createdAt: data['createdAt'] != null
              ? DateTime.tryParse(data['createdAt'])
              : null,
          updatedAt: data['updatedAt'] != null
              ? DateTime.tryParse(data['updatedAt'])
              : null,
        );
      } else {
        // Create default settings for this business
        await ditto.store.execute(
          '''
          INSERT INTO payment_skip_settings DOCUMENTS (:doc)
          ''',
          arguments: {
            'doc': {
              '_id': 'skip_settings_$businessId',
              'businessId': businessId,
              'skipCount': 0,
              'maxSkipsAllowed': 5,
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            },
          },
        );
        return PaymentSkipSettings(
          businessId: businessId,
          skipCount: 0,
          maxSkipsAllowed: 5,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      talker.error('Error loading payment skip settings: $e');
      return PaymentSkipSettings(
        businessId: businessId,
        skipCount: 0,
        maxSkipsAllowed: 5,
      );
    }
  }

  Future<void> incrementPaymentSkipCount({required String businessId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized in incrementPaymentSkipCount');
        return;
      }

      // First, get the existing document
      final result = await ditto.store.execute(
        'SELECT * FROM payment_skip_settings WHERE businessId = :businessId LIMIT 1',
        arguments: {'businessId': businessId},
      );

      if (result.items.isNotEmpty) {
        final data = Map<String, dynamic>.from(result.items.first.value);
        final docId = data['_id'] as String;
        final currentSkipCount = (data['skipCount'] as num?)?.toInt() ?? 0;
        final maxSkipsAllowed = (data['maxSkipsAllowed'] as num?)?.toInt() ?? 5;

        // Update using INSERT ... ON ID CONFLICT DO UPDATE pattern
        await ditto.store.execute(
          '''
          INSERT INTO payment_skip_settings DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE
          ''',
          arguments: {
            'doc': {
              '_id': docId,
              'businessId': businessId,
              'skipCount': currentSkipCount + 1,
              'maxSkipsAllowed': maxSkipsAllowed,
              'createdAt': data['createdAt'],
              'updatedAt': DateTime.now().toIso8601String(),
            },
          },
        );
      } else {
        // If document doesn't exist, create it with skipCount = 1
        await ditto.store.execute(
          '''
          INSERT INTO payment_skip_settings DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE
          ''',
          arguments: {
            'doc': {
              '_id': 'skip_settings_$businessId',
              'businessId': businessId,
              'skipCount': 1,
              'maxSkipsAllowed': 5,
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            },
          },
        );
      }
    } catch (e) {
      talker.error('Error incrementing payment skip count: $e');
    }
  }

  Future<bool> canSkipPayment({required String businessId}) async {
    try {
      final settings = await getPaymentSkipSettings(businessId: businessId);
      return settings.skipCount < settings.maxSkipsAllowed;
    } catch (e) {
      talker.error('Error checking if payment can be skipped: $e');
      return false;
    }
  }

  Future<int> getRemainingSkips({required String businessId}) async {
    try {
      final settings = await getPaymentSkipSettings(businessId: businessId);
      return (settings.maxSkipsAllowed - settings.skipCount).clamp(0, 999);
    } catch (e) {
      talker.error('Error getting remaining skips: $e');
      return 0;
    }
  }
}
