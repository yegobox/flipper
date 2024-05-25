import 'dart:io';

import 'package:flipper_models/LocalRealm.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_services/proxy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

extension StringToIntList on String {
  List<int> toIntList() {
    return this.split(',').map((e) => int.parse(e.trim())).toList();
  }
}

class LocalRealmApi extends RealmAPI implements LocalRealmInterface {
  final talker = TalkerFlutter.init();
  @override
  Realm? rea;

  @override
  Future<LocalRealmInterface> configureLocal({required bool inTesting}) async {
    talker.warning("Opening local realm alongside the synced one!");
    String path = await dbPath();
    Configuration config;

    /// While experimenting the local db alongside synced one, I realized that there is some unknown issues.
    try {
      config = Configuration.local([UserActivity.schema],
          path: path,
          encryptionKey: ProxyService.box.encryptionKey().toIntList());
      rea = Realm(config);
    } catch (e) {
      config = Configuration.inMemory(
        [UserActivity.schema],
        path: path,
        // encryptionKey: ProxyService.box.encryptionKey().toIntList(),
      );
    }
    return this;
  }

  @override
  bool isRealmClosed() {
    return rea?.isClosed ?? true;
  }

  @override
  Future<List<UserActivity>> activities({required int userId}) async {
    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end of the current day
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    return rea!.query<UserActivity>(
        r'lastTouched BETWEEN {$0,$1} ', [startOfDay, endOfDay]).toList();
  }

  Future<bool> hasNoActivityInLast5Minutes(
      {required int userId, int? refreshRate = 5}) async {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time [timer] minutes ago
    DateTime fiveMinutesAgo =
        currentTime.subtract(Duration(minutes: refreshRate!));

    // Retrieve the user activities
    List<UserActivity> userActivities = await activities(userId: userId);

    // Assume no activity in the last 5 minutes by default
    bool returnValue = true;

    for (var activity in userActivities) {
      if (activity.lastTouched!.isAfter(fiveMinutesAgo)) {
        // The user has done an activity within the last 5 minutes
        returnValue = false;
        break; // No need to continue checking, we found an activity
      }
    }
    return returnValue;
  }

  @override
  Future<void> refreshSession(
      {required int branchId, int? refreshRate = 5}) async {
    while (true) {
      try {
        int userId = ProxyService.box.getUserId()!;
        bool noActivity = await hasNoActivityInLast5Minutes(
            userId: userId, refreshRate: refreshRate);
        talker.warning(noActivity.toString());

        if (noActivity) {
          Tenant? tenant =
              await getTenantBYUserId(userId: ProxyService.box.getUserId()!);
          ProxyService.realm.realm!
              .writeAsync(() => tenant!.sessionActive = false);
        }
      } catch (error) {
        print('Error fetching tenant: $error');
      }
      await Future.delayed(Duration(minutes: refreshRate!));
    }
  }

  @override
  Future<String> dbPath() async {
    String fileName = "db_";
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final int businessId = ProxyService.box.getBusinessId() ?? 0;
    final int branchId = ProxyService.box.getBranchId() ?? 0;
    final realmDirectory = '${appDocsDirectory.path}/flipper-v4-local-' +
        branchId.toString() +
        "_" +
        businessId.toString();

    // Create the new directory
    await Directory(realmDirectory).create(recursive: true);

    return "$realmDirectory/$fileName";
  }
}
