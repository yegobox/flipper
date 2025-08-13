import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/credit.model.dart';

part 'credit_provider.g.dart';

@riverpod
Stream<Credit?> creditStream(Ref ref, int branchId) {
  return ProxyService.strategy.credit(branchId: branchId.toString());
}
