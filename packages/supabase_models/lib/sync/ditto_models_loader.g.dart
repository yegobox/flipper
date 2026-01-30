// GENERATED CODE - DO NOT MODIFY BY HAND
// This file ensures all Ditto adapters are loaded at startup.

// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:supabase_models/brick/models/actual_output.model.dart' as actual_output_model;
import 'package:supabase_models/brick/models/branch.model.dart' as branch_model;
import 'package:supabase_models/brick/models/business.model.dart' as business_model;
import 'package:supabase_models/brick/models/business_analytic.model.dart' as business_analytic_model;
import 'package:supabase_models/brick/models/counter.model.dart' as counter_model;
import 'package:supabase_models/brick/models/customer.model.dart' as customer_model;
import 'package:supabase_models/brick/models/device.model.dart' as device_model;
import 'package:supabase_models/brick/models/ebm.model.dart' as ebm_model;
import 'package:supabase_models/brick/models/itemCode.model.dart' as itemCode_model;
import 'package:supabase_models/brick/models/message.model.dart' as message_model;
import 'package:supabase_models/brick/models/plans.model.dart' as plans_model;
import 'package:supabase_models/brick/models/stock.model.dart' as stock_model;
import 'package:supabase_models/brick/models/stock_recount.model.dart' as stock_recount_model;
import 'package:supabase_models/brick/models/stock_recount_item.model.dart' as stock_recount_item_model;
import 'package:supabase_models/brick/models/transaction.model.dart' as transaction_model;
import 'package:supabase_models/brick/models/transactionItem.model.dart' as transactionItem_model;
import 'package:supabase_models/brick/models/transaction_delegation.model.dart' as transaction_delegation_model;
import 'package:supabase_models/brick/models/transaction_payment_record.model.dart' as transaction_payment_record_model;
import 'package:supabase_models/brick/models/variant.model.dart' as variant_model;
import 'package:supabase_models/brick/models/work_order.model.dart' as work_order_model;

/// Forces all Ditto adapter static initializers to run.
/// Call this before using DittoSyncRegistry.
void ensureDittoAdaptersLoaded() {
  // Access registryToken getter to force static field init
  actual_output_model.ActualOutputDittoAdapter.registryToken; // ignore: unnecessary_statements
  branch_model.BranchDittoAdapter.registryToken; // ignore: unnecessary_statements
  business_model.BusinessDittoAdapter.registryToken; // ignore: unnecessary_statements
  business_analytic_model.BusinessAnalyticDittoAdapter.registryToken; // ignore: unnecessary_statements
  counter_model.CounterDittoAdapter.registryToken; // ignore: unnecessary_statements
  customer_model.CustomerDittoAdapter.registryToken; // ignore: unnecessary_statements
  device_model.DeviceDittoAdapter.registryToken; // ignore: unnecessary_statements
  ebm_model.EbmDittoAdapter.registryToken; // ignore: unnecessary_statements
  itemCode_model.ItemCodeDittoAdapter.registryToken; // ignore: unnecessary_statements
  message_model.MessageDittoAdapter.registryToken; // ignore: unnecessary_statements
  plans_model.PlanDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_model.StockDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_recount_model.StockRecountDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_recount_item_model.StockRecountItemDittoAdapter.registryToken; // ignore: unnecessary_statements
  transaction_model.ITransactionDittoAdapter.registryToken; // ignore: unnecessary_statements
  transactionItem_model.TransactionItemDittoAdapter.registryToken; // ignore: unnecessary_statements
  transaction_delegation_model.TransactionDelegationDittoAdapter.registryToken; // ignore: unnecessary_statements
  transaction_payment_record_model.TransactionPaymentRecordDittoAdapter.registryToken; // ignore: unnecessary_statements
  variant_model.VariantDittoAdapter.registryToken; // ignore: unnecessary_statements
  work_order_model.WorkOrderDittoAdapter.registryToken; // ignore: unnecessary_statements
}
