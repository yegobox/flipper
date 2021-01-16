library flipper_services;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_services/flipper_config.dart';
import 'package:flipper_services/logger.dart';

import 'package:logger/logger.dart';

class FirestoreService {
  final Logger log = Logging.getLogger('Firestore service ....');

  final CollectionReference _configsCollectionReference =
      FirebaseFirestore.instance.collection('flipper-configs');

  // ignore: missing_return
  Future<FlipperConfig> getConfigs() async {
    try {
      final DocumentSnapshot doc =
          await _configsCollectionReference.doc('bsNzGihYlNbcODhKmhqJ').get();

      if (doc.exists) {
        final FlipperConfig flipperConfig = FlipperConfig.fromData(doc.data());

        return flipperConfig;
      }
    } catch (e) {
      log.d(e);
    }
  }
}
