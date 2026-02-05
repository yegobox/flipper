import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';
import 'package:flipper_services/notifications/notification_handler.dart';
import 'package:flipper_services/storage/seen_requests_storage.dart';

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

  // Initialize with an async task to load seen request IDs from persistent storage
  () async {
    // Load previously seen request IDs from persistent storage
    Set<String> seenRequestIds = await SeenRequestsStorage.getSeenRequests();

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
              Future.microtask(() async {
                await NotificationHandler().showOrderNotification(request);
                // Mark this request as seen to prevent duplicate notifications
                await SeenRequestsStorage.markAsSeen(request.id);
              });
            }
            seenRequestIds.add(request.id);
          }
        }

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
  }();

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
