import 'package:cbl/cbl.dart';
import 'package:flipper_services/auth_service.dart';
import 'package:flipper_services/database_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReplicatorProvider {
  ReplicatorProvider(
      {required this.authenticationService, required this.databaseProvider});

  final AuthenticationService authenticationService;
  final DatabaseProvider databaseProvider;

  Replicator? _replicator;
  ReplicatorConfiguration? _replicatorConfiguration;
  ListenerToken? statusChangedToken;
  ListenerToken? documentReplicationToken;

  //init - NOTE:  YOU MUST modify the replicator configuration prior to starting the replicator
  // or it will not function properly.
  Future<void> init() async {
    debugPrint('${DateTime.now()} [ReplicatorProvider] info: starting init.');
    var db = databaseProvider.flipperDatabase;
    var user = await authenticationService.getCurrentUser();
    if (db != null && user != null) {
      //MODIFY THIS CONFIG OR REPLICATOR WILL NOT RUN PROPERLY

      /*********************************************************************

      ** For Sync Gateway User:  Docker installations on your local computer
      ** require these changes to work with the learning path documentation

      ** scheme: switch from wss to ws

      ** port: 4984

      ** host:
      **    Android:
      **      10.0.2.2
      **    iOS:
      **      localhost
      **
      ** path:  projects
      **

       ** For App Services Users:  You can find  this url in your
       ** App Services Endpoint connection tab
       ** you will need to replace host with the provided host in the App Services
       ** connection tab and replace path with the endpoint path.
       ** for the learning path, you can default it to projects.

       **  example
       **    host:
       **     your_account_hostname.apps.cloud.couchbase.com
       **
       ** APP SERVICES Users - you must do the following:

       ** 1. Find the url in your App Services Endpoint connection tab
       **  a. you will need to replace host with the provided host in the App Services
       **     connection tab and replace path with the endpoint path.
       **  example
       **    host:
       **     your_account_hostname.apps.cloud.couchbase.com

       ** 2. In Capella, download the Public Certificate from the Connection tab in your App EndPoint
       ** 3. Add the .pem file to the asset folder in the src folder
       ** 4. Update your pubspec.yaml to include the certificate - note it's yaml so the spacing is important
       ** example
       **   assets:
       ** - asset/images/couchbase.png
       ** - asset/database/startingWarehouses.zip
       ** - asset/cert.pem
       ** 5. Uncomment the line below to load the certificate
       ** 6. Uncomment the line in the replicator configuration to load the certificate
       ************************************************************************************/

      // App Services Users - Uncomment to Load the certificate from the asset folder
      var pem = await rootBundle.load('flipper.pem');

      // <1>
      final url = Uri(
        scheme: 'wss',
        host: '47kehgpkrnw3vhdp.apps.cloud.couchbase.com',
        port: 4984,
        path: 'flipper',
      );
      var basicAuthenticator =
          BasicAuthenticator(username: user.username, password: user.password);
      var endPoint = UrlEndpoint(url);

      // <2>
      _replicatorConfiguration = ReplicatorConfiguration(
          // database: db,
          target: endPoint,
          authenticator: basicAuthenticator,
          continuous: true,
          replicatorType: ReplicatorType.pushAndPull,
          heartbeat: const Duration(seconds: 60),
          // **UNCOMMENT** this the line below if you are using App Services or a custom certificate
          pinnedServerCertificate: pem.buffer.asUint8List());
      final collection = await db.createCollection(await ProxyService.local
          .dbPath(path: 'local', folder: ProxyService.box.getBusinessId()));

      _replicatorConfiguration?.addCollection(collection);
      //check for nulls
      var config = _replicatorConfiguration;
      if (config != null) {
        // <3>
        _replicator = await Replicator.createAsync(config);
      }
    }
  }

  // callbacks are used to get information on status of replication
  // and what documents are being replicated through the replicator
  Future<void> startReplicator(
      {required Function(ReplicatorChange change)? onStatusChange,
      required Function(DocumentReplication document)? onDocument}) async {
    debugPrint(
        '${DateTime.now()} [ReplicatorProvider] info: starting replicator.');

    var replicator = _replicator;
    if (replicator != null) {
      if (onStatusChange != null) {
        var function = onStatusChange;
        statusChangedToken = await replicator.addChangeListener(function);
      }
      if (onDocument != null) {
        var function = onDocument;
        replicator.addDocumentReplicationListener(function);
      }
      await replicator.start();

      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: started replicator.');
    } else {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] error: cannot start replicator, it is null.');
    }
  }

  Future<void> stopReplicator() async {
    var replicator = _replicator;
    if (replicator != null) {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: stopping replicator.');

      //remove change listeners before stopping replicator, this should
      //automatically be done with stopping, but just to be safe
      await removeDocumentReplicationListener();
      await removeStatusChangeListener();

      await replicator.stop();

      //null out tokens so they can be reused
      statusChangedToken = null;
      documentReplicationToken = null;

      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] info: stopped replicator.');
    } else {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: tried to stop replicator but it was null.');
    }
  }

  Future<void> removeStatusChangeListener() async {
    var replicator = _replicator;
    var token = statusChangedToken;
    if (replicator != null && replicator.isClosed && token != null) {
      replicator.removeChangeListener(token);
    } else {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: tried to remove statusChangeListener but something was null');
    }
  }

  Future<void> removeDocumentReplicationListener() async {
    var replicator = _replicator;
    var token = documentReplicationToken;
    if (replicator != null && replicator.isClosed && token != null) {
      replicator.removeChangeListener(token);
    } else {
      debugPrint(
          '${DateTime.now()} [ReplicatorProvider] warning: tried to remove documentChangeListener but something was null');
    }
  }
}
