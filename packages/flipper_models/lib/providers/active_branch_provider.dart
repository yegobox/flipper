import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flipper_models/SyncStrategy.dart';
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
  // A previous attempt that timed out but is still running in the
  // background (Future.timeout races a timer, it never cancels the
  // original call). Re-awaited on the next loop turn instead of starting
  // a duplicate query, so a hung lookup can't pile up concurrent calls.
  Future<Branch>? pendingFetch;

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
      pendingFetch = null;
    }

    pendingFetch ??=
        ProxyService.getStrategy(Strategy.capella).activeBranch(
      branchId: branchId,
    );

    try {
      final branch = await pendingFetch.timeout(const Duration(seconds: 5));
      pendingFetch = null;
      if (_branchIdentityChanged(lastYielded, branch)) {
        lastYielded = branch;
        yield branch;
      }
    } catch (error, stackTrace) {
      if (error is! TimeoutException) {
        // The original call itself failed, so clear it before propagating.
        // On a plain TimeoutException, pendingFetch is still running and is
        // kept so the next turn re-awaits it instead.
        pendingFetch = null;
        rethrow;
      }

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
