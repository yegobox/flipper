import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/all_models.dart';

part 'business_analytic_provider.g.dart';

@riverpod
Future<List<BusinessAnalytic>> fetchStockPerformance(
    Ref ref, int branchId) async {
  final capella = await ProxyService.getStrategy(Strategy.capella);
  return await capella.analytics(branchId: branchId);
}
