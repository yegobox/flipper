/// Ditto `daily_report_files` catalogue row (written by data-connector daily report scheduler).
class DailyReportFile {
  DailyReportFile({
    required this.id,
    required this.branchId,
    required this.type,
    this.businessId,
    this.day,
    this.fileName,
    this.s3Url,
    this.s3ObjectKey,
    this.folder,
    this.runId,
    this.createdAt,
    this.implementation,
    this.archivedAt,
  });

  /// Matches data-connector `daily-detailed-transactions-xlsx`.
  static const String dailyDetailedTransactionsXlsxType =
      'daily-detailed-transactions-xlsx';

  final String id;
  final String branchId;
  final String type;
  final String? businessId;
  /// Report date `YYYY-MM-DD`.
  final String? day;
  final String? fileName;
  final String? s3Url;
  final String? s3ObjectKey;
  final String? folder;
  final String? runId;
  final DateTime? createdAt;
  final String? implementation;
  /// When set, the file is hidden from the default list (soft archive).
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;

  factory DailyReportFile.fromDittoMap(Map<String, dynamic> m) {
    final rawId = (m['_id'] ?? m['id'])?.toString().trim() ?? '';
    // Some legacy/migrated rows may not have `_id`/`id` set; use a stable unique fallback
    // so UI row-level loading/selection doesn't affect every row.
    final id = rawId.isNotEmpty
        ? rawId
        : (m['s3ObjectKey']?.toString().trim().isNotEmpty ?? false)
            ? m['s3ObjectKey']!.toString().trim()
            : (m['fileName']?.toString().trim().isNotEmpty ?? false)
                ? m['fileName']!.toString().trim()
                : [
                    m['branchId']?.toString().trim(),
                    m['type']?.toString().trim(),
                    m['day']?.toString().trim(),
                    m['createdAt']?.toString().trim(),
                  ].whereType<String>().where((s) => s.isNotEmpty).join('|');
    return DailyReportFile(
      id: id,
      branchId: m['branchId']?.toString() ?? '',
      businessId: m['businessId']?.toString(),
      type: m['type']?.toString() ?? '',
      day: m['day']?.toString(),
      fileName: m['fileName']?.toString(),
      s3Url: m['s3Url']?.toString(),
      s3ObjectKey: m['s3ObjectKey']?.toString(),
      folder: m['folder']?.toString(),
      runId: m['runId']?.toString(),
      createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? ''),
      implementation: m['implementation']?.toString(),
      archivedAt: DateTime.tryParse(m['archivedAt']?.toString() ?? ''),
    );
  }
}
