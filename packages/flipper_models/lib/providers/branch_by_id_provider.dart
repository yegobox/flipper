import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_by_id_provider.g.dart';

@riverpod
Stream<Branch?> branchById(Ref ref, {required String? branchId}) async* {
  if (branchId == null) {
    yield null;
    return;
  }
  // We use the activeBranchStream but filter/select specifically for the requested ID if possible
  // Or simpler: we can use ProxyService.strategy.branches(businessId: ...) but that requires businessId
  // Alternatively, check if there is a direct getBranch method or stream.

  // Looking at available methods, activeBranchStream takes a branchId.
  // Let's try to leverage that, assuming it returns the branch with that ID.
  yield* ProxyService.strategy.activeBranchStream(branchId: branchId);
}
