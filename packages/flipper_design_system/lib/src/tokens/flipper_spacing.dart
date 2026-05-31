/// Layout spacing scale (formerly `Insets` in flipper_infra).
class Insets {
  /// Dynamic insets, may get scaled with the device size.
  static double scale = 1;

  static double get xs => 2 * scale;

  static double get sm => 6 * scale;

  static double get m => 12 * scale;

  static double get l => 24 * scale;

  static double get xl => 36 * scale;

  static double get xxl => 64 * scale;

  static double get xxxl => 80 * scale;
}

/// Alias for semantic naming in new code.
typedef FlipperSpacing = Insets;
