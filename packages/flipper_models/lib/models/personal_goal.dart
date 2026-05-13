import 'dart:math';

/// Branch-scoped savings goal persisted in Ditto (`personal_goals`) for Capella.
class PersonalGoal {
  const PersonalGoal({
    required this.id,
    required this.branchId,
    required this.name,
    required this.savedAmount,
    required this.targetAmount,
    this.isTopPriority = false,
    this.autoAllocationPercent,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String branchId;
  final String name;
  final double savedAmount;
  final double targetAmount;
  final bool isTopPriority;

  /// When set (0–100), Capella credits this percent into the goal on completed flows:
  /// **product sales** use gross line profit (retail − supply); **cashbook utility cash-in**
  /// uses the recorded cash-in amount ([completeCashMovement]).
  final int? autoAllocationPercent;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Progress in 0..1
  double get progressRatio {
    if (targetAmount <= 0) return 0;
    return min(1, max(0, savedAmount / targetAmount));
  }

  /// Progress 0..100
  int get progressPercent => (progressRatio * 100).round();

  PersonalGoal copyWith({
    String? id,
    String? branchId,
    String? name,
    double? savedAmount,
    double? targetAmount,
    bool? isTopPriority,
    int? autoAllocationPercent,
    String? note,
    bool clearAutoAllocationPercent = false,
    bool clearNote = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PersonalGoal(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      savedAmount: savedAmount ?? this.savedAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      isTopPriority: isTopPriority ?? this.isTopPriority,
      autoAllocationPercent: clearAutoAllocationPercent
          ? null
          : (autoAllocationPercent ?? this.autoAllocationPercent),
      note: clearNote ? null : (note ?? this.note),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'branchId': branchId,
      'name': name,
      'savedAmount': savedAmount,
      'targetAmount': targetAmount,
      'isTopPriority': isTopPriority,
      if (autoAllocationPercent != null)
        'autoAllocationPercent': autoAllocationPercent,
      if (note != null && note!.isNotEmpty) 'note': note,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  static PersonalGoal fromJson(Map<String, dynamic> raw) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    final id =
        raw['_id']?.toString() ?? raw['id']?.toString() ?? '';
    return PersonalGoal(
      id: id,
      branchId: raw['branchId']?.toString() ?? '',
      name: raw['name']?.toString() ?? '',
      savedAmount: toDouble(raw['savedAmount']),
      targetAmount: toDouble(raw['targetAmount']),
      isTopPriority: raw['isTopPriority'] == true,
      autoAllocationPercent: (raw['autoAllocationPercent'] as num?)?.toInt(),
      note: raw['note']?.toString(),
      createdAt: parseDt(raw['createdAt']),
      updatedAt: parseDt(raw['updatedAt']),
    );
  }
}
