library flipper_services;

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flipper_services/logger.dart';
// import 'package:flipper/utils/logger.dart';
import 'package:flutter/services.dart';

// import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import './stoppable_service.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService extends StoppableService {
  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController =
      BehaviorSubject();
  // ignore: always_specify_types
  StreamSubscription subscription;
  final Logger log = Logging.getLogger('Connectivity Status Service');

  StreamSubscription<ConnectivityResult> _startConnectivity() {
    // Does not work on iOS simulator
    // track: https://github.com/flutter/flutter/issues/20980
    return Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // Use Connectivity() here to gather more info if you need to
      // Note that on Android, this does not guarantee connection to Internet. For instance, the app might have wifi access but it might be a VPN or a hotel WiFi with no access.
      // Proposes workaround
      if (Platform.isAndroid) {
        bool isOnline = false;
        if (result != ConnectivityResult.none) {
          try {
            // Note that google.com is not accessible inside in China
            // We could use also our own api/graphql server: if not reachable it's like being offline
            // This is not periodic, we check it only on netwtork status change, so loss of signal within the same connectivity is not handled atm
            final res = await Connectivity().checkConnectivity();
            if (res != ConnectivityResult.none) {
              isOnline = true;
            }
          } on PlatformException catch (_) {
            // May be thrown on Airplane mode
            isOnline = false;
          } on TimeoutException catch (_) {
            isOnline = false;
          } on SocketException catch (_) {
            isOnline = false;
          } on Exception catch (_) {}
        }
        if (isOnline) {
          connectionStatusController.add(_getStatusFromResult(result));
        } else {
          connectionStatusController.add(ConnectivityStatus.Offline);
        }
      } else {
        // on iOS proceed as expected
        connectionStatusController.add(_getStatusFromResult(result));
      }
    });
  }

  // ignore: sort_constructors_first
  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    try {
      subscription = _startConnectivity();
    } catch (e) {
      log.d('error in connectivity');
    }
  }

  Stream<ConnectivityStatus> get connectivityStatusStream =>
      connectionStatusController.stream;

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }

  @override
  void start() {
    super.start();
    log.d('ConnectivityStatus Service resumed');
    try {
      subscription = _startConnectivity();
    } catch (e) {
      log.d('cought an error in connectivity');
    }
  }

  @override
  void stop() {
    super.stop();
    log.d('ConnectivityStatus Service stopped');
    subscription.cancel();
  }
}
