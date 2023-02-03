import 'package:pocketbase/pocketbase.dart';

abstract class RemoteInterface<T> {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<void> create(Map<String, dynamic> newMemo,
      {required String collectionName});
  Future<void> update(Map<String, dynamic> updatedMemo,
      {required String collectionName});
}

class RemoteService<T> implements RemoteInterface {
  late PocketBase pb;
  Future<RemoteInterface> getInstance() async {
    pb = PocketBase('https://db.yegobox.com');
    await pb.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
    return this;
  }

  void putInSync() {
    pb
        .collection('orders')
        .subscribe("*", (e) {})
        .catchError((error, stackTrace) {});
  }

  @override
  Future<List<RecordModel>> getCollection({required String collectionName}) {
    return pb.collection(collectionName).getFullList();
  }

  @override
  Future<void> create(Map<String, dynamic> create,
      {required String collectionName}) async {
    pb
        .collection(collectionName)
        .create(body: create)
        .catchError((error, stackTrace) {});
  }

  @override
  Future<void> update(Map<String, dynamic> update,
      {required String collectionName}) {
    return pb
        .collection(collectionName)
        .update(update["id"], body: update)
        .catchError((error, stackTrace) {});
  }
}
