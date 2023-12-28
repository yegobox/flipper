import 'dart:html' as web;
import 'dart:math' as math;

import 'process_unique.dart';

/// Web Process unique implementation
class ProcessUniqueWeb implements ProcessUnique {
  /// 5 bytes
  @override
  int getValue() {
    var value = 0;

    /// Get's process unique by combination of timestamp, hostname
    /// and random value
    final random = math.Random(DateTime.now().millisecondsSinceEpoch ^
        (web.window.location.hostname ?? "")
            .codeUnits
            .reduce((value, element) => value + element) ^
        math.Random().nextInt(0xffffff));

    for (var i = 0; i < 10; i++) {
      value += random.nextInt(256) * math.pow(16, i).toInt();
    }

    return value;
  }
}

/// Process unique web factory method
ProcessUnique getProcessUnique() => ProcessUniqueWeb();
