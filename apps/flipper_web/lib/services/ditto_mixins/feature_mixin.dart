import 'dart:async';
import 'package:flipper_models/helperModels/business_feature.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin FeatureMixin on DittoCore {
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
    if (!isReady()) {
      return Stream.value(null);
    }

    const String query =
        "SELECT * FROM business_features WHERE businessId = :businessId";
    final Map<String, dynamic> args = {'businessId': businessId};

    // 1. Register Subscription (to sync data)
    try {
      dittoInstance!.sync.registerSubscription(query, arguments: args);
    } catch (e) {
      debugPrint("Error registering subscription: $e");
    }

    // 2. Register Observer (to listen for local changes)
    StreamController<BusinessFeature?> controller =
        StreamController<BusinessFeature?>();

    try {
      final observer = store!.registerObserver(
        query,
        arguments: args,
        onChange: (result) {
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

      controller.onCancel = () {
        observer.cancel();
      };
    } catch (e) {
      debugPrint("Error registering observer: $e");
      controller.add(null);
      controller.close();
    }

    return controller.stream;
  }
}
