import 'package:cbl/cbl.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReplicatorProvider {
  ReplicatorProvider({required this.databaseProvider});

  final DatabaseProvider databaseProvider;
  Replicator? _replicator;
  ReplicatorConfiguration? _replicatorConfiguration;
  ListenerToken? statusChangedToken;
  ListenerToken? documentReplicationToken;
  bool isInitialized = false;

  // Add replicator status for state management
  ReplicatorStatus? _replicatorStatus;
  ReplicatorStatus? get replicatorStatus => _replicatorStatus;

  Future<void> init() async {
    if (isInitialized) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: already initialized');
      return;
    }

    debugPrint('${DateTime.now()} [ReplicatorProvider] info: starting init.');
    try {
      var db = databaseProvider.flipperDatabase;
      if (db == null) {
        throw Exception('Database is null');
      }

      // Load certificate
      var pem =
          await rootBundle.load('packages/flipper_services/assets/flipper.pem');

      final url = Uri(
        scheme: 'wss',
        host: AppSecrets.capelaHost,
        port: 4984,
        path: 'flipper',
      );

      var basicAuthenticator = BasicAuthenticator(
        username: AppSecrets.capelaUsername,
        password: AppSecrets.capelaPassword,
      );

      var endPoint = UrlEndpoint(url);

      _replicatorConfiguration = ReplicatorConfiguration(
        database: db,
        target: endPoint,
        authenticator: basicAuthenticator,
        continuous: true,
        replicatorType: ReplicatorType.pushAndPull,
        heartbeat: const Duration(seconds: 60),
        pinnedServerCertificate: pem.buffer.asUint8List(),
      );

      if (_replicatorConfiguration != null) {
        _replicator = await Replicator.createAsync(_replicatorConfiguration!);

        // Add status change listener with proper await
        if (_replicator != null) {
          statusChangedToken = await _replicator!.addChangeListener((change) {
            _replicatorStatus = change.status;
            debugPrint(
                '${DateTime.now()} [ReplicatorProvider] status changed: ${change.status.activity}');
            if (change.status.error != null) {
              debugPrint(
                  '${DateTime.now()} [ReplicatorProvider] error: ${change.status.error}');
            }
          });

          // Add document replication listener with proper await
          documentReplicationToken =
              await _replicator!.addDocumentReplicationListener((replication) {
            debugPrint(
                '${DateTime.now()} [ReplicatorProvider] documents replicated: ${replication.documents.length}');
            for (var doc in replication.documents) {
              if (doc.error != null) {
                debugPrint(
                    '${DateTime.now()} [ReplicatorProvider] document error: ${doc.error}');
              }
            }
          });
        }

        isInitialized = true;
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] info: initialization complete');
      }
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] error during init: $e');
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> startReplicator() async {
    if (!isInitialized) {
      throw Exception('ReplicatorProvider not initialized. Call init() first.');
    }

    debugPrint(
        '${DateTime.now()} [ReplicatorProvider] info: starting replicator.');

    try {
      var replicator = _replicator;
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

  Future<void> stopReplicator() async {
    var replicator = _replicator;
    if (replicator != null) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: stopping replicator.');

      try {
        await removeDocumentReplicationListener();
        await removeStatusChangeListener();
        await replicator.stop();

        statusChangedToken = null;
        documentReplicationToken = null;
        isInitialized = false;

        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] info: stopped replicator.');
      } catch (e, stackTrace) {
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] error stopping replicator: $e');
        debugPrint(
            '${DateTime.now()} [ReplicatorProvider] stackTrace: $stackTrace');
        rethrow;
      }
    } else {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: tried to stop replicator but it was null.');
    }
  }

  Future<void> removeStatusChangeListener() async {
    var replicator = _replicator;
    var token = statusChangedToken;
    if (replicator != null && token != null) {
      if (!replicator.isClosed) {
        replicator.removeChangeListener(token);
      }
    }
  }

  Future<void> removeDocumentReplicationListener() async {
    var replicator = _replicator;
    var token = documentReplicationToken;
    if (replicator != null && token != null) {
      if (!replicator.isClosed) {
        replicator.removeChangeListener(token);
      }
    }
  }
}
