import 'package:flipper_services/abstractions/sync.dart';
import 'package:flipper_services/proxy.dart';

/// the class provide sync service
/// using firebase firestore
/// as sync service to sync data across devices and clients.
/// if data are done sync, then it will be deleted from the firestore.
/// it is very important for the users to use this class to sync data.
/// add field needToSync property in products documents
/// this field need to be added when the product is created
/// this will mark the product as need to sync then will be send to firestore
/// once sync is done then the status will change locally, so it won't be send to firestore again
/// always check if there is product to download from firestore
/// to local database
/// when do we need to pull? we always need to pull when the app is opened every time.
/// https://stackoverflow.com/questions/50471309/how-to-listen-for-document-changes-in-cloud-firestore-using-flutter

class SyncApi implements SyncApiInterface {
  @override
  void pull() async {
    int branchId = await ProxyService.box.read(key: 'branchId');
    ProxyService.firestore.pullProducts(branchId: branchId);
  }

  /// push all products that has been marked as need to sync i.e synced=false
  @override
  void push() async {
    int branchId = await ProxyService.box.read(key: 'branchId');
    ProxyService.firestore.pushProducts(branchId: branchId);
  }
}
