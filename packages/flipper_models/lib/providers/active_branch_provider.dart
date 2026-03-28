import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'active_branch_provider.g.dart';

Branch _placeholderNoBranch() => Branch(
      id: '',
      name: 'No branch',
      businessId: '',
      isDefault: false,
    );

bool _branchIdentityChanged(Branch? a, Branch b) {
  if (a == null) return true;
  return a.id != b.id ||
      a.name != b.name ||
      a.businessId != b.businessId;
}

@riverpod
Stream<Branch> activeBranch(Ref ref) async* {
  Branch? lastYielded;
  String? trackedBranchId;

  while (true) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      final placeholder = _placeholderNoBranch();
      if (_branchIdentityChanged(lastYielded, placeholder)) {
        lastYielded = placeholder;
        trackedBranchId = null;
        yield placeholder;
      }
      await Future.delayed(const Duration(seconds: 1));
      continue;
    }

    if (trackedBranchId != branchId) {
      trackedBranchId = branchId;
      lastYielded = null;
    }

    try {
      final branch = await ProxyService.strategy.activeBranch(
        branchId: branchId,
      );
      if (_branchIdentityChanged(lastYielded, branch)) {
        lastYielded = branch;
        yield branch;
      }
    } catch (error, stackTrace) {
      print('Error fetching active branch: $error');
      print('Stack trace: $stackTrace');

      final fallback = Branch(
        id: branchId,
        name: 'Branch',
        businessId: '',
        isDefault: false,
      );
      if (_branchIdentityChanged(lastYielded, fallback)) {
        lastYielded = fallback;
        yield fallback;
      }
    }

    await Future.delayed(const Duration(seconds: 30));
  }
}
