import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/locator.dart';
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

  @override
  bool? readBool({required String key}) => null;
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
/// branch, and leaves timers running. [load], when given, replaces [grants]
/// and runs on every read, for grants that change or are still loading.
List<Override> moduleGrantsOverrides({
  ServiceModeGrants grants = const ServiceModeGrants(),
  String userId = 'u-1',
  Future<ServiceModeGrants> Function()? load,
}) => [
  barServicesProvider.overrideWithValue(_GrantsServices(_GrantsBox(userId))),
  serviceModeGrantsProvider.overrideWith(
    (ref) => load == null ? Future.value(grants) : load(),
  ),
];

/// Signs [userId] in on the app's own box too, for code that reads it
/// directly (`currentDashboardUserId`), until the test ends. Leaves a box a
/// test registered itself alone.
void registerModuleGrantsBox({String userId = 'u-1'}) {
  if (getIt.isRegistered<LocalStorage>()) return;
  final box = _GrantsBox(userId);
  getIt.registerSingleton<LocalStorage>(box);
  addTearDown(() {
    if (getIt.isRegistered<LocalStorage>(instance: box)) {
      getIt.unregister<LocalStorage>(instance: box);
    }
  });
}
