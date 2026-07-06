/// Per-branch Bar Mode settings (Ditto `bar_branch_settings` collection).
class BarBranchSettings {
  const BarBranchSettings({
    required this.branchId,
    this.enabled = false,
    this.requirePin = true,
    this.floorFirst = true,
    this.managerSettle = true,
    this.autoLogout = false,
    this.updatedAt,
  });

  final String branchId;
  final bool enabled;
  final bool requirePin;
  final bool floorFirst;
  final bool managerSettle;
  final bool autoLogout;
  final DateTime? updatedAt;

  BarBranchSettings copyWith({
    String? branchId,
    bool? enabled,
    bool? requirePin,
    bool? floorFirst,
    bool? managerSettle,
    bool? autoLogout,
    DateTime? updatedAt,
  }) {
    return BarBranchSettings(
      branchId: branchId ?? this.branchId,
      enabled: enabled ?? this.enabled,
      requirePin: requirePin ?? this.requirePin,
      floorFirst: floorFirst ?? this.floorFirst,
      managerSettle: managerSettle ?? this.managerSettle,
      autoLogout: autoLogout ?? this.autoLogout,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': branchId,
      'id': branchId,
      'branchId': branchId,
      'enabled': enabled,
      'requirePin': requirePin,
      'floorFirst': floorFirst,
      'managerSettle': managerSettle,
      'autoLogout': autoLogout,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  static BarBranchSettings fromJson(Map<String, dynamic> raw) {
    bool toBool(dynamic v, {required bool fallback}) {
      if (v == null) return fallback;
      if (v is bool) return v;
      if (v == 1 || v == '1' || v == 'true') return true;
      if (v == 0 || v == '0' || v == 'false') return false;
      return fallback;
    }

    final branchId = (raw['branchId'] ?? raw['id'] ?? raw['_id'] ?? '')
        .toString();
    final updatedRaw = raw['updatedAt'];
    return BarBranchSettings(
      branchId: branchId,
      enabled: toBool(raw['enabled'], fallback: false),
      requirePin: toBool(raw['requirePin'], fallback: true),
      floorFirst: toBool(raw['floorFirst'], fallback: true),
      managerSettle: toBool(raw['managerSettle'], fallback: true),
      autoLogout: toBool(raw['autoLogout'], fallback: false),
      updatedAt: updatedRaw == null
          ? null
          : DateTime.tryParse(updatedRaw.toString()),
    );
  }

  static BarBranchSettings defaults(String branchId) =>
      BarBranchSettings(branchId: branchId);
}
