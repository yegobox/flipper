// import 'package:customer/app/app.logger.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/proxy.dart';
import 'exceptions/firestore_api_exception.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flipper_models/models/models.dart';

// https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40
abstract class Firestore {
  Future<void> createUser({required dynamic user, required String token});
  Future<void> getUser({required String userId});
  Future<void> saveTokenToDatabase({String? token, Map? business});
  Future<void> createUserInFirestore({required Map user});
  Stream<List<BusinessSync>> contacts();
  void addContact({required BusinessSync business});
  void deleteRoom({required String roomId});
  void pullProducts({required int branchId});
  void pushProducts({required int branchId});
  void pushVariations(
      {required int branchId, required List<VariantSync> products});
  void pushStock({required int branchId, required List<StockSync> products});
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
  Stream<List<BusinessSync>> contacts() {
    // TODO: implement contacts
    throw UnimplementedError();
  }

  @override
  void addContact({required BusinessSync business}) {
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
  void pushStock({required int branchId, required List<StockSync> products}) {
    // TODO: implement pushStock
  }

  @override
  void pushVariations(
      {required int branchId, required List<VariantSync> products}) {
    // TODO: implement pushVariations
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
    // User? user = await ProxyService.auth.getCurrentUserId();

    // await ProxyService.api.getBusinessById(id: business['id']);
    //patch a business to add a chat uid
    // business['chatUid'] = user!.uid;
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
  Stream<List<BusinessSync>> contacts() {
    return FirebaseChatCore.instance.contacts();
  }

  @override
  void addContact({required BusinessSync business}) {
    return FirebaseChatCore.instance.addContact(contact: business);
  }

  @override
  void deleteRoom({required String roomId}) {
    return FirebaseChatCore.instance.deleteRoom(roomId: roomId);
  }

  @override
  void pullProducts({required int branchId}) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('products');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<dynamic, dynamic> data =
              change.doc.data() as Map<dynamic, dynamic>;

          ProductSync p = ProductSync.fromJson(data);

          var id = branchId.toString() + '-' + p.id.toString();
          FirebaseFirestore.instance
              .collection('products/${id}/variations')
              .get()
              .then((value) {
            value.docs.forEach((element) {
              Map<dynamic, dynamic> data = element.data();
              VariantSync variation = VariantSync.fromJson(data);
              FirebaseFirestore.instance
                  .collection('products/${id}/variations/${variation.id}/stock')
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  Map<dynamic, dynamic> data = element.data();
                  StockSync s = StockSync.fromJson(data);
                  ProxyService.api
                      .syncProduct(product: p, variant: variation, stock: s);
                });
              });
            });
          });
        }
        if (change.type == DocumentChangeType.modified) {
          log.d('firestore:modified triggered');
          // ProxyService.api.updateProduct(product: change.document.data());
        }
        if (change.type == DocumentChangeType.removed) {
          log.d('firestore:removed triggered');
          // ProxyService.api.deleteProduct(product: change.document.data());
        }
      });
    });
  }

  /// this method is only used when the product is first created
  /// then it will push it to other ends using firestore
  /// the other ends will pull it from firestore and create it in our localStore!
  /// loop through all products and get related variations and push them
  /// by each variation get stock and push it also.
  @override
  void pushProducts({required int branchId}) async {
    // ProxyService.api
    //     .productStreams(branchId: branchId)
    //     .listen((List<ProductSync> products) async {
    //   // loop each product and insert  in firestore
    //   for (ProductSync product in products) {
    //     // insert product
    //     var id = branchId.toString() + '-' + product.id.toString();
    //     FirebaseFirestore.instance
    //         .collection('products')
    //         .doc(id)
    //         .set(product.toJson())
    //         .then((v) {
    //       for (VariantSync variation in product.variations) {
    //         FirebaseFirestore.instance
    //             .collection('products')
    //             .doc(id)
    //             .collection('variations')
    //             .doc(variation.id.toString())
    //             .set(variation.toJson());
    //         // ignore: unnecessary_null_comparison
    //         if (variation.stock != null) {
    //           // TODOon web the relationship will always be null as we are using mock
    //           if (!isWeb) {
    //             FirebaseFirestore.instance
    //                 .collection('products')
    //                 .doc(id)
    //                 .collection('variations')
    //                 .doc(variation.id.toString())
    //                 .collection('stock')
    //                 .doc(variation.stock.target!.id.toString())
    //                 .set(variation.stock.target!.toJson());
    //           }
    //         }
    //       }
    //     });
    //     Map p = product.toJson();
    //     p['synced'] = true;
    //     //update product
    //     await ProxyService.api.update(data: p, endPoint: 'product');
    //   }
    // });
  }

  @override
  void pushStock({required int branchId, required List<StockSync> products}) {
    // TODO: implement pushStock
  }

  @override
  void pushVariations(
      {required int branchId, required List<VariantSync> products}) {
    // TODO: implement pushVariations
  }
}
