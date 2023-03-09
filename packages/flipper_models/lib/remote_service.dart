import 'package:pocketbase/pocketbase.dart';

abstract class RemoteInterface<T> {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<RecordModel> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<T> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName});
  void listenToChanges();
}

class RemoteService<T> implements RemoteInterface {
  late PocketBase pb;
  Future<RemoteInterface> getInstance() async {
    try {
      pb = PocketBase('https://db.yegobox.com');
      await pb.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
    } catch (e) {}
    return this;
  }

  // void putInSync() {
  //   pb
  //       .collection('orders')
  //       .subscribe("*", (e) {})
  //       .catchError((error, stackTrace) {
  //     log(error);
  //     log(stackTrace);
  //   });
  // }

  @override
  Future<List<RecordModel>> getCollection({required String collectionName}) {
    return pb.collection(collectionName).getFullList();
  }

  @override
  Future<RecordModel> create({
    required Map<String, dynamic> collection,
    required String collectionName,
  }) async {
    try {
      return await pb.collection(collectionName).create(body: collection);
    } catch (e) {
      // You can add custom handling here if you want to do something with the error
      rethrow;
    }
  }

  @override
  Future<void> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName}) {
    return pb
        .collection(collectionName)
        .update(updateCollection["id"], body: updateCollection)
        .then((record) {
      print(record.id);
      print(record.getStringValue('id'));
    });
  }

  @override
  void listenToChanges() {
    pb.collection('products').subscribe("*", (e) {
      if (e.action == "create") {
        /// create a product
      }
    });
  }
}
