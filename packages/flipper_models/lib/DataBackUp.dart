import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

abstract class CoreData {
  Future<void> save<T>({required T data});
  Future<void> retriveAll<T>({required T data});
}

class DataBackUp implements CoreData {
  static final DataBackUp _instance = DataBackUp._internal();
  factory DataBackUp() => _instance;
  DataBackUp._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> retriveAll<T>({required T data}) {
    // TODO: implement retriveAll
    throw UnimplementedError();
  }

  @override
  Future<void> save<T>({required T data}) async {
    if (data is TransactionItem) {
      final transactionItem = data as TransactionItem;
      final json = jsonEncode(transactionItem.toEJson().convertRealmValues());
      final Map<String, dynamic> dataMap = jsonDecode(json);

      // Check if the document already exists
      final docRef = _firestore
          .collection('transactionsItems')
          .doc(transactionItem.id.toString());
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        talker.warning("UpdatedFirestore");
        // Update existing document
        await docRef.update(dataMap);
      } else {
        talker.warning("created");
        // Create new document
        await docRef.set(dataMap);
      }
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }
}
