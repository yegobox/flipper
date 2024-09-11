import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:realm/realm.dart';
import 'dart:convert';

class BackupService {
  static const int BATCH_SIZE = 100;
  final FirebaseFirestore _firestore;
  Realm? _realm;

  BackupService(this._firestore);

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
        await _processBatch(batch);
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

  Future<void> _processBatch(List<TransactionItem> batch) async {
    WriteBatch writeBatch = _firestore.batch();

    for (TransactionItem item in batch) {
      final json = _encodeItem(item);
      final Map<String, dynamic> dataMap = jsonDecode(json);
      final docRef =
          _firestore.collection('transactionsItems').doc(item.id.toString());

      // Check if the document exists
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        writeBatch.update(docRef, dataMap);
        talker.info("Queued update for item ${item.id}");
      } else {
        writeBatch.set(docRef, dataMap);
        talker.info("Queued creation for item ${item.id}");
      }
    }

    // Commit the batch
    await writeBatch.commit();

    talker.info("Processed and committed batch of ${batch.length} items");
  }

  String _encodeItem(TransactionItem item) {
    return jsonEncode(item.toEJson().convertRealmValues());
  }
}
