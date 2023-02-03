import 'dart:collection';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
// import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stock/stock.dart' as remote;

class IsarSourceOfTruth implements remote.SourceOfTruth<String, List<Order>> {
  @override
  Stream<List<Order>> reader(String key) async* {
    yield* ProxyService.isarApi.completedOrdersStreams(
        branchId: ProxyService.box.getBranchId()!, status: completeStatus);
  }

  @override
  Future<void> write(String key, List<Order>? memos) async {
    try {
      List<Order> localMemos = await ProxyService.isarApi.completedOrders(
          branchId: ProxyService.box.getBranchId()!, status: completeStatus);
      HashSet<Order> localMemosSet = HashSet<Order>.from(localMemos);
      HashSet<Order> remoteMemosSet = HashSet<Order>.from(memos!);
      Set<Order> difference = localMemosSet.difference(remoteMemosSet);
      if (difference.isNotEmpty) {
        difference.forEach((Order order) async {
          if (localMemosSet.contains(order)) {
            await ProxyService.remoteApi
                .create(order.toJson(), collectionName: 'orders');
          }
        });
      }
      memos = memos.map((Order memo) {
        var existingOrder = localMemos.firstWhere((e) => e.id == memo.id,
            orElse: () => Order()..customerChangeDue = 300);
        if (existingOrder.id != 0) {
          if (DateTime.parse(existingOrder.createdAt).millisecondsSinceEpoch >
              DateTime.parse(existingOrder.createdAt).millisecondsSinceEpoch) {
            ProxyService.remoteApi
                .update(existingOrder.toJson(), collectionName: 'orders');
            return existingOrder;
          }
        }
        return memo;
      }).toList();
      //  await ProxyService.isarApi.update<Order>(data: memos);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}

final pocketBaseFetcher =
    remote.Fetcher.ofFuture<String, List<Order>>((key) async {
  try {
    final memos =
        await ProxyService.remoteApi.getCollection(collectionName: 'orders');
    // final memosJson = memos.map((RecordModel memo) {
    //   return Order.fromRecord(memo);
    // }).toList();
    // return memosJson;
    return [];
  } catch (e) {
    return [];
  }
});

final stock = remote.Stock(
    fetcher: pocketBaseFetcher, sourceOfTruth: IsarSourceOfTruth());
