import 'package:flipper_models/models/personal_goal.dart';

/// In-memory goals per branch so payment-time auto-sweep can run before Ditto
/// replication finishes (same session as the Personal Goals UI / upserts).
class PersonalGoalsBranchCache {
  PersonalGoalsBranchCache._();

  static final Map<String, List<PersonalGoal>> _byBranch = {};

  static List<PersonalGoal>? goalsForBranch(String branchId) {
    if (branchId.isEmpty) return null;
    final list = _byBranch[branchId];
    if (list == null || list.isEmpty) return null;
    return List<PersonalGoal>.unmodifiable(list);
  }

  static void putBranchGoals(String branchId, List<PersonalGoal> goals) {
    if (branchId.isEmpty) return;
    _byBranch[branchId] = List<PersonalGoal>.from(goals);
  }

  static void upsertGoal(PersonalGoal goal) {
    if (goal.branchId.isEmpty) return;
    final list = List<PersonalGoal>.from(_byBranch[goal.branchId] ?? []);
    final i = list.indexWhere((g) => g.id == goal.id);
    if (i >= 0) {
      list[i] = goal;
    } else {
      list.add(goal);
    }
    _byBranch[goal.branchId] = list;
  }

  static void removeGoal({required String branchId, required String goalId}) {
    final list = _byBranch[branchId];
    if (list == null) return;
    list.removeWhere((g) => g.id == goalId);
    if (list.isEmpty) {
      _byBranch.remove(branchId);
    }
  }

  static void clearBranch(String branchId) => _byBranch.remove(branchId);
}
