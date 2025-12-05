import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/db_model_export.dart';
// ignore: unused_import
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';

part 'import_purchase_dates_provider.g.dart';

/// Provider to fetch the last import/purchase date for a given branch and request type
@riverpod
Future<DateTime?> importPurchaseDates(
  Ref ref, {
  required String branchId,
  required String requestType,
}) async {
  final repository = Repository();

  final lastRequestRecords = await repository.get<ImportPurchaseDates>(
    policy: brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    query: brick.Query(
      limit: 1,
      orderBy: [const OrderBy('lastRequestDate', ascending: false)],
      where: [
        brick.Where('branchId').isExactly(branchId),
        brick.Where('requestType').isExactly(requestType),
      ],
    ),
  );

  final lastReqDt = lastRequestRecords.firstOrNull?.lastRequestDate;

  if (lastReqDt == null) {
    return null;
  }

  // Parse the date string (format: yyyyMMddHHmmss) to DateTime
  try {
    final year = int.parse(lastReqDt.substring(0, 4));
    final month = int.parse(lastReqDt.substring(4, 6));
    final day = int.parse(lastReqDt.substring(6, 8));
    final hour = int.parse(lastReqDt.substring(8, 10));
    final minute = int.parse(lastReqDt.substring(10, 12));
    final second = int.parse(lastReqDt.substring(12, 14));

    return DateTime(year, month, day, hour, minute, second);
  } catch (e) {
    // If parsing fails, return null
    return null;
  }
}
