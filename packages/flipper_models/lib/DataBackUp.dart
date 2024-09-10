import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';

abstract class CoreData {
  void save<T>({required T data});
  void retriveAll<T>({required T data});
}

class DataBackUp implements CoreData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void retriveAll<T>({required T data}) {
    // TODO: implement retriveAll
  }

  @override
  Future<void> save<T>({required T data}) async {
    if (T is TransactionItem) {
      final transactionItem = data as TransactionItem;
      final json = jsonEncode(transactionItem.toEJson().convertRealmValues());
      final Map<String, dynamic> dataMap = jsonDecode(json);

      // Check if the document already exists
      final docRef = _firestore
          .collection('transactionsItems')
          .doc(transactionItem.id.toString());
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        await docRef.update(dataMap);
      } else {
        // Create new document
        await docRef.set(dataMap);
      }
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }
}
