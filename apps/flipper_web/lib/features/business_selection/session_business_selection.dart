import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Set when the user explicitly picks a branch on the login-choices screen.
/// Restore must not overwrite an in-session choice.
final sessionBranchChoiceLockedProvider = StateProvider<bool>((ref) => false);

/// Clears in-memory business/branch (e.g. on sign-in or sign-out).
void clearSessionBusinessSelection(dynamic ref) {
  ref.read(selectedBusinessProvider.notifier).set(null);
  ref.read(selectedBranchProvider.notifier).set(null);
  ref.read(sessionBranchChoiceLockedProvider.notifier).state = false;
  debugPrint('[Business] cleared in-memory business/branch selection');
}

/// Marks that the user explicitly chose a branch this session.
void lockSessionBranchChoice(dynamic ref) {
  ref.read(sessionBranchChoiceLockedProvider.notifier).state = true;
}
