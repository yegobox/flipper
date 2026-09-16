/// Where a stamp sits on a generated document.
enum DocumentStampPlacement {
  bottomRight,
  bottomLeft,
  bottomCentre,

  /// Inline with the totals block rather than at the page edge.
  besideTotals,
}

DocumentStampPlacement documentStampPlacementFromString(String? raw) {
  switch (raw?.trim()) {
    case 'bottomLeft':
      return DocumentStampPlacement.bottomLeft;
    case 'bottomCentre':
    case 'bottomCenter':
      return DocumentStampPlacement.bottomCentre;
    case 'besideTotals':
      return DocumentStampPlacement.besideTotals;
    default:
      return DocumentStampPlacement.bottomRight;
  }
}

/// Per-branch document branding (Ditto `branch_document_settings`, `_id ==
/// branchId`).
///
/// Deliberately its own collection rather than a few more fields on
/// `hotel_branch_settings`: the stamp also goes on the leads proforma, which
/// is used by branches that never turn Hotel Mode on and would therefore never
/// write that document.
///
/// Distinct from `receiptLogoBase64`, which is a device-local SharedPreferences
/// value for thermal receipts. This one syncs, so every terminal at a branch
/// stamps the same way.
class BranchDocumentSettings {
  const BranchDocumentSettings({
    required this.branchId,
    this.stampEnabled = false,
    this.stampImageBase64,
    this.stampPlacement = DocumentStampPlacement.bottomRight,
    this.stampWidthMm = 38,
    this.stampAspectRatio = 1.0,
    this.updatedAt,
  });

  /// Doubles as the Ditto document id.
  final String branchId;

  final bool stampEnabled;

  /// PNG or JPEG, base64. Capped on the way in at
  /// [maxStampBytes] — this document replicates to every device on the branch,
  /// so it cannot carry the 295 KB the receipt logo allows.
  final String? stampImageBase64;

  final DocumentStampPlacement stampPlacement;

  /// Rendered width in millimetres. Height follows [stampAspectRatio].
  final double stampWidthMm;

  /// height / width, captured at upload. Stored because Syncfusion's
  /// `drawImage` takes an explicit rect and will happily distort an image;
  /// without this the proforma stamp would not match the quotation's.
  final double stampAspectRatio;

  final DateTime? updatedAt;

  /// 64 KB raw (~88 KB base64).
  static const int maxStampBytes = 64 * 1024;

  static const double minStampWidthMm = 20;
  static const double maxStampWidthMm = 60;

  /// Whether a document should actually draw a stamp.
  bool get hasStamp =>
      stampEnabled &&
      stampImageBase64 != null &&
      stampImageBase64!.isNotEmpty;

  BranchDocumentSettings copyWith({
    String? branchId,
    bool? stampEnabled,
    String? stampImageBase64,

    /// `copyWith` cannot pass null to mean "remove", so clearing the stamp
    /// needs its own flag.
    bool clearStampImage = false,
    DocumentStampPlacement? stampPlacement,
    double? stampWidthMm,
    double? stampAspectRatio,
    DateTime? updatedAt,
  }) {
    return BranchDocumentSettings(
      branchId: branchId ?? this.branchId,
      stampEnabled: stampEnabled ?? this.stampEnabled,
      stampImageBase64: clearStampImage
          ? null
          : (stampImageBase64 ?? this.stampImageBase64),
      stampPlacement: stampPlacement ?? this.stampPlacement,
      stampWidthMm: stampWidthMm ?? this.stampWidthMm,
      stampAspectRatio: stampAspectRatio ?? this.stampAspectRatio,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': branchId,
      'id': branchId,
      'branchId': branchId,
      'stampEnabled': stampEnabled,
      // Written even when null: Ditto's ON ID CONFLICT DO UPDATE leaves
      // omitted fields untouched, so omitting a removed stamp would leave it
      // alive on every other device. Same trap as
      // hotel_branch_settings.dart's roomChargeVariantId.
      'stampImageBase64': stampImageBase64,
      'stampPlacement': stampPlacement.name,
      'stampWidthMm': stampWidthMm,
      'stampAspectRatio': stampAspectRatio,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  static BranchDocumentSettings fromJson(Map<String, dynamic> raw) {
    bool toBool(dynamic v, {required bool fallback}) {
      if (v == null) return fallback;
      if (v is bool) return v;
      if (v == 1 || v == '1' || v == 'true') return true;
      if (v == 0 || v == '0' || v == 'false') return false;
      return fallback;
    }

    double toDouble(dynamic v, {required double fallback}) {
      if (v == null) return fallback;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    final image = raw['stampImageBase64']?.toString();

    return BranchDocumentSettings(
      branchId: (raw['branchId'] ?? raw['id'] ?? raw['_id'] ?? '').toString(),
      stampEnabled: toBool(raw['stampEnabled'], fallback: false),
      stampImageBase64: (image == null || image.isEmpty) ? null : image,
      stampPlacement: documentStampPlacementFromString(
        raw['stampPlacement']?.toString(),
      ),
      stampWidthMm: toDouble(raw['stampWidthMm'], fallback: 38).clamp(
        minStampWidthMm,
        maxStampWidthMm,
      ),
      // A zero or negative ratio would collapse the image to nothing, so a bad
      // value falls back to square rather than rendering an invisible stamp.
      stampAspectRatio: _saneRatio(toDouble(raw['stampAspectRatio'], fallback: 1)),
      updatedAt: raw['updatedAt'] == null
          ? null
          : DateTime.tryParse(raw['updatedAt'].toString()),
    );
  }

  static double _saneRatio(double value) {
    if (value.isNaN || value <= 0 || value.isInfinite) return 1.0;
    return value.clamp(0.1, 10.0);
  }

  static BranchDocumentSettings defaults(String branchId) =>
      BranchDocumentSettings(branchId: branchId);
}
