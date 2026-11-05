/// The Windows unbiased interrupt time behind [awakeClock].
///
/// `dart:ffi` only exists on native platforms; importing it unconditionally
/// broke the web builds that pull in flipper_models (flipper_web, HR), so
/// the web gets a stub and falls back to `Stopwatch`.
library;

export 'windows_unbiased_ticks_stub.dart'
    if (dart.library.ffi) 'windows_unbiased_ticks_ffi.dart';
