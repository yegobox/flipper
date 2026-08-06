import 'package:flipper_models/countries_asset.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_provider.g.dart';

/// Countries for the origin pickers, ordered with the default first.
///
/// Falls back to the bundled CSV when the `countries` table has no rows (it is
/// remote-only, so a backend without that reference data leaves the dropdown
/// empty and unusable) or when the active strategy cannot serve it at all —
/// CapellaSync.countries() throws UnimplementedError, which is the web path.
@riverpod
Future<List<Country>> countries(Ref ref) async {
  try {
    final stored = await ProxyService.strategy.countries();
    if (stored.isNotEmpty) return countriesWithDefaultFirst(stored);
  } catch (e, s) {
    talker.warning('countries(): falling back to the bundled CSV', e, s);
  }
  return countriesWithDefaultFirst(await loadBundledCountries());
}
