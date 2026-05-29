import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Branch-scoped Ditto catalogue of server-generated daily transaction XLSX files.
final dailyReportFilesProvider =
    StreamProvider.autoDispose.family<List<DailyReportFile>, String>(
      (ref, branchId) {
        if (branchId.isEmpty) {
          return Stream.value(const <DailyReportFile>[]);
        }
        // Daily report files live in Ditto; CoreSync doesn't implement this yet,
        // so we always read via the Capella/Ditto strategy.
        return ProxyService.getStrategy(Strategy.capella).dailyReportFilesStream(
          branchId: branchId,
        );
      },
    );
