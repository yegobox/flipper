import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' show calloc;

typedef _QueryUnbiasedInterruptTimeC =
    ffi.Int32 Function(ffi.Pointer<ffi.Uint64>);
typedef _QueryUnbiasedInterruptTime = int Function(ffi.Pointer<ffi.Uint64>);

/// `QueryUnbiasedInterruptTime` from kernel32, or null when it can't be read
/// (the watchdog then falls back to `Stopwatch`).
int Function()? windowsUnbiasedTicks() {
  try {
    final query = ffi.DynamicLibrary.open('kernel32.dll')
        .lookupFunction<
          _QueryUnbiasedInterruptTimeC,
          _QueryUnbiasedInterruptTime
        >('QueryUnbiasedInterruptTime');
    // One 8-byte slot for the life of the app; never freed.
    final out = calloc<ffi.Uint64>();
    int read() => query(out) == 0 ? 0 : out.value;
    if (read() == 0) return null;
    return read;
  } catch (_) {
    return null;
  }
}
