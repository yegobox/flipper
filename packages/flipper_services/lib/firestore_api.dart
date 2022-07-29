import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/proxy.dart';
import 'exceptions/firestore_api_exception.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

// https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40
abstract class FlipperFirestore {
  Future<void> createUser({required dynamic user, required String token});
  Future<void> getUser({required String userId});
  Future<void> saveTokenToDatabase({String? token, Map? business});
  Future<void> createUserInFirestore({required Map user});
  Stream<List<Business>> contacts();
  void addContact({required Business business});
  void deleteRoom({required String roomId});
  void pullProducts({required int branchId});
  void pushProducts({required int branchId});
  void pushVariations({required int branchId, required List<Variant> products});
  void pushStock({required int branchId, required List<Stock> products});
  void configureEbm();
  void configureTokens();
}

class UnSupportedFirestoreApi implements FlipperFirestore {
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

  @override
  void pullProducts({required int branchId}) {
    // TODO: implement pullProducts
  }

  @override
  void pushProducts({required int branchId}) {
    // TODO: implement pushProducts
  }

  @override
  void pushStock({required int branchId, required List<Stock> products}) {
    // TODO: implement pushStock
  }

  @override
  void pushVariations(
      {required int branchId, required List<Variant> products}) {
    // TODO: implement pushVariations
  }

  @override
  void configureEbm() {
    // TODO: implement configureEbm
  }

  @override
  void configureTokens() {
    // TODO: implement configureTokens
  }
}

class FirestoreApi implements FlipperFirestore {
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
        return;
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
    // User? user = await ProxyService.auth.getCurrentUserId();

    // await ProxyService.isarApi.getBusinessById(id: business['id']);
    //patch a business to add a chat uid
    // business['chatUid'] = user!.uid;
    // log.i(business);
    if (business['id'] is int) {
      // to avoid unneccessary database api calls
      // call this only when a user log in and it is on Monday
      final today = DateTime.now().weekday;
      if (today == 1) {
        ProxyService.isarApi.update(data: business);

        ProxyService.isarApi.update(data: business);
      }
    }
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
    // return FirebaseChatCore.instance.contacts();
    throw UnimplementedError();
  }

  @override
  void addContact({required Business business}) {
    // return FirebaseChatCore.instance.addContact(contact: business);
  }

  @override
  void deleteRoom({required String roomId}) {
    return FirebaseChatCore.instance.deleteRoom(roomId: roomId);
  }

  @override
  void pullProducts({required int branchId}) {
    // return unImplemented();
    throw UnimplementedError();
  }

  /// this method is only used when the product is first created
  /// then it will push it to other ends using firestore
  /// the other ends will pull it from firestore and create it in our localStore!
  /// loop through all products and get related variations and push them
  /// by each variation get stock and push it also.
  @override
  void pushProducts({required int branchId}) async {
    throw UnimplementedError();
  }

  @override
  void pushStock({required int branchId, required List<Stock> products}) {
    // TODO: implement pushStock
  }

  @override
  void pushVariations(
      {required int branchId, required List<Variant> products}) {
    // TODO: implement pushVariations
  }

  @override
  void configureEbm() {
    String userId = ProxyService.box.getUserId()!;
    FirebaseFirestore.instance
        .collection('ebm')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          Ebm ebm = Ebm.fromJson(data);
          log.i(ebm.userId);
          ProxyService.isarApi.update(data: ebm);
        }
        if (change.type == DocumentChangeType.modified) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          Ebm ebm = Ebm.fromJson(data);
          ProxyService.isarApi.update(data: ebm);
        }
      }
    });
  }

  @override
  void configureTokens() {
    String userId = ProxyService.box.getUserId()!;
    FirebaseFirestore.instance
        .collection('tokens')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          Token token = Token.fromJson(data);

          ProxyService.isarApi.update(data: token);
        }
        if (change.type == DocumentChangeType.modified) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          Token token = Token.fromJson(data);

          ProxyService.isarApi.update(data: token);
        }
      }
    });
  }
}
