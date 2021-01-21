// import 'package:firebase_performance/firebase_performance.dart';
// import 'package:flipper/utils/logger.dart';
// import 'package:logger/logger.dart';
library flipper_services;

import 'package:flipper_services/logger.dart';
import 'package:logger/logger.dart';

class PerformanceService {
  final Logger log = Logging.getLogger('Performance Service');
  // final FirebasePerformance _performance = FirebasePerformance.instance;
  bool _isPerformanceCollectionEnabled = false;
  String _performanceCollectionMessage =
      'Unknown status of performance collection.';

  Future<void> togglePerformanceCollection() async {
    // await _performance
    //     .setPerformanceCollectionEnabled(!_isPerformanceCollectionEnabled);

    // final bool isEnabled = await _performance.isPerformanceCollectionEnabled();
    // _isPerformanceCollectionEnabled = isEnabled;
    // _performanceCollectionMessage = _isPerformanceCollectionEnabled
    //   ? 'Performance collection is enabled.'
    //   : 'Performance collection is disabled.';

    // log.d(_performanceCollectionMessage);
  }
}
