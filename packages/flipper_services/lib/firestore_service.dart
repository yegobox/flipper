library flipper_services;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_services/flipper_config.dart';
import 'package:flipper_services/logger.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flipper_services/proxy.dart';
import 'package:logger/logger.dart';

// FIXME: isshue here
// https://stackoverflow.com/questions/53395899/why-are-these-firestore-rules-not-working-with-the-flutter-firebase-plugin
// https://medium.com/@khreniak/cloud-firestore-security-rules-basics-fac6b6bea18e
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

  // Future<QuerySnapshot> myContacts() {
  //   final Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
  //   final Auth.User currentUser = auth.currentUser;

  //   return FirebaseFirestore.instance
  //       .collection('contacts')
  //       .doc('global')
  //       .collection('lists')
  //       .where('channels', arrayContains: ProxyService.sharedState.user.id)
  //       .get();
  // }

  // Future<QuerySnapshot> globalContacts() {
  //   final Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
  //   final currentUser = auth.currentUser;

  //   return FirebaseFirestore.instance
  //       .collection('contacts')
  //       .doc('global')
  //       .collection('lists')
  //       .get();
  // }

  // Future<void> addContacts(contact) async {
  //   final Future<QuerySnapshot> iExistInDb = FirebaseFirestore.instance
  //       .collection('contacts')
  //       .doc('global')
  //       .collection('lists')
  //       .where('channels', arrayContains: ProxyService.sharedState.user.id)
  //       .get();
  //   iExistInDb.then((QuerySnapshot value) {
  //     if (value.docs.isEmpty) {
  //       //then add this contact to db.
  //       FirebaseFirestore.instance
  //           .collection('contacts')
  //           .doc('global')
  //           .collection('lists')
  //           .add(contact)
  //           .catchError((e) {
  //         log.e(e.toString());
  //       });
  //     }
  //   });
  // }
}
