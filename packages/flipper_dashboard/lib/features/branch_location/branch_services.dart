import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/constants.dart' as platform;
import 'package:flipper_services/place_search.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// What the branch screens (Add Branch, the location picker and the Android
/// location prompt) need from the app. Getters resolve on every call because
/// the active strategy can change at runtime; tests override
/// [branchServicesProvider] with a subclass.
class BranchServices {
  const BranchServices();

  /// One shared client so Nominatim's one-request-per-second spacing holds
  /// across every picker opened in the session.
  static final PlaceSearch _places = NominatimPlaceSearch();

  LocalStorage get box => ProxyService.box;
  DatabaseSyncInterface get strategy => ProxyService.strategy;
  FlipperLocation get location => ProxyService.location;
  HttpClientInterface get http => ProxyService.http;
  bool get isAndroid => platform.isAndroid;
  PlaceSearch get placeSearch => _places;

  /// The branch as Supabase has it, or null when offline or missing.
  Future<Branch?> remoteBranch(String branchId) async {
    try {
      final rows = await Repository().get<Branch>(
        query: Query(where: [Where('id').isExactly(branchId)]),
        policy: OfflineFirstGetPolicy.awaitRemote,
      );
      return rows.firstOrNull;
    } catch (_) {
      return null;
    }
  }
}

final branchServicesProvider = Provider<BranchServices>(
  (ref) => const BranchServices(),
);
