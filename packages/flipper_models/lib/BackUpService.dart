import 'dart:async';
import 'package:flipper_models/CloudSync.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:realm/realm.dart';

class BackupService {
  static const int BATCH_SIZE = 100;
  Realm? _realm;

  FlexibleSyncConfiguration flexibleConfig(
    User user,
    List<int> encryptionKey,
    String dbPath,
  ) {
    return Configuration.flexibleSync(
      user,
      realmModels,
      encryptionKey: encryptionKey,
      path: dbPath,
    );
  }

  Future<void> backUp(
      {required int branchId,
      required String encryptionKey,
      required String dbPath}) async {
    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser;
    if (user == null) return;

    FlexibleSyncConfiguration config =
        flexibleConfig(user, encryptionKey.toIntList(), dbPath);

    _realm?.close();
    _realm = Realm(config);

    try {
      List<TransactionItem> items = _realm!
          .query<TransactionItem>(r'branchId == $0', [branchId]).toList();
      List<List<TransactionItem>> batches =
          _splitIntoBatches(items, BATCH_SIZE);

      for (var batch in batches) {
        await CloudSync().processbatchBackUp(batch);
      }
      talker.info("Backup completed successfully for branch $branchId");
    } catch (e, stackTrace) {
      talker.error("Error during backup for branch $branchId: $e", stackTrace);
      rethrow;
    } finally {
      _realm?.close();
    }
  }

  List<List<TransactionItem>> _splitIntoBatches(
      List<TransactionItem> items, int batchSize) {
    return [
      for (var i = 0; i < items.length; i += batchSize)
        items.sublist(
            i, i + batchSize > items.length ? items.length : i + batchSize)
    ];
  }
}
