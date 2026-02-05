import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';

part 'orders_provider.g.dart';

@riverpod
Stream<List<InventoryRequest>> stockRequests(
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
      .requestsStream(branchId: branchId, filter: status, search: search)
      .distinct(const ListEquality().equals);
}
