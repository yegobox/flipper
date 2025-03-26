import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'category_provider.g.dart';

@riverpod
Stream<List<Category>> category(Ref ref) {
  return ProxyService.strategy.categoryStream();
}

@riverpod
Future<List<Category>> categories(Ref ref, {required int branchId}) async {
  return await ProxyService.strategy.categories(branchId: branchId);
}
