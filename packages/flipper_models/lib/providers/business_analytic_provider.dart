import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/all_models.dart';

part 'business_analytic_provider.g.dart';

@riverpod
Future<List<BusinessAnalytic>> fetchStockPerformance(
    Ref ref, int branchId) async {
  return await ProxyService.strategy.analytics(branchId: branchId);
}
