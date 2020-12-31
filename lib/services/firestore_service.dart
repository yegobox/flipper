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

  Future<FlipperConfig> getCongigs() async {
    // FirebaseFirestore.instance.enablePersistence();
    try {
      final DocumentSnapshot doc =
          await _configsCollectionReference.doc('OkPbVIkBPz5jsVdYihbA').get();

      if (doc.exists) {
        FlipperConfig flipper_config = FlipperConfig.fromData(doc.data());
        log.i(flipper_config);
        return flipper_config;
      }
    } catch (e) {}
  }
}
