// import 'package:customer/app/app.logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/proxy.dart';
import 'exceptions/firestore_api_exception.dart';

abstract class Firestore {
  Future<void> createUser({required dynamic user, required String token});
  Future<void> getUser({required String userId});
  Future<void> saveTokenToDatabase({String? token, Map? business});
}

class UnSupportedFirestoreApi implements Firestore {
  @override
  Future<void> createUser({required user, required String token}) async {
    // TODO: implement createUser
  }

  @override
  Future<void> getUser({required String userId}) async {
    // TODO: implement getUser
  }

  @override
  Future<void> saveTokenToDatabase({String? token, Map? business}) async {
    // TODO: implement saveTokenToDatabase
  }
}

class FirestoreApi implements Firestore {
  final log = getLogger('FirestoreApi');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Future<void> createUser(
      {required dynamic user, required String token}) async {
    log.i('user:$user');

    try {
      final userDocument = usersCollection.doc(user);
      await userDocument.set({
        'tokens': [token]
      });
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
  Future<void> saveTokenToDatabase({String? token, Map? business}) async {
    // String uid = FirebaseAuth.instance.currentUser!.uid;
    String? userId = ProxyService.box.read(key: 'userId');
    log.i(business!['id']);
    if (business['id'] is int) {
      ProxyService.api.updateBusiness(id: business['id'], business: business);

      //this update local database
      ProxyService.api
          .update(data: business, endPoint: 'businesses/' + business['id'].toString());
    }

    //old way!
    // createUser(user: userId, token: token!);
    // try {
    //   await usersCollection.doc(userId).update({
    //     'tokens': FieldValue.arrayUnion([token]),
    //   });
    // } catch (e) {}
  }
}
