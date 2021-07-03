// import 'package:customer/app/app.logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper/routes.logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'exceptions/firestore_api_exception.dart';

abstract class Firestore {
  Future<void> createUser({required dynamic user});
  Future<void> getUser({required String userId});
  Future<void> saveTokenToDatabase(String token);
}

class UnSupportedFirestoreApi implements Firestore {
  @override
  Future<void> createUser({required user}) async {
    // TODO: implement createUser
  }

  @override
  Future<void> getUser({required String userId}) async {
    // TODO: implement getUser
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {
    // TODO: implement saveTokenToDatabase
  }
}

class FirestoreApi implements Firestore {
  final log = getLogger('FirestoreApi');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Future<void> createUser({required dynamic user}) async {
    log.i('user:$user');

    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson());
      log.v('UserCreated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }

  @override
  Future<void> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      // return User.fromJson(userData!);
    } else {
      throw FirestoreApiException(
          message:
              'Your userId passed in is empty. Please pass in a valid user if from your Firebase user.');
    }
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }
}
