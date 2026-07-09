abstract class AnalyticsContextProvider {
  Map<String, Object?> buildBaseProperties();

  String? get userId;

  String? get businessId;

  String? get branchId;
}
