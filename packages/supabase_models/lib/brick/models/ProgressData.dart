class ProgressData {
  final String progress;
  final int currentItem;
  final int totalItems;

  ProgressData({
    required this.progress,
    required this.currentItem,
    required this.totalItems,
  });

  /// For large totals, [currentItem]/[totalItems] stays under 1% for a long time — avoid showing
  /// `"0%"` when work is clearly progressing (e.g. bulk RRA at 18/5841).
  static String formatPercent(int current, int total) {
    if (total <= 0 || current <= 0) return '0%';
    final p = 100.0 * current / total;
    if (p < 1) return '${p.toStringAsFixed(2)}%';
    if (p < 10) return '${p.toStringAsFixed(1)}%';
    return '${p.toStringAsFixed(0)}%';
  }
}
