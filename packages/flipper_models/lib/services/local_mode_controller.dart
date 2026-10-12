import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/internet_probe.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:supabase_models/brick/repository.dart';

/// Moves this device in and out of [LocalMode], keeping the other cloud
/// writers in step with the flag.
class LocalModeController {
  LocalModeController._();

  /// Signup chose local mode. Runs before `strategy.signup`, so the login it
  /// performs opens Ditto local-only. The Supabase queue already started at
  /// boot, so it is stopped here.
  static Future<void> enterForSignup() async {
    await LocalMode.enable();
    Repository.pauseCloudSync();
    talker.info('Local mode: on (signup)');
  }

  /// Records which business chose local mode, once signup knows it.
  static Future<void> recordBusiness(String businessId) async {
    if (!LocalMode.isOn) return;
    await LocalMode.enable(businessId: businessId);
  }

  /// A failed signup must not leave the device local.
  static Future<void> abortSignup() async {
    if (!LocalMode.isOn) return;
    await LocalMode.disable();
    Repository.resumeCloudSync();
    talker.info('Local mode: rolled back after failed signup');
  }

  /// Opts this device in to full sync. One-way. Returns false when there is
  /// no internet, since the next login needs the server.
  ///
  /// The caller then logs the user out: the next login reopens the same Ditto
  /// store with the cloud connect (its documents upload), and startup's
  /// payment check shows the plan picker like any new business.
  static Future<bool> optInToSync() async {
    if (!LocalMode.isOn) return true;
    if (!await InternetProbe.isOnline()) return false;
    await LocalMode.disable();
    Repository.resumeCloudSync();
    talker.info('Local mode: off (opted in to sync)');
    return true;
  }
}
