import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/personal_goal.dart';

mixin CorePersonalGoalsStubMixin {
  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId}) {
    talker.warning(
      'Personal goals are available on Capella only; returning empty list.',
    );
    return Stream.value(<PersonalGoal>[]);
  }

  Future<void> upsertPersonalGoal(PersonalGoal goal) async {
    talker.warning('Personal goals: Capella only — upsert ignored (CoreSync).');
  }

  Future<void> deletePersonalGoal({
    required String id,
    required String branchId,
  }) async {
    talker.warning('Personal goals: Capella only — delete ignored (CoreSync).');
  }

  Future<void> addToGoalSavedAmount({
    required String goalId,
    required String branchId,
    required double amount,
    String? transactionId,
    bool enforceTargetCap = false,
  }) async {
    talker.warning(
      'Personal goals: Capella only — addToGoalSavedAmount ignored (CoreSync).',
    );
  }
}
