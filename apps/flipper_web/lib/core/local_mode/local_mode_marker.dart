// Web + WASM have no dart:io, and local mode is native-only.
export 'local_mode_marker_web.dart'
    if (dart.library.io) 'local_mode_marker_io.dart';
export 'local_mode_marker_keys.dart';
