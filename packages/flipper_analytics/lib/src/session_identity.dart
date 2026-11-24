import 'events/analytics_properties.dart';
import 'interfaces/product_analytics.dart';

/// Ties what follows to the signed-in Flipper user and their business and
/// branch, so PostHog can count people, shops and tills.
///
/// [userId] is the Flipper user id that POS and Books both sign in with, so
/// one person spans the apps. Without one nobody is identified: a shared
/// placeholder id would merge strangers into one person. Contact details
/// (phone, email) are never sent.
///
/// [businessName] and [branchName], when known, label the groups in PostHog.
Future<void> identifySession(
  ProductAnalytics analytics, {
  required String source,
  String? userId,
  String? businessId,
  String? branchId,
  String? businessName,
  String? branchName,
}) async {
  if (userId != null && userId.isNotEmpty) {
    await analytics.identify(userId, properties: {'source': source});
  }
  if (businessId != null && businessId.isNotEmpty) {
    await analytics.group(
      AnalyticsGroups.business,
      businessId,
      properties: {
        'source': source,
        if (businessName != null && businessName.isNotEmpty)
          'business_name': businessName,
      },
    );
  }
  if (branchId != null && branchId.isNotEmpty) {
    await analytics.group(
      AnalyticsGroups.branch,
      branchId,
      properties: {
        'source': source,
        if (businessId != null && businessId.isNotEmpty)
          AnalyticsProperties.businessId: businessId,
        if (branchName != null && branchName.isNotEmpty)
          'branch_name': branchName,
      },
    );
  }
}
