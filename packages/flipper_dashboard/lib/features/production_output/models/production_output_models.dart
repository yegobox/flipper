import 'package:flipper_localize/flipper_localize.dart';

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

  /// English label; for display use [localizedLabel].
  final String label;

  /// English description; for display use [localizedDescription].
  final String description;

  /// Looks up a category by its stored wire value (the enum [name]).
  static VarianceReasonCategory? tryParse(String? value) {
    final v = value?.toLowerCase();
    for (final c in values) {
      if (c.name == v) return c;
    }
    return null;
  }

  String localizedLabel(FlipperAppLocalizations l10n) {
    switch (this) {
      case VarianceReasonCategory.machine:
        return l10n.productionOutputReasonMachine;
      case VarianceReasonCategory.material:
        return l10n.productionOutputReasonMaterial;
      case VarianceReasonCategory.labor:
        return l10n.productionOutputReasonLabor;
      case VarianceReasonCategory.quality:
        return l10n.productionOutputReasonQuality;
      case VarianceReasonCategory.planning:
        return l10n.productionOutputReasonPlanning;
      case VarianceReasonCategory.other:
        return l10n.productionOutputReasonOther;
    }
  }

  String localizedDescription(FlipperAppLocalizations l10n) {
    switch (this) {
      case VarianceReasonCategory.machine:
        return l10n.productionOutputReasonMachineDesc;
      case VarianceReasonCategory.material:
        return l10n.productionOutputReasonMaterialDesc;
      case VarianceReasonCategory.labor:
        return l10n.productionOutputReasonLaborDesc;
      case VarianceReasonCategory.quality:
        return l10n.productionOutputReasonQualityDesc;
      case VarianceReasonCategory.planning:
        return l10n.productionOutputReasonPlanningDesc;
      case VarianceReasonCategory.other:
        return l10n.productionOutputReasonOtherDesc;
    }
  }
}

/// Work order status for display
enum WorkOrderStatus {
  planned('Planned', 0xFF0078D4),
  inProgress('In Progress', 0xFFFFB900),
  completed('Completed', 0xFF107C10),
  cancelled('Cancelled', 0xFF797775);

  const WorkOrderStatus(this.label, this.color);

  /// English label; for display use [localizedLabel].
  final String label;
  final int color;

  String localizedLabel(FlipperAppLocalizations l10n) {
    switch (this) {
      case WorkOrderStatus.planned:
        return l10n.productionOutputStatusPlanned;
      case WorkOrderStatus.inProgress:
        return l10n.productionOutputStatusInProgress;
      case WorkOrderStatus.completed:
        return l10n.productionOutputStatusCompleted;
      case WorkOrderStatus.cancelled:
        return l10n.productionOutputStatusCancelled;
    }
  }

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

  /// Display text for [efficiencyRating].
  String localizedEfficiencyRating(FlipperAppLocalizations l10n) {
    if (efficiency >= 100) return l10n.productionOutputRatingExcellent;
    if (efficiency >= 90) return l10n.productionOutputRatingGood;
    if (efficiency >= 75) return l10n.productionOutputRatingFair;
    return l10n.productionOutputRatingPoor;
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
