import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';

const String _kPersonalGoalContributionDeviceKey =
    'personal_goal_contribution_device_key_v1';

/// Per-install stable id written to each goal credit on this device so peers
/// can show "remote contribution" notifications without echoing locally.
Future<String> personalGoalContributionDeviceKey() async {
  final existing =
      ProxyService.box.readString(key: _kPersonalGoalContributionDeviceKey);
  if (existing != null && existing.isNotEmpty) {
    return existing;
  }
  final id = const Uuid().v4();
  await ProxyService.box.writeString(
    key: _kPersonalGoalContributionDeviceKey,
    value: id,
  );
  return id;
}
