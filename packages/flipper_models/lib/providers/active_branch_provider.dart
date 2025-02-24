import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'active_branch_provider.g.dart';

@riverpod
Future<Branch> activeBranch(Ref ref) async {
  return await ProxyService.strategy.activeBranch();
}

