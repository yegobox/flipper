import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseInterface {
  SupabaseClient? client;
  Future<SupabaseClient> init();
  void listenForChange(
      {required String tableName,
      required Function(Map<String, dynamic>) onChange});
}

class SupabaseImpl implements SupabaseInterface {
  SupabaseClient? client;

  @override
  Future<SupabaseClient> init() async {
    client = Supabase.instance.client;
    return client!;
  }

  @override
  void listenForChange(
      {required String tableName,
      required Function(Map<String, dynamic> p1) onChange}) {
    final supabase = Supabase.instance.client;

    supabase
        .channel(tableName)
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: tableName,
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'branch_id',
              value: ProxyService.box.getBranchId(),
            ),
            callback: (PostgresChangePayload payload) {
              final Map<String, dynamic> newRecord = payload.newRecord;
              if (newRecord['table_name'] == tableName) {
                /// first query the remote db for the object.
                /// perform change to local db
              }
            })
        .subscribe();
  }
}
