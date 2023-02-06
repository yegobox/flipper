// abstract class RemoteInterface<T> {
//   Future<List<RecordModel>> getCollection({required String collectionName});
//   Future<void> create(
//       {required Map<String, dynamic> collection,
//       required String collectionName});
//   Future<void> update(
//       {required Map<String, dynamic> updateCollection,
//       required String collectionName});
// }

abstract class RemoteInterface<T> {
  Future<List<dynamic>> getCollection({required String collectionName});
  Future<void> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<void> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName});
}

class RemoteService<T> implements RemoteInterface {
  @override
  Future<void> create(
      {required Map<String, dynamic> collection,
      required String collectionName}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<List> getCollection({required String collectionName}) {
    // TODO: implement getCollection
    throw UnimplementedError();
  }

  @override
  Future<void> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName}) {
    // TODO: implement update
    throw UnimplementedError();
  }
  // late PocketBase pb;
  // Future<RemoteInterface> getInstance() async {
  //   pb = PocketBase(url!);
  //   await pb.admins.authWithPassword('info@yegobox.com', password!);
  //   return this;
  // }

  // void putInSync() {
  //   pb
  //       .collection('orders')
  //       .subscribe("*", (e) {})
  //       .catchError((error, stackTrace) {
  //     log(error);
  //     log(stackTrace);
  //   });
  // }

  // @override
  // Future<List<RecordModel>> getCollection({required String collectionName}) {
  //   return pb.collection(collectionName).getFullList();
  // }

  // @override
  // Future<void> create(
  //     {required Map<String, dynamic> collection,
  //     required String collectionName}) async {
  //   pb.collection(collectionName).create(body: collection).then((record) {
  //     print(record.id);
  //     print(record.getStringValue('id'));
  //   });
  // }

  // @override
  // Future<void> update(
  //     {required Map<String, dynamic> updateCollection,
  //     required String collectionName}) {
  //   return pb
  //       .collection(collectionName)
  //       .update(updateCollection["id"], body: updateCollection)
  //       .then((record) {
  //     print(record.id);
  //     print(record.getStringValue('id'));
  //   });
  // }
}
