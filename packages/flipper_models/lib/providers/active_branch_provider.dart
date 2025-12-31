import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'active_branch_provider.g.dart';

@riverpod
Stream<Branch> activeBranch(Ref ref) {
  return ProxyService.strategy
      .activeBranchStream(businessId: ProxyService.box.getBusinessId()!);
}
