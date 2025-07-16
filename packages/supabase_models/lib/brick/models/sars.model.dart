import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'sars'),
)
class Sar extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  @Sqlite(index: true)
  int sarNo;

  @Sqlite(index: true)
  final int branchId;

  @Sqlite(index: true)
  final DateTime createdAt;

  Sar({
    String? id,
    required this.sarNo,
    required this.branchId,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toUtc();
  // copyWith method
  Sar copyWith({
    String? id,
    int? sarNo,
    int? branchId,
    DateTime? createdAt,
  }) {
    return Sar(
      id: id ?? this.id,
      sarNo: sarNo ?? this.sarNo,
      branchId: branchId ?? this.branchId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFlipperJson() {
    return {
      'id': id,
      'sarNo': sarNo,
      'branchId': branchId,
      'createdAt': createdAt,
    };
  }
}
