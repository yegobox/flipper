import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'active_branch_provider.g.dart';

@riverpod
Stream<Branch> activeBranch(Ref ref) async* {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) {
    // Return empty stream if no branch ID is set
    yield Branch(id: '', name: 'No branch', businessId: '', isDefault: false);
    return;
  }

  Branch? lastYielded;

  while (true) {
    try {
      final branch = await ProxyService.strategy.activeBranch(
        branchId: branchId,
      );
      if (lastYielded?.id != branch.id || lastYielded?.name != branch.name) {
        lastYielded = branch;
        yield branch;
      }
    } catch (error, stackTrace) {
      // Log error but don't crash
      print('Error fetching active branch: $error');
      print('Stack trace: $stackTrace');
      
      final fallback = Branch(
        id: branchId,
        name: 'Branch',
        businessId: '',
        isDefault: false,
      );
      if (lastYielded?.id != fallback.id || lastYielded?.name != fallback.name) {
        lastYielded = fallback;
        yield fallback;
      }
    }
    
    await Future.delayed(const Duration(seconds: 30));
  }
}
