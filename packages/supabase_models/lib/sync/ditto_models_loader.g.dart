// GENERATED CODE - DO NOT MODIFY BY HAND
// This file ensures all Ditto adapters are loaded at startup.

// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:supabase_models/brick/models/itemCode.model.dart' as itemCode_model;
import 'package:supabase_models/brick/models/stock.model.dart' as stock_model;
import 'package:supabase_models/brick/models/counter.model.dart' as counter_model;
import 'package:supabase_models/brick/models/stock_recount.model.dart' as stock_recount_model;
import 'package:supabase_models/brick/models/business_analytic.model.dart' as business_analytic_model;
import 'package:supabase_models/brick/models/transaction.model.dart' as transaction_model;
import 'package:supabase_models/brick/models/message.model.dart' as message_model;
import 'package:supabase_models/brick/models/transactionItem.model.dart' as transactionItem_model;
import 'package:supabase_models/brick/models/transaction_delegation.model.dart' as transaction_delegation_model;
import 'package:supabase_models/brick/models/variant.model.dart' as variant_model;
import 'package:supabase_models/brick/models/device.model.dart' as device_model;
import 'package:supabase_models/brick/models/stock_recount_item.model.dart' as stock_recount_item_model;
import 'package:supabase_models/brick/models/plans.model.dart' as plans_model;

/// Forces all Ditto adapter static initializers to run.
/// Call this before using DittoSyncRegistry.
void ensureDittoAdaptersLoaded() {
  // Access registryToken getter to force static field init
  itemCode_model.ItemCodeDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_model.StockDittoAdapter.registryToken; // ignore: unnecessary_statements
  counter_model.CounterDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_recount_model.StockRecountDittoAdapter.registryToken; // ignore: unnecessary_statements
  business_analytic_model.BusinessAnalyticDittoAdapter.registryToken; // ignore: unnecessary_statements
  transaction_model.ITransactionDittoAdapter.registryToken; // ignore: unnecessary_statements
  message_model.MessageDittoAdapter.registryToken; // ignore: unnecessary_statements
  transactionItem_model.TransactionItemDittoAdapter.registryToken; // ignore: unnecessary_statements
  transaction_delegation_model.TransactionDelegationDittoAdapter.registryToken; // ignore: unnecessary_statements
  variant_model.VariantDittoAdapter.registryToken; // ignore: unnecessary_statements
  device_model.DeviceDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_recount_item_model.StockRecountItemDittoAdapter.registryToken; // ignore: unnecessary_statements
  plans_model.PlanDittoAdapter.registryToken; // ignore: unnecessary_statements
}
