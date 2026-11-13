/// Moved to `package:brick_ditto/ditto_sync_adapter.dart`.
///
/// The annotation types are needed at runtime by every model, so they live in
/// the runtime package `brick_ditto`; this generator package (which pins
/// `analyzer`) is a dev dependency only. Kept as a re-export so existing
/// imports keep compiling.
library;

export 'package:brick_ditto/ditto_sync_adapter.dart';
