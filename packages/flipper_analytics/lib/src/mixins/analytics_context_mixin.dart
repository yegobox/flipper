import '../interfaces/analytics_context_provider.dart';

mixin AnalyticsContextMixin {
  AnalyticsContextProvider get contextProvider;

  Map<String, Object?> withContext(Map<String, Object?> properties) {
    return {
      ...contextProvider.buildBaseProperties(),
      ...properties,
    };
  }
}
