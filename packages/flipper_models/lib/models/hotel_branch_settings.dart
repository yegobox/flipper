/// Per-branch Hotel Mode settings (Ditto `hotel_branch_settings` collection).
class HotelBranchSettings {
  const HotelBranchSettings({
    required this.branchId,
    this.enabled = false,
    this.autoPostRoomCharge = true,
    this.managerCheckout = true,
    this.requirePin = true,
    this.autoLogout = false,
    this.checkOutHour = 11,
    this.roomChargeVariantId,
    this.updatedAt,
  });

  final String branchId;

  /// Whether the front desk replaces the ordinary POS on this branch.
  final bool enabled;

  /// Post `nights × rate` to the folio automatically at check-in.
  ///
  /// Requires [roomChargeVariantId]; without a registered product there is no
  /// RRA `itemCd` and the charge cannot legally be invoiced.
  final bool autoPostRoomCharge;

  /// Require a manager PIN before settling a folio at checkout.
  final bool managerCheckout;

  /// Lock the desk behind a staff PIN, so one terminal can be shared.
  final bool requirePin;

  /// Return to the PIN lock after a checkout completes.
  final bool autoLogout;

  /// House checkout time (0–23), used to default the departure date/time.
  final int checkOutHour;

  /// Variant used for the nightly room charge line.
  final String? roomChargeVariantId;

  final DateTime? updatedAt;

  /// Room charges can only be posted when a registered product backs them.
  bool get canAutoPostRoomCharge =>
      autoPostRoomCharge &&
      roomChargeVariantId != null &&
      roomChargeVariantId!.isNotEmpty;

  HotelBranchSettings copyWith({
    String? branchId,
    bool? enabled,
    bool? autoPostRoomCharge,
    bool? managerCheckout,
    bool? requirePin,
    bool? autoLogout,
    int? checkOutHour,
    String? roomChargeVariantId,
    DateTime? updatedAt,
  }) {
    return HotelBranchSettings(
      branchId: branchId ?? this.branchId,
      enabled: enabled ?? this.enabled,
      autoPostRoomCharge: autoPostRoomCharge ?? this.autoPostRoomCharge,
      managerCheckout: managerCheckout ?? this.managerCheckout,
      requirePin: requirePin ?? this.requirePin,
      autoLogout: autoLogout ?? this.autoLogout,
      checkOutHour: checkOutHour ?? this.checkOutHour,
      roomChargeVariantId: roomChargeVariantId ?? this.roomChargeVariantId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': branchId,
      'id': branchId,
      'branchId': branchId,
      'enabled': enabled,
      'autoPostRoomCharge': autoPostRoomCharge,
      'managerCheckout': managerCheckout,
      'requirePin': requirePin,
      'autoLogout': autoLogout,
      'checkOutHour': checkOutHour,
      if (roomChargeVariantId != null)
        'roomChargeVariantId': roomChargeVariantId,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  static HotelBranchSettings fromJson(Map<String, dynamic> raw) {
    bool toBool(dynamic v, {required bool fallback}) {
      if (v == null) return fallback;
      if (v is bool) return v;
      if (v == 1 || v == '1' || v == 'true') return true;
      if (v == 0 || v == '0' || v == 'false') return false;
      return fallback;
    }

    int toInt(dynamic v, {required int fallback}) {
      if (v == null) return fallback;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? fallback;
    }

    final branchId = (raw['branchId'] ?? raw['id'] ?? raw['_id'] ?? '')
        .toString();
    final updatedRaw = raw['updatedAt'];
    final variantId = raw['roomChargeVariantId']?.toString();

    return HotelBranchSettings(
      branchId: branchId,
      enabled: toBool(raw['enabled'], fallback: false),
      autoPostRoomCharge: toBool(raw['autoPostRoomCharge'], fallback: true),
      managerCheckout: toBool(raw['managerCheckout'], fallback: true),
      requirePin: toBool(raw['requirePin'], fallback: true),
      autoLogout: toBool(raw['autoLogout'], fallback: false),
      checkOutHour: toInt(raw['checkOutHour'], fallback: 11),
      roomChargeVariantId: (variantId == null || variantId.isEmpty)
          ? null
          : variantId,
      updatedAt: updatedRaw == null
          ? null
          : DateTime.tryParse(updatedRaw.toString()),
    );
  }

  static HotelBranchSettings defaults(String branchId) =>
      HotelBranchSettings(branchId: branchId);
}
