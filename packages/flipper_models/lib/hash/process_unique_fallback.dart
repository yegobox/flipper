import 'dart:math' as math;

import 'package:flipper_models/hash/process_unique.dart';

/// Fallback Process unique implementation
class FallbackProcessUnique implements ProcessUnique {
  @override
  int getValue() {
    var value = 0;

    math.Random random;
    try {
      random = math.Random.secure();
      // ignore: avoid_catching_errors
    } on UnsupportedError {
      random = math.Random();
    }

    for (var i = 0; i < 10; i++) {
      value += random.nextInt(256) * math.pow(16, i).toInt();
    }

    return value;
  }
}

/// Process unique fallback factory method
ProcessUnique getProcessUnique() => FallbackProcessUnique();
