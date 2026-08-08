import 'package:flipper_models/DatabaseSyncInterface.dart';

/// Historically the app could run against either database:
///   * [Strategy.capella]  — Ditto (Capella) documents
///   * [Strategy.cloudSync] — Brick/SQLite + Supabase offline-first
///
/// The app is now **Ditto-only**. [Strategy] is kept so the ~530 existing
/// `getStrategy(Strategy.capella)` call sites keep compiling, but every lookup
/// resolves to Capella. Selecting the Brick path is no longer possible.
enum Strategy { capella, cloudSync }

class SyncStrategy {
  final DatabaseSyncInterface capella;

  /// Legacy Brick/SQLite implementation. It is **not** selectable as a
  /// strategy anymore — it is only reachable through [legacy], which
  /// [CapellaSync] uses as a fallback for the surface that has not been ported
  /// to Ditto yet. Every use is tagged `TODO(ditto-migration)`.
  final DatabaseSyncInterface cloudSync;

  SyncStrategy({required this.capella, required this.cloudSync});

  /// The one and only database the app talks to.
  DatabaseSyncInterface get current => capella;

  /// Always Capella/Ditto, whatever is asked for.
  DatabaseSyncInterface getStrategy(Strategy? strategy) => capella;

  /// No-op. Kept so existing callers (e.g. `cron_service`) compile; the
  /// database can no longer be switched at runtime.
  void setStrategy(Strategy strategy) {}

  /// Escape hatch for not-yet-ported operations. Do not use in new code.
  DatabaseSyncInterface get legacy => cloudSync;
}
