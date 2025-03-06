import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';

class MockStrategy implements Strategy {
  bool hasActiveSubscriptionResponse = true;
  final Map<Type, List<dynamic>> _store = {};
  
  @override
  Future<bool> hasActiveSubscription({
    required int businessId,
    required HttpClientInterface flipperHttpClient,
  }) async {
    // Check if we have any active subscriptions for this business
    final subscriptions = _store[Subscription] as List<Subscription>? ?? [];
    return subscriptions.any((s) => 
      s.businessId == businessId && 
      s.active == true && 
      s.validUntil.isAfter(DateTime.now()));
  }

  @override
  Future<List<Business>> businesses({required int userId}) async {
    return _store[Business] as List<Business>? ?? [];
  }

  @override
  Future<List<Branch>> branches({required int businessId}) async {
    final branches = _store[Branch] as List<Branch>? ?? [];
    return branches.where((b) => b.businessId == businessId).toList();
  }

  @override
  Future<T> create<T>({required T data}) async {
    if (!_store.containsKey(T)) {
      _store[T] = <T>[];
    }
    (_store[T] as List<T>).add(data);
    return data;
  }

  // Add other required methods with mock implementations
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
