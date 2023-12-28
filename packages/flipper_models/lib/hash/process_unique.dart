import './process_unique_fallback.dart'
    if (dart.library.html) './process_unique_web.dart'
    if (dart.library.io) './process_unique_io.dart';

/// Process unique astract class
abstract class ProcessUnique {
  /// Get process unique random value
  int getValue();

  /// Get process implementation based on platform
  factory ProcessUnique() => getProcessUnique();
}
