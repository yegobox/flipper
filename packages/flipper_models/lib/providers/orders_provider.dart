import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';
import 'package:flipper_services/notifications/notification_handler.dart';
import 'package:flipper_services/storage/seen_requests_storage.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/db_model_export.dart';

part 'orders_provider.g.dart';

@riverpod
class StockRequests extends _$StockRequests {
  int _limit = 50;
  String _status = RequestStatus.pending;
  String? _search;
  StreamSubscription<List<InventoryRequest>>? _subscription;
  StreamController<List<InventoryRequest>>? _controller;

  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) {
    _status = status;
    _search = search;

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Stream.empty();
    }

    _controller = StreamController<List<InventoryRequest>>.broadcast();

    _setupSubscription(branchId);

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
      _controller?.close();
    });

    return _controller!.stream;
  }

  Future<void> _setupSubscription(String branchId) async {
    await _subscription?.cancel();

    // Load previously seen request IDs
    Set<String> seenRequestIds = await SeenRequestsStorage.getSeenRequests();

    _subscription = ProxyService.getStrategy(Strategy.capella)
        .requestsStream(
          branchId: branchId,
          filter: _status,
          search: _search,
          limit: _limit,
        )
        .distinct(const ListEquality().equals)
        .listen(
          (requests) {
            if (_controller == null || _controller!.isClosed) return;

            // Notification logic
            for (final request in requests) {
              if (!seenRequestIds.contains(request.id)) {
                if (_status == 'pending' || request.status == 'pending') {
                  Future.microtask(() async {
                    await NotificationHandler().showOrderNotification(request);
                    await SeenRequestsStorage.markAsSeen(request.id);
                  });
                }
                seenRequestIds.add(request.id);
              }
            }
            _controller!.add(requests);
          },
          onError: (error) {
            if (_controller == null || _controller!.isClosed) return;
            _controller!.addError(error);
          },
        );
  }

  void loadMore() {
    _limit += 50;
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null) {
      _setupSubscription(branchId);
    }
  }
}

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.
@riverpod
class OutgoingStockRequests extends _$OutgoingStockRequests {
  int _limit = 50;
  String _status = RequestStatus.pending;
  String? _search;
  StreamSubscription<List<InventoryRequest>>? _subscription;
  StreamController<List<InventoryRequest>>? _controller;

  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) {
    _status = status;
    _search = search;

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return const Stream.empty();
    }

    _controller = StreamController<List<InventoryRequest>>.broadcast();
    _setupSubscription(branchId);

    ref.onDispose(() {
      _subscription?.cancel();
      _controller?.close();
    });

    return _controller!.stream;
  }

  Future<void> _setupSubscription(String branchId) async {
    await _subscription?.cancel();

    Set<String> seenRequestIds = await SeenRequestsStorage.getSeenRequests();

    _subscription = ProxyService.getStrategy(Strategy.capella)
        .requestsStreamOutgoing(
          branchId: branchId,
          filter: _status,
          search: _search,
          limit: _limit,
        )
        .distinct(const ListEquality().equals)
        .listen(
          (requests) {
            if (_controller == null || _controller!.isClosed) return;

            // Destination branch: notify when a transfer / order for us arrives.
            for (final request in requests) {
              if (!seenRequestIds.contains(request.id)) {
                final status = request.status ?? '';
                if (_status == RequestStatus.pending ||
                    status == RequestStatus.pending ||
                    status == RequestStatus.approved) {
                  Future.microtask(() async {
                    final from =
                        request.mainBranchId ?? request.branch?.name ?? 'branch';
                    await NotificationHandler().showStockTransferNotification(
                      requestId: request.id,
                      title: 'Stock received',
                      body:
                          'Incoming transfer from $from '
                          '(${request.itemCounts ?? request.transactionItems?.length ?? 0} items)',
                    );
                    await SeenRequestsStorage.markAsSeen(request.id);
                  });
                  seenRequestIds.add(request.id);
                }
              }
            }
            _controller!.add(requests);
          },
          onError: (error) {
            if (_controller == null || _controller!.isClosed) return;
            _controller!.addError(error);
          },
        );
  }
}
