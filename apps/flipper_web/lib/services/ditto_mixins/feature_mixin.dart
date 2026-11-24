import 'dart:async';
import 'package:flipper_models/helperModels/business_feature.dart';
import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin FeatureMixin on DittoCore {
  /// [dittoInstance], untyped: `Ditto` is a final class a unit test cannot
  /// stand in for, so tests override this with an in-memory store.
  dynamic get dittoHandle => dittoInstance;

  /// Get features for a business
  Future<BusinessFeature?> getBusinessFeatures({
    required String businessId,
  }) async {
    if (!isReady()) {
      debugPrint('Ditto not initialized');
      return null;
    }

    try {
      const String query =
          "SELECT * FROM business_features WHERE businessId = :businessId";
      final Map<String, dynamic> args = {'businessId': businessId};

      final result = await store!.execute(query, arguments: args);
      if (result.items.isNotEmpty) {
        return BusinessFeature.fromJson(
          Map<String, dynamic>.from(result.items.first.value),
        );
      }
    } catch (e, s) {
      debugPrint('Error fetching business features: $e\n$s');
    }
    return null;
  }

  /// Subscribe to business features
  Stream<BusinessFeature?> businessFeatureStream({required String businessId}) {
    final ditto = dittoHandle;
    if (ditto == null) {
      return Stream.value(null);
    }

    StreamController<BusinessFeature?> controller =
        StreamController<BusinessFeature?>();

    const String query =
        "SELECT * FROM business_features WHERE businessId = :businessId";
    final Map<String, dynamic> args = {'businessId': businessId};

    // Keep track of resources to cancel
    dynamic syncSubscription;
    dynamic observer;

    // Define cleanup logic
    controller.onCancel = () {
      try {
        syncSubscription?.cancel();
        observer?.cancel();
      } catch (e) {
        debugPrint("Error cancelling resources: $e");
      } finally {
        if (!controller.isClosed) {
          controller.close();
        }
      }
    };

    try {
      // 1. Register Subscription (to sync data)
      final preparedFeat = prepareDqlSyncSubscription(query, args);
      syncSubscription = ditto.sync.registerSubscription(
        preparedFeat.dql,
        arguments: preparedFeat.arguments,
      );

      // 2. Register Observer (to listen for local changes)
      observer = registerTrackedObserver(
        ditto: ditto,
        name: 'businessFeature',
        collection: 'business_features',
        query: query,
        arguments: args,
        onChange: (dynamic result) {
          if (result.items.isNotEmpty) {
            controller.add(
              BusinessFeature.fromJson(
                Map<String, dynamic>.from(result.items.first.value),
              ),
            );
          } else {
            controller.add(null);
          }
        },
      );
    } catch (e) {
      debugPrint("Error registering subscription or observer: $e");
      // Cleanup if setup fails
      syncSubscription?.cancel();
      observer?.cancel();
      controller.add(null);
      controller.close();
    }

    return controller.stream;
  }
}
