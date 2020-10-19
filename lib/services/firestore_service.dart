import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/services.dart';

import 'package:logger/logger.dart';

class FirestoreService {
   final Logger log = Logging.getLogger('Firestore service ....');

  // final CollectionReference _usersCollectionReference =
  //     FirebaseFirestore.instance.collection('users');
  // final CollectionReference _starsCollectionReference =
  //     FirebaseFirestore.instance.collection('stars');
 

  // final StreamController<List<Star>> _starsController =
  //     StreamController<List<Star>>.broadcast();

  // Future createUser(LUser user) async {
  //   try {
  //     await _usersCollectionReference.doc(user.id).set(user.toJson());
  //   } catch (e) {
  //     // TODO(richard): Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }
  //     return e.toString();
  //   }
  // }

  // Future getUser(String uid) async {
  //   try {
  //     final DocumentSnapshot doc =
  //         await _usersCollectionReference.doc(uid).get();

  //     if (doc.exists) {
  //       final userData = await _usersCollectionReference.doc(uid).get();
  //       log.i('User Exist');
  //       log.i(LUser.fromData(userData.data()).id);
  //       return LUser.fromData(userData.data());
  //     } else {
  //       await addUser(
  //         LUser(
  //           id: uid,
  //           dateOfBirth: Timestamp.fromDate(DateTime.now()),
  //         ),
  //       );
  //       final userData = await _usersCollectionReference.doc(uid).get();
  //       log.i('created new user in firestore');
  //       log.i(LUser.fromData(userData.data()).id);
  //       return LUser.fromData(userData.data());
  //     }
  //   } catch (e) {
  //     // TODO(richard): Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }
  //     return e.toString();
  //   }
  // }

  // Future addUser(LUser user) async {
  //   try {
  //     await _usersCollectionReference.doc(user.id).set(user.toJson());
  //   } catch (e) {
  //     // TODO(richard): Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Future getUserOnceOff() async {
  //   try {
  //     final QuerySnapshot postDocumentSnapshot =
  //         await _usersCollectionReference.get();
  //     if (postDocumentSnapshot.docs.isNotEmpty) {
  //       return postDocumentSnapshot.docs
  //           .map((snapshot) => LUser.fromMap(snapshot.data(), snapshot.id))
  //           .where((mappedItem) => mappedItem.name != null)
  //           .toList();
  //     }
  //   } catch (e) {
  //     // TODO(richard): Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Stream listenToStarsRealTime() {
  //   // Register the handler for when the posts data changes
  //   _starsCollectionReference.snapshots().listen((postsSnapshot) {
  //     if (postsSnapshot.docs.isNotEmpty) {
  //       final stars = postsSnapshot.docs
  //           .map((snapshot) => Star.fromMap(snapshot.data(), snapshot.id))
  //           .where((mappedItem) => mappedItem.star != null)
  //           .toList();

  //       // Add the posts onto the controller
  //       _starsController.add(stars);
  //     }
  //   });

  //   return _starsController.stream;
  // }

  // Future deleteUser(String documentId) async {
  //   await _starsCollectionReference.doc(documentId).delete();
  // }

  // Future updateUser(LUser user) async {
  //   try {
  //     await _starsCollectionReference.doc(user.id).update(user.toJson());
  //   } catch (e) {
  //     // TODO(richard): Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }
  //     return e.toString();
  //   }
  // }
}
