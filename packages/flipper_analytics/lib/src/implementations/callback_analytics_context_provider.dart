import '../events/analytics_properties.dart';
import '../interfaces/analytics_context_provider.dart';

typedef AnalyticsStringGetter = String? Function();

class CallbackAnalyticsContextProvider implements AnalyticsContextProvider {
  const CallbackAnalyticsContextProvider({
    required this.appName,
    required this.platformName,
    required this.buildMode,
    this.appVersion,
    this.releaseCommit,
    this.userIdGetter,
    this.businessIdGetter,
    this.branchIdGetter,
  });

  final String appName;
  final String platformName;
  final String buildMode;

  /// The release CI stamped into this build (e.g. the msix `1.605.0.0`), so a
  /// stall report says which build hung. Empty on local builds.
  final String? appVersion;

  /// The commit the build came from; a launcher build has no msix version.
  final String? releaseCommit;
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
      if (appVersion?.isNotEmpty ?? false)
        AnalyticsProperties.appVersion: appVersion,
      if (releaseCommit?.isNotEmpty ?? false)
        AnalyticsProperties.releaseCommit: releaseCommit,
      if (userId != null) AnalyticsProperties.userId: userId,
      if (businessId != null) AnalyticsProperties.businessId: businessId,
      if (branchId != null) AnalyticsProperties.branchId: branchId,
    };
  }
}
