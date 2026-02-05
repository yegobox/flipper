import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';
import 'package:flipper_services/notifications/notification_handler.dart';

part 'orders_provider.g.dart';

@riverpod
Stream<List<InventoryRequest>> stockRequests(
  Ref ref, {
  required String status,
  String? search,
}) {
  final branchId = ProxyService.box.getBranchId();

  if (branchId == null) {
    return const Stream.empty();
  }

  // Create a broadcast stream controller to handle notifications
  final controller = StreamController<List<InventoryRequest>>.broadcast();

  // Keep track of seen request IDs to avoid duplicate notifications
  final seenRequestIds = <String>{};

  // Listen to the Ditto stream
  final streamSubscription = ProxyService.getStrategy(Strategy.capella)
      .requestsStream(branchId: branchId, filter: status, search: search)
      .distinct(const ListEquality().equals)
      .listen(
    (requests) {
      // Check for new requests and trigger notifications
      for (final request in requests) {
        if (!seenRequestIds.contains(request.id)) {
          // This is a new request, trigger notification
          // Only notify for pending requests (new orders)
          if (status == 'pending' || request.status == 'pending') {
            // Use a microtask to ensure the notification is triggered after
            // the UI has had a chance to process the update
            Future.microtask(() {
              NotificationHandler().showOrderNotification(request);
            });
          }
          seenRequestIds.add(request.id);
        }
      }

      // Clean up seen IDs that are no longer in the current list
      seenRequestIds.removeWhere((id) => !requests.any((req) => req.id == id));

      controller.add(requests);
    },
    onError: (error) {
      controller.addError(error);
    },
  );

  // Cancel subscription when the controller is closed
  controller.onCancel = () {
    streamSubscription.cancel();
  };

  return controller.stream;
}

@riverpod
Stream<List<InventoryRequest>> outgoingStockRequests(
  Ref ref, {
  required String status,
  String? search,
}) async* {
  final branchId = ProxyService.box.getBranchId();

  if (branchId == null) {
    yield const [];
    return;
  }

  yield* ProxyService.getStrategy(Strategy.capella)
      .requestsStreamOutgoing(
        branchId: branchId,
        filter: status,
        search: search,
      )
      .distinct(const ListEquality().equals);
}
