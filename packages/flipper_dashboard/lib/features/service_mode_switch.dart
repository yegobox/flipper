import 'package:flutter/foundation.dart';

/// Bumped whenever a service-mode master toggle (Bar / Hotel) flips.
///
/// The two admin sections are sibling [State]s, so one turning the other off
/// would otherwise leave a stale "ON" badge on the sibling card until the
/// admin screen was reopened. Each section listens and re-reads its cache.
final ValueNotifier<int> serviceModeRevision = ValueNotifier<int>(0);

void notifyServiceModeChanged() => serviceModeRevision.value++;
