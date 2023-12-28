import 'dart:io' as io;
import 'dart:math' as math;

import 'process_unique.dart';

/// IO Process unique implementation
class ProcessUniqueIo implements ProcessUnique {
  /// 5 bytes
  @override
  int getValue() {
    var value = 0;

    /// Get's process unique by combination of timestamp, and process pid
    final random =
        math.Random((DateTime.now().millisecondsSinceEpoch ^ io.pid));

    for (var i = 0; i < 10; i++) {
      value += random.nextInt(256) * math.pow(16, i).toInt();
    }

    return value;
  }
}

/// Process unique io factory method
ProcessUnique getProcessUnique() => ProcessUniqueIo();
