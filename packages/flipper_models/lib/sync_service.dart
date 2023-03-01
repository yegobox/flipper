import 'package:flipper_services/proxy.dart';
// import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stock/stock.dart' as remote;

class IsarSourceOfTruth<T> implements remote.SourceOfTruth<String, List<T>> {
  @override
  Stream<List<T>> reader(String key) async* {}

  @override
  Future<void> write(String key, List<T>? value) async {
    if (value is Product) {
      // save product on local
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
