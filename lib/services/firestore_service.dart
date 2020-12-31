import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper/model/flipper_config.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/services.dart';

import 'package:logger/logger.dart';

class FirestoreService {
  final Logger log = Logging.getLogger('Firestore service ....');

  final CollectionReference _configsCollectionReference =
      FirebaseFirestore.instance.collection('flipper-configs');

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
