import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realm/realmCounter.dart';
import 'package:flipper_models/realm/realmCustomer.dart';
import 'package:flipper_models/realm/realmReceipt.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/realm/realmIUnit.dart';
import 'package:flipper_models/realm/realmProduct.dart';
import 'package:flipper_models/realm/realmVariant.dart';
import 'package:flipper_models/realm/realmStock.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';

final realmModels = [
  RealmITransaction.schema,
  RealmITransactionItem.schema,
  RealmProduct.schema,
  RealmVariant.schema,
  RealmStock.schema,
  RealmIUnit.schema,
  RealmReceipt.schema,
  RealmCustomer.schema,
  RealmCounter.schema,
  RealmBranch.schema,
];
