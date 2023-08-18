library flipper_models;

import 'package:isar/isar.dart';

// part 'userActivity.g.dart';

@Collection()
class UserActivity {
  int id;
  DateTime timestamp;

  UserActivity(this.id, this.timestamp);
}
