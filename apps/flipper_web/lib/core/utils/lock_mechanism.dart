// Web + WASM have no dart:io; default to the web no-op lock (see platform.dart).
export 'lock_mechanism_web.dart'
    if (dart.library.io) 'lock_mechanism_io.dart';
