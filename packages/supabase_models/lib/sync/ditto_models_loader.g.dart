// GENERATED CODE - DO NOT MODIFY BY HAND
// This file ensures all Ditto adapters are loaded at startup.

// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:supabase_models/brick/models/itemCode.model.dart' as itemCode_model;
import 'package:supabase_models/brick/models/counter.model.dart' as counter_model;
import 'package:supabase_models/brick/models/stock_recount.model.dart' as stock_recount_model;
import 'package:supabase_models/brick/models/stock_recount_item.model.dart' as stock_recount_item_model;

/// Forces all Ditto adapter static initializers to run.
/// Call this before using DittoSyncRegistry.
void ensureDittoAdaptersLoaded() {
  // Access registryToken getter to force static field init
  itemCode_model.ItemCodeDittoAdapter.registryToken; // ignore: unnecessary_statements
  counter_model.CounterDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_recount_model.StockRecountDittoAdapter.registryToken; // ignore: unnecessary_statements
  stock_recount_item_model.StockRecountItemDittoAdapter.registryToken; // ignore: unnecessary_statements
}
