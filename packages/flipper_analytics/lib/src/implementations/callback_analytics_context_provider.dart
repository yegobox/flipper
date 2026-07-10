import '../events/analytics_properties.dart';
import '../interfaces/analytics_context_provider.dart';

typedef AnalyticsStringGetter = String? Function();

class CallbackAnalyticsContextProvider implements AnalyticsContextProvider {
  const CallbackAnalyticsContextProvider({
    required this.appName,
    required this.platformName,
    required this.buildMode,
    this.userIdGetter,
    this.businessIdGetter,
    this.branchIdGetter,
  });

  final String appName;
  final String platformName;
  final String buildMode;
  final AnalyticsStringGetter? userIdGetter;
  final AnalyticsStringGetter? businessIdGetter;
  final AnalyticsStringGetter? branchIdGetter;

  @override
  String? get branchId => branchIdGetter?.call();

  @override
  String? get businessId => businessIdGetter?.call();

  @override
  String? get userId => userIdGetter?.call();

  @override
  Map<String, Object?> buildBaseProperties() {
    return {
      AnalyticsProperties.app: appName,
      AnalyticsProperties.platform: platformName,
      AnalyticsProperties.buildMode: buildMode,
      if (userId != null) AnalyticsProperties.userId: userId,
      if (businessId != null) AnalyticsProperties.businessId: businessId,
      if (branchId != null) AnalyticsProperties.branchId: branchId,
    };
  }
}
