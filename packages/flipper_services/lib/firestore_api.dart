// import 'package:customer/app/app.logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/proxy.dart';
import 'exceptions/firestore_api_exception.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flipper_models/business.dart';

abstract class Firestore {
  Future<void> createUser({required dynamic user, required String token});
  Future<void> getUser({required String userId});
  Future<void> saveTokenToDatabase({String? token, Map? business});
  Future<void> createUserInFirestore({required Map user});
  Stream<List<Business>> contacts();
  void addContact({required Business business});
  void deleteRoom({required String roomId});
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

  @override
  Future<void> createUserInFirestore({required Map user}) {
    // TODO: implement createUserInFirestore
    throw UnimplementedError();
  }

  @override
  Stream<List<Business>> contacts() {
    // TODO: implement contacts
    throw UnimplementedError();
  }

  @override
  void addContact({required Business business}) {
    // TODO: implement addContact
  }

  @override
  void deleteRoom({required String roomId}) {
    // TODO: implement deleteRoom
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
    // String? userId = ProxyService.box.read(key: 'userId');
    log.i(business!['id']);
    User? user = await ProxyService.auth.getCurrentUserId();

    // await ProxyService.api.getBusinessById(id: business['id']);
    //patch a business to add a chat uid
    business['chatUid'] = user!.uid;
    // log.i(business);
    if (business['id'] is int) {
      ProxyService.api.updateBusiness(id: business['id'], business: business);

      //this update local database
      ProxyService.api.update(
          data: business, endPoint: 'businesses/' + business['id'].toString());
    }

    //old way!
    // createUser(user: userId, token: token!);
    // try {
    //   await usersCollection.doc(userId).update({
    //     'tokens': FieldValue.arrayUnion([token]),
    //   });
    // } catch (e) {}
  }

  @override
  Future<void> createUserInFirestore({required Map user}) async {
    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: user['firstName'],
        id: user['uid'],
        imageUrl: user['imageUrl'],
        lastName: user['lastName'],
        // phoneNumber: user['phoneNumber'],
      ),
    );
  }

  @override
  Stream<List<Business>> contacts() {
    return FirebaseChatCore.instance.contacts();
  }

  @override
  void addContact({required Business business}) {
    return FirebaseChatCore.instance.addContact(contact: business);
  }

  @override
  void deleteRoom({required String roomId}) {
    return FirebaseChatCore.instance.deleteRoom(roomId: roomId);
  }
}
