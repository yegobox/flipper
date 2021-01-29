library flipper_services;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_services/flipper_config.dart';
import 'package:flipper_services/logger.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:logger/logger.dart';

class FirestoreService {
  final Logger log = Logging.getLogger('Firestore service ....');

  final CollectionReference _configsCollectionReference =
      FirebaseFirestore.instance.collection('flipper-configs');

  // ignore: missing_return
  Future<FlipperConfig> getConfigs() async {
    try {
      final DocumentSnapshot doc = await _configsCollectionReference
          .doc('bsNzGihYlNbcODhKmhqJ')
          .get()
          .catchError((e) {
        log.d(e.toString());
      });

      if (doc != null && doc.exists) {
        final FlipperConfig flipperConfig = FlipperConfig.fromData(doc.data());
        return flipperConfig;
      } else {
        return null;
      }
    } catch (e) {
      log.d(e);
    }
  }

  Future<QuerySnapshot> getContacts() {
    final Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
    final Auth.User currentUser = auth.currentUser;

    return FirebaseFirestore.instance
        .collection('contacts')
        .doc(currentUser.uid)
        .collection('lists')
        .get();
  }

  Future<void> addContacts(contact) async {
    final Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
    final Auth.User currentUser = auth.currentUser;
    FirebaseFirestore.instance
        .collection('contacts')
        .doc(currentUser.uid)
        .collection('lists')
        .add(contact)
        .catchError((e) {
      log.e(e.toString());
    });
  }
}
