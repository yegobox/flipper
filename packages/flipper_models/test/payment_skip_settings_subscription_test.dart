import 'package:ditto_live/ditto_live.dart' show Ditto;
import 'package:flipper_models/sync/capella/mixins/settings_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

/// Exercises [CapellaSettingsMixin.getPaymentSkipSettings] against [FakeDitto].
class _SettingsSync with CapellaSettingsMixin {
  _SettingsSync(this.fake);

  final FakeDitto fake;

  @override
  dynamic get dittoHandle => fake;

  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  Repository get repository => throw UnimplementedError();

  @override
  final Talker talker = Talker();
}

class _OfflineDittoService implements DittoService {
  @override
  Ditto? get dittoInstance => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Uses the mixin's own [CapellaSettingsMixin.dittoHandle].
class _RealHandleSettingsSync with CapellaSettingsMixin {
  @override
  final DittoService dittoService = _OfflineDittoService();

  @override
  Repository get repository => throw UnimplementedError();

  @override
  final Talker talker = Talker();
}

// flutter test test/payment_skip_settings_subscription_test.dart
void main() {
  test(
    'reading the skip count keeps one subscription for the business',
    () async {
      final ditto = FakeDitto();
      final sync = _SettingsSync(ditto);

      // The paywall reads it on every visit, and again after each skip.
      final first = await sync.getPaymentSkipSettings(businessId: 'biz1');
      final again = await sync.getPaymentSkipSettings(businessId: 'biz1');

      expect(first.skipCount, 0);
      expect(again.maxSkipsAllowed, 5);
      expect(ditto.sync.registered, hasLength(1));
      expect(
        ditto.sync.registered.single.dql,
        'SELECT * FROM payment_skip_settings WHERE businessId = :businessId',
      );
      expect(ditto.sync.registered.single.arguments, {'businessId': 'biz1'});
    },
  );

  test('no Ditto: the defaults, and nothing registered', () async {
    final sync = _RealHandleSettingsSync();

    expect(sync.dittoHandle, isNull);
    final settings = await sync.getPaymentSkipSettings(businessId: 'biz1');
    expect(settings.skipCount, 0);
    expect(settings.maxSkipsAllowed, 5);
  });
}
