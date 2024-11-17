// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/plan_addon.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/transactionItem.model.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../brick/models/counter.model.dart';
import '../brick/models/branch.model.dart';
import '../brick/models/plans.model.dart';
import '../brick/models/plan_addon.model.dart';
import '../brick/models/transactionItem.model.dart';
import '../brick/models/stockRequest.model.dart';
import '../brick/models/ebm.model.dart';

part 'adapters/counter_adapter.g.dart';
part 'adapters/branch_adapter.g.dart';
part 'adapters/plan_adapter.g.dart';
part 'adapters/plan_addon_adapter.g.dart';
part 'adapters/transaction_item_adapter.g.dart';
part 'adapters/stock_request_adapter.g.dart';
part 'adapters/ebm_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  Counter: CounterAdapter(),
  Branch: BranchAdapter(),
  Plan: PlanAdapter(),
  PlanAddon: PlanAddonAdapter(),
  TransactionItem: TransactionItemAdapter(),
  StockRequest: StockRequestAdapter(),
  Ebm: EbmAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  Counter: CounterAdapter(),
  Branch: BranchAdapter(),
  Plan: PlanAdapter(),
  PlanAddon: PlanAddonAdapter(),
  TransactionItem: TransactionItemAdapter(),
  StockRequest: StockRequestAdapter(),
  Ebm: EbmAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
