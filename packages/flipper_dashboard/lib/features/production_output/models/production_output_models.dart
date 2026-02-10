/// SAP Fiori-inspired color semantics for production output variance
class VarianceColors {
  /// Positive variance (actual >= planned) - Green
  static const positive = 0xFF107C10;

  /// Negative variance (actual < planned) - Red
  static const negative = 0xFFD83B01;

  /// Neutral/informational - Blue
  static const neutral = 0xFF0078D4;

  /// Warning threshold (90-100% efficiency)
  static const warning = 0xFFFFB900;
}

/// SAP-aligned variance reason categories
enum VarianceReasonCategory {
  machine('Machine', 'Machine downtime or malfunction'),
  material('Material', 'Material shortage or quality issues'),
  labor('Labor', 'Labor shortage or skill issues'),
  quality('Quality', 'Quality control rejection'),
  planning('Planning', 'Planning or scheduling issues'),
  other('Other', 'Other reasons');

  const VarianceReasonCategory(this.label, this.description);
  final String label;
  final String description;
}

/// Work order status for display
enum WorkOrderStatus {
  planned('Planned', 0xFF0078D4),
  inProgress('In Progress', 0xFFFFB900),
  completed('Completed', 0xFF107C10),
  cancelled('Cancelled', 0xFF797775);

  const WorkOrderStatus(this.label, this.color);
  final String label;
  final int color;

  static WorkOrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return WorkOrderStatus.inProgress;
      case 'completed':
        return WorkOrderStatus.completed;
      case 'cancelled':
        return WorkOrderStatus.cancelled;
      default:
        return WorkOrderStatus.planned;
    }
  }
}

/// Summary data for analytical cards
class ProductionSummary {
  final double totalPlanned;
  final double totalActual;
  final double variance;
  final double variancePercentage;
  final double efficiency;
  final int totalOrders;
  final int completedOrders;
  final double completionRate;
  final Map<String, double> varianceByReason;

  const ProductionSummary({
    required this.totalPlanned,
    required this.totalActual,
    required this.variance,
    required this.variancePercentage,
    required this.efficiency,
    required this.totalOrders,
    required this.completedOrders,
    required this.completionRate,
    required this.varianceByReason,
  });

  factory ProductionSummary.fromMap(Map<String, dynamic> map) {
    return ProductionSummary(
      totalPlanned: (map['totalPlanned'] as num?)?.toDouble() ?? 0,
      totalActual: (map['totalActual'] as num?)?.toDouble() ?? 0,
      variance: (map['variance'] as num?)?.toDouble() ?? 0,
      variancePercentage: (map['variancePercentage'] as num?)?.toDouble() ?? 0,
      efficiency: (map['efficiency'] as num?)?.toDouble() ?? 0,
      totalOrders: (map['totalOrders'] as num?)?.toInt() ?? 0,
      completedOrders: (map['completedOrders'] as num?)?.toInt() ?? 0,
      completionRate: (map['completionRate'] as num?)?.toDouble() ?? 0,
      varianceByReason: Map<String, double>.from(
        (map['varianceByReason'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            ) ??
            {},
      ),
    );
  }

  /// Empty summary for loading/error states
  static const empty = ProductionSummary(
    totalPlanned: 0,
    totalActual: 0,
    variance: 0,
    variancePercentage: 0,
    efficiency: 0,
    totalOrders: 0,
    completedOrders: 0,
    completionRate: 0,
    varianceByReason: {},
  );

  /// Whether variance is positive (met or exceeded targets)
  bool get isPositiveVariance => variance >= 0;

  /// SAP-style efficiency rating
  String get efficiencyRating {
    if (efficiency >= 100) return 'Excellent';
    if (efficiency >= 90) return 'Good';
    if (efficiency >= 75) return 'Fair';
    return 'Poor';
  }
}

/// Chart data point for variance visualization
class VarianceDataPoint {
  final DateTime date;
  final double planned;
  final double actual;
  final double variance;

  const VarianceDataPoint({
    required this.date,
    required this.planned,
    required this.actual,
    required this.variance,
  });

  double get variancePercentage => planned > 0 ? (variance / planned) * 100 : 0;
}
