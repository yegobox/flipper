import 'dart:async';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/repository.dart';

/// Mirror a Capella/Ditto write into Brick/Turso without blocking the caller.
///
/// Ditto is runtime truth for POS and branch transfer; Brick catches up for
/// legacy reads and the offline Supabase queue. [skipDittoSync] avoids a
/// duplicate Ditto push from [Repository.upsert].
void scheduleCapellaBrickMirror<T extends OfflineFirstWithSupabaseModel>(
  Repository repository,
  T model,
) {
  unawaited(() async {
    try {
      await repository.upsert<T>(model, skipDittoSync: true);
    } catch (e, s) {
      talker.warning(
        'Capella background Brick mirror failed for $T: $e',
        e,
        s,
      );
    }
  }());
}
