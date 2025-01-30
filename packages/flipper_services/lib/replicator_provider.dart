import 'package:cbl/cbl.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/database_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class CustomConflictResolver extends ConflictResolver {
  @override
  Document resolve(Conflict conflict) {
    try {
      talker.warning('Resolving conflict');
      // Always return remote document if local is null
      if (conflict.localDocument == null) {
        return conflict.remoteDocument!;
      }
      // Always return local document if remote is null
      if (conflict.remoteDocument == null) {
        return conflict.localDocument!;
      }

      final localDoc = conflict.localDocument!;
      final remoteDoc = conflict.remoteDocument!;

      // Get timestamps with proper null handling
      final localMap = Map<String, dynamic>.from(localDoc.toPlainMap());
      final remoteMap = Map<String, dynamic>.from(remoteDoc.toPlainMap());

      final localTimestamp = localMap['lastModified'] as int? ?? 0;
      final remoteTimestamp = remoteMap['lastModified'] as int? ?? 0;

      // If one document is clearly newer, use that one
      if (localTimestamp > remoteTimestamp) {
        debugPrint('Using local document as it is newer');
        return localDoc;
      } else if (remoteTimestamp > localTimestamp) {
        debugPrint('Using remote document as it is newer');
        return remoteDoc;
      }

      // If timestamps are equal, merge the documents
      final mergedContent = _mergeDocuments(localMap, remoteMap);
      final mutableDoc = MutableDocument.withId(localDoc.id);
      mutableDoc.setData(mergedContent);
      return mutableDoc;
    } catch (e) {
      debugPrint('Error in conflict resolution: $e');
      debugPrint('Local document: ${conflict.localDocument?.toPlainMap()}');
      debugPrint('Remote document: ${conflict.remoteDocument?.toPlainMap()}');

      // Default to remote document if merge fails
      return conflict.remoteDocument ?? conflict.localDocument!;
    }
  }

  Map<String, dynamic> _mergeDocuments(
    Map<String, dynamic> localContent,
    Map<String, dynamic> remoteContent,
  ) {
    final mergedContent = Map<String, dynamic>.from(remoteContent);

    // Process all keys from both local and remote
    Set<String> allKeys = {...localContent.keys, ...remoteContent.keys};

    for (final key in allKeys) {
      final localValue = localContent[key];
      final remoteValue = remoteContent[key];

      if (remoteValue == null) {
        mergedContent[key] = localValue;
      } else if (localValue == null) {
        mergedContent[key] = remoteValue;
      } else if (localValue is List && remoteValue is List) {
        final mergedList = [...remoteValue];
        for (final item in localValue) {
          if (!mergedList.contains(item)) {
            mergedList.add(item);
          }
        }
        mergedContent[key] = mergedList;
      } else if (localValue is Map && remoteValue is Map) {
        mergedContent[key] = _mergeDocuments(
          Map<String, dynamic>.from(localValue),
          Map<String, dynamic>.from(remoteValue),
        );
      }
    }

    mergedContent['_merged'] = true;
    mergedContent['_mergeTimestamp'] = DateTime.now().millisecondsSinceEpoch;

    return mergedContent;
  }
}

class ReplicatorProvider {
  ReplicatorProvider({required this.databaseProvider});

  final DatabaseProvider databaseProvider;
  Replicator? _pullReplicator;
  Replicator? _pushPullReplicator;
  ReplicatorConfiguration? _pullConfiguration;
  ReplicatorConfiguration? _pushPullConfiguration;
  ListenerToken? statusChangedToken;
  ListenerToken? documentReplicationToken;
  bool isInitialized = false;
  bool _initialSyncComplete = false;

  ReplicatorStatus? _replicatorStatus;
  ReplicatorStatus? get replicatorStatus => _replicatorStatus;
  String get scope => "_default";

  Future<void> init() async {
    if (isInitialized) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: already initialized');
      return;
    }

    debugPrint('${DateTime.now()} [ReplicatorProvider] info: starting init.');
    try {
      final db = databaseProvider.database;
      if (db == null) {
        throw Exception('Database is null');
      }
      // Create the conflict resolver
      final conflictResolver = CustomConflictResolver();

      final counterCollections = await db.collections(scope);

      final collectionConfig = CollectionConfiguration(
        channels: [ProxyService.box.getBranchId()!.toString()],
        pullFilter: (document, flags) => true,
        conflictResolver: conflictResolver,
        // pushFilter: (document, flags) => ,
      );

      if (!ProxyService.box.useInHouseSyncGateway()!) {
        final pem = await rootBundle
            .load('packages/flipper_services/assets/flipper.pem');

        final url = Uri(
          scheme: 'wss',
          host: AppSecrets.capelaHost,
          port: 4984,
          path: 'flipper/',
        );

        final basicAuthenticator = BasicAuthenticator(
          username: AppSecrets.capelaUsername,
          password: AppSecrets.capelaPassword,
        );

        final endPoint = UrlEndpoint(url);

        _pushPullConfiguration = ReplicatorConfiguration(
          target: endPoint,
          authenticator: basicAuthenticator,
          continuous: true,
          replicatorType: ReplicatorType.pushAndPull,
          heartbeat: const Duration(seconds: 10),
          pinnedServerCertificate: pem.buffer.asUint8List(),
        )..addCollections(counterCollections, collectionConfig);

        _pushPullReplicator = await Replicator.create(_pushPullConfiguration!);
        await _pushPullReplicator!.start(reset: false);
        await _setupReplicatorListeners(_pushPullReplicator!, true);
      } else {
        // Local sync gateway configuration
        final url = Uri(
          scheme: 'ws',
          host: "127.0.0.1",
          port: 4984,
          path: 'flipper/',
        );

        final basicAuthenticator = BasicAuthenticator(
          username: "admin",
          password: "umwana789",
        );

        _pullConfiguration = ReplicatorConfiguration(
          target: UrlEndpoint(url),
          authenticator: basicAuthenticator,
          continuous: false,
          replicatorType: ReplicatorType.pull,
          heartbeat: const Duration(seconds: 30),
        )..addCollections(counterCollections, collectionConfig);

        // Create and start pull replicator immediately
        _pullReplicator = await Replicator.create(_pullConfiguration!);
        await _setupReplicatorListeners(_pullReplicator!, true);
        await _pullReplicator!
            .start(); // Start replicator immediately after setup

        _pushPullConfiguration = ReplicatorConfiguration(
          target: UrlEndpoint(url),
          authenticator: basicAuthenticator,
          continuous: true,
          replicatorType: ReplicatorType.pushAndPull,
          heartbeat: const Duration(seconds: 60),
        )..addCollections(counterCollections, collectionConfig);
      }

      isInitialized = true;
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: initialization complete');
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] error during init: $e');
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _setupReplicatorListeners(
      Replicator replicator, bool isPullOnly) async {
    await replicator.addChangeListener((change) {
      talker.debug('Replicator status changed: ${change.status.activity}');
      talker.debug('Replicator status details: ${change.status}');

      if (change.status.error != null) {
        talker.error('Replication error detected:');
        talker.error('Error details: ${change.status.error}');
        talker.error('Error domain: ${change.status.error}');
        talker.error('Error code: ${change.status.error}');
      }
    });

    await replicator.addDocumentReplicationListener((replication) {
      talker.debug('Document replication event triggered');

      for (var doc in replication.documents) {
        talker.debug('Replicating document: ${doc.id}');

        // Check for conflict error code specifically
        if (doc.error != null) {
          talker.error('Document error found:');
          talker.error('Error code: ${doc.error}');

          // Add explicit conflict check
          if (doc.error.toString().contains('conflict') ||
              doc.error.toString().contains('409')) {
            talker.warning('Potential conflict detected for doc: ${doc.id}');
            _handlePotentialConflict(doc.id);
          }
        }
      }
    });
  }

  Future<void> _handlePotentialConflict(String documentId) async {
    try {
      final db = databaseProvider.database;
      if (db == null) return;

      final collection = await db.collection(countersTable, scope);
      if (collection == null) return;

      final doc = await collection.document(documentId);
      if (doc == null) return;

      talker.warning('Checking document for conflicts: $documentId');

      // Get current revision
      // final currentRev = await doc.revisionID;
      // talker.debug('Current revision: $currentRev');

      // // Try to force conflict resolution
      // final mutableDoc = doc.toMutable();
      // final currentData = doc.toPlainMap();

      // // Add a timestamp to force a change
      // currentData['_conflictCheck'] = DateTime.now().millisecondsSinceEpoch;
      // mutableDoc.setData(currentData);

      // try {
      //   await collection.save(mutableDoc);
      //   talker.debug('Successfully saved document after conflict check');
      // } catch (saveError) {
      //   talker.error('Error saving document during conflict check: $saveError');

      //   // If we get here, there might be a conflict that needs manual resolution
      //   if (saveError.toString().contains('conflict')) {
      //     talker.warning('Confirmed conflict during save, attempting manual resolution');

      //     // Create a conflict object manually if needed
      //     final remoteDoc = await collection.document(documentId);
      //     if (remoteDoc != null) {
      //       final conflict = Conflict(
      //         documentID: documentId,
      //         localDocument: doc,
      //         remoteDocument: remoteDoc,
      //       );

      //       // Try resolving manually
      //       final resolvedDoc = conflictResolver.resolve(conflict);
      //       if (resolvedDoc != null) {
      //         await collection.save(resolvedDoc.toMutable());
      //         talker.debug('Manually resolved conflict for document: $documentId');
      //       }
      //     }
      //   }
      // }
    } catch (e) {
      talker.error('Error handling potential conflict: $e');
    }
  }

  Future<void> startReplicator() async {
    if (!isInitialized) {
      throw Exception('ReplicatorProvider not initialized. Call init() first.');
    }

    debugPrint(
        '${DateTime.now()} [ReplicatorProvider] info: starting replicator.');

    try {
      final replicator = _pushPullReplicator;
      if (replicator == null) {
        throw Exception('Replicator is null');
      }

      final currentStatus = await replicator.status;
      if (currentStatus.activity == ReplicatorActivityLevel.stopped) {
        await replicator.start();
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] info: started replicator.');
      } else {
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] warning: replicator already running.');
      }
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] error starting replicator: $e');
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> removeStatusChangeListener() async {
    final replicator =
        _initialSyncComplete ? _pushPullReplicator : _pullReplicator;
    final token = statusChangedToken;
    if (replicator != null && token != null && !replicator.isClosed) {
      replicator.removeChangeListener(token);
    }
  }

  Future<void> removeDocumentReplicationListener() async {
    final replicator =
        _initialSyncComplete ? _pushPullReplicator : _pullReplicator;
    final token = documentReplicationToken;
    if (replicator != null && token != null && !replicator.isClosed) {
      replicator.removeChangeListener(token);
    }
  }
}
