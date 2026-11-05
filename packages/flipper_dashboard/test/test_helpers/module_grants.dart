import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _GrantsBox extends Fake implements LocalStorage {
  _GrantsBox(this.userId);

  final String userId;

  @override
  String? getUserId() => userId;

  @override
  String? getBusinessId() => 'biz-1';

  @override
  String? readString({required String key}) => null;
}

class _GrantsServices extends BarServices {
  const _GrantsServices(this._box);

  final LocalStorage _box;

  @override
  LocalStorage get box => _box;
}

/// Stubs who holds Bar, Hotel, Books and Flo in the business ([grants]; by
/// default nobody, so every module is open) for a widget test, with [userId]
/// signed in. Without it the real lookup reaches Supabase and the active
/// branch, and leaves timers running.
List<Override> moduleGrantsOverrides({
  ServiceModeGrants grants = const ServiceModeGrants(),
  String userId = 'u-1',
}) => [
  barServicesProvider.overrideWithValue(_GrantsServices(_GrantsBox(userId))),
  serviceModeGrantsProvider.overrideWith((ref) async => grants),
];
