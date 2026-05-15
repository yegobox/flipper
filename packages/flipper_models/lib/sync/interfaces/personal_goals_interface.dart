import 'dart:async';

import 'package:flipper_models/models/personal_goal.dart';

/// Personal / business savings goals (Capella + Ditto implementation).
abstract class PersonalGoalsInterface {
  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId});

  Future<void> upsertPersonalGoal(PersonalGoal goal);

  Future<void> deletePersonalGoal({required String id, required String branchId});

  Future<void> addToGoalSavedAmount({
    required String goalId,
    required String branchId,
    required double amount,
    String? transactionId,
    bool enforceTargetCap = false,
  });
}
