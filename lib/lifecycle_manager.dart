import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/stoppable_service.dart';

/// Stop and start long running services
class LifeCycleManager extends StatefulWidget {
  const LifeCycleManager({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  List<StoppableService> servicesToManage = [
    // ProxyService.modal,
    ProxyService.connectivity, //stop connectiviry service for now.
  ];
  final Logger log = Logging.getLogger('LifeCycle Manager');

  // Get all services

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.i('state = $state');
    super.didChangeAppLifecycleState(state);
    // ignore: avoid_function_literals_in_foreach_calls
    servicesToManage.forEach((StoppableService service) {
      if (state == AppLifecycleState.resumed) {
        service.start();
      } else {
        try {
          service.stop();
          // ignore: empty_catches
        } catch (e) {}
      }
    });
  }
}
